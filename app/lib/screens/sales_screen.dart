import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../product_api.dart';
import '../sales_api.dart';
import 'sale_form_screen.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key, required this.products, required this.sales});

  final ProductApi products;
  final SalesApi sales;

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  late Future<({List<SaleSummary> sales, bool hasNext})> _history;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _history = widget.sales.getHistory(_page);
  }

  void _load(int page) {
    setState(() {
      _page = page;
      _history = widget.sales.getHistory(page);
    });
  }

  Future<void> _newSale() async {
    final receipt = await Navigator.push<SaleReceipt>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            SaleFormScreen(products: widget.products, sales: widget.sales),
      ),
    );
    if (receipt == null || !mounted) return;
    _load(0);
    _openReceipt(receipt.summary.id, receipt);
  }

  void _openReceipt(int id, [SaleReceipt? receipt]) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => _ReceiptScreen(
          load: () => receipt == null
              ? widget.sales.getReceipt(id)
              : Future.value(receipt),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas'),
        actions: [
          IconButton(
            tooltip: 'Actualizar historial',
            onPressed: () => _load(0),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: FilledButton.icon(
          onPressed: _newSale,
          icon: const Icon(Icons.add),
          label: const Text('Nueva venta'),
        ),
      ),
      body: FutureBuilder(
        future: _history,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: TextButton(
                onPressed: () => _load(_page),
                child: const Text('Error al cargar las ventas. Reintentar'),
              ),
            );
          }
          final history = snapshot.requireData;
          if (history.sales.isEmpty) {
            return const Center(child: Text('Aún no hay ventas registradas.'));
          }
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              for (final sale in history.sales)
                ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: Text('${sale.folio} · ${sale.customer}'),
                  subtitle: Text(
                    '${_date(sale.createdAt)} · ${sale.payment.label}',
                  ),
                  trailing: Text('\$${sale.total}'),
                  onTap: () => _openReceipt(sale.id),
                ),
              if (_page > 0 || history.hasNext)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _page == 0 ? null : () => _load(_page - 1),
                      child: const Text('Anterior'),
                    ),
                    Text('Página ${_page + 1}'),
                    TextButton(
                      onPressed: history.hasNext
                          ? () => _load(_page + 1)
                          : null,
                      child: const Text('Siguiente'),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ReceiptScreen extends StatefulWidget {
  const _ReceiptScreen({required this.load});

  final Future<SaleReceipt> Function() load;

  @override
  State<_ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<_ReceiptScreen> {
  late Future<SaleReceipt> _receipt;

  @override
  void initState() {
    super.initState();
    _receipt = widget.load();
  }

  Future<void> _copy(SaleReceipt receipt) async {
    final sale = receipt.summary;
    final text = [
      'Comprobante interno ${sale.folio}',
      _date(sale.createdAt),
      'Cliente  ${sale.customer}',
      'Pago  ${sale.payment.label}',
      for (final line in receipt.lines)
        '${line.quantity} × ${line.name} · \$${line.amount}',
      'Total  \$${sale.total} MXN',
    ].join('\n');
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Comprobante copiado.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comprobante interno')),
      body: FutureBuilder<SaleReceipt>(
        future: _receipt,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _receipt = widget.load();
                  });
                },
                child: const Text('Error al cargar el comprobante. Reintentar'),
              ),
            );
          }
          final receipt = snapshot.requireData;
          final sale = receipt.summary;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                sale.folio,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(_date(sale.createdAt)),
              const SizedBox(height: 12),
              Text(
                sale.customer,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(sale.payment.label),
              const SizedBox(height: 16),
              const Divider(),
              for (final line in receipt.lines)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(line.name),
                  subtitle: Text('${line.quantity} × \$${line.unitPrice}'),
                  trailing: Text('\$${line.amount}'),
                ),
              const Divider(),
              Text(
                'Total  \$${sale.total} MXN',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => _copy(receipt),
                icon: const Icon(Icons.copy),
                label: const Text('Copiar comprobante'),
              ),
            ],
          );
        },
      ),
    );
  }
}

String _date(DateTime date) {
  String two(int value) => value.toString().padLeft(2, '0');
  return '${two(date.day)}/${two(date.month)}/${date.year} '
      '${two(date.hour)}:${two(date.minute)}';
}
