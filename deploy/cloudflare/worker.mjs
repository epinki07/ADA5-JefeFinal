import { DurableObject } from 'cloudflare:workers';

const apiRoutes = /^\/(?:products|categories|sales|purchases|assistant)(?:\/|$)/;
const publicRoutes = /^\/(?:healthz$|catalog-images\/)/;
const bearerToken = /^Bearer +\S+$/i;

export default {
  fetch(request, env) {
    const { pathname } = new URL(request.url);
    if (!publicRoutes.test(pathname)) {
      if (!apiRoutes.test(pathname)) {
        return new Response(null, { status: 404 });
      }
      if (!bearerToken.test(request.headers.get('authorization') ?? '')) {
        return new Response(null, {
          status: 401,
          headers: { 'WWW-Authenticate': 'Bearer', 'Cache-Control': 'no-store' },
        });
      }
    }
    return env.ADA5_API.getByName('api').fetch(request);
  },
};

export class Ada5Api extends DurableObject {
  async fetch(request) {
    const container = this.ctx.container;
    try {
      if (!this.starting && !container.running) {
        const { DB_URL, DB_USER, DB_PASSWORD, ADA5_FIREBASE_PROJECT_ID } = this.env;
        if (!DB_URL || !DB_USER || !DB_PASSWORD || !ADA5_FIREBASE_PROJECT_ID) {
          throw new Error('Missing the ADA5 database or Firebase configuration.');
        }
        container.start({
          enableInternet: true,
          env: {
            DB_URL,
            DB_USER,
            DB_PASSWORD,
            ADA5_FIREBASE_PROJECT_ID,
            ADA5_OPERATOR_UIDS: this.env.ADA5_OPERATOR_UIDS ?? '',
            GEMINI_API_KEY: this.env.GEMINI_API_KEY ?? '',
          },
        });
        this.starting = this.waitUntilReady(container).finally(() => {
          this.starting = undefined;
        });
      }
      if (this.starting) await this.starting;

      const url = new URL(request.url);
      const forwarded = new Request(`http://container${url.pathname}${url.search}`, request);
      forwarded.headers.delete('Host');
      return await container.getTcpPort(8090).fetch(forwarded);
    } catch {
      console.error('ADA5 container unavailable');
      return Response.json({ status: 'unavailable' }, {
        status: 503,
        headers: { 'Cache-Control': 'no-store', 'Retry-After': '3' },
      });
    }
  }

  async waitUntilReady(container) {
    await container.setInactivityTimeout(10 * 60 * 1000);
    const port = container.getTcpPort(8090);
    const deadline = Date.now() + 20_000;
    while (Date.now() < deadline) {
      try {
        const health = await port.fetch('http://container/healthz', {
          signal: AbortSignal.timeout(1_000),
        });
        await health.body?.cancel();
        if (health.ok) return;
      } catch {
        // The Spring server may still be opening its port and database pool.
      }
      await new Promise(resolve => setTimeout(resolve, 500));
    }
    throw new Error('The ADA5 API did not become ready in time.');
  }
}
