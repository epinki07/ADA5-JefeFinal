import 'dart:math';

import 'package:flutter/material.dart';

import '../product_api.dart';
import '../sales_api.dart';

class SaleFormScreen extends StatefulWidget {
  const SaleFormScreen({
    super.key,
    required this.products,
    required this.sales,
  });

  final ProductApi products;
  final SalesApi sales;

  @override
  State<SaleFormScreen> createState() => _SaleFormScreenState();
}

class _SaleFormScreenState extends State<SaleFormScreen> {
  final _customer = TextEditingController();
  final _quantities = <int, int>{};
  late Future<List<_SaleProduct>> _catalog;
  SalePayment _payment = SalePayment.cash;
  Map<String, Object>? _pendingOrder;
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _catalog = _loadProducts();
  }

  Future<List<_SaleProduct>> _loadProducts() async {
    final products = await widget.products.getProducts();
    return products
        .map(_SaleProduct.fromJson)
        .whereType<_SaleProduct>()
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  void _reload() {
    setState(() {
      _catalog = _loadProducts();
      _quantities.clear();
      _error = null;
    });
  }

  String _requestId() {
    final random = Random.secure();
    final bytes = List.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes
        .map((value) => value.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  Future<void> _submit(List<_SaleProduct> products) async {
    if (_saving || _quantities.isEmpty) return;

    final order = _pendingOrder ??= {
      'requestId': _requestId(),
      'customer': _customer.text.trim(),
      'payment': _payment.code,
      'items': [
        for (final product in products)
          if (_quantities.containsKey(product.id))
            {
              'productId': product.id,
              'quantity': _quantities[product.id],
              'unitPrice': _decimal(product.cents),
            },
      ],
    };
    FocusScope.of(context).unfocus();
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final receipt = await widget.sales.record(order);
      if (mounted) Navigator.pop(context, receipt);
    } on SaleRejected catch (error) {
      if (!mounted) return;
      setState(() {
        _pendingOrder = null;
        _error = error.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error =
            'No se pudo confirmar la venta. Reintenta para consultar '
            'la misma operación.';
      });
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _changeQuantity(int id, int quantity) {
    setState(() {
      if (quantity == 0) {
        _quantities.remove(id);
      } else {
        _quantities[id] = quantity;
      }
    });
  }

  String _decimal(int cents) =>
      '${cents ~/ 100}.${(cents % 100).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        appBar: AppBar(title: const Text('Nueva venta')),
        body: FutureBuilder<List<_SaleProduct>>(
          future: _catalog,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: TextButton(
                  onPressed: _reload,
                  child: const Text('Error al cargar productos. Reintentar'),
                ),
              );
            }
            final products = snapshot.requireData;
            if (products.isEmpty) {
              return Center(
                child: TextButton(
                  onPressed: _reload,
                  child: const Text('Sin productos disponibles. Actualizar'),
                ),
              );
            }

            final locked = _pendingOrder != null;
            final total = products.fold<int>(
              0,
              (sum, product) =>
                  sum + product.cents * (_quantities[product.id] ?? 0),
            );

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    children: [
                      TextField(
                        controller: _customer,
                        enabled: !locked,
                        textCapitalization: TextCapitalization.words,
                        maxLength: 100,
                        decoration: const InputDecoration(
                          labelText: 'Cliente (opcional)',
                          hintText: 'Público general',
                        ),
                      ),
                      DropdownButtonFormField<SalePayment>(
                        initialValue: _payment,
                        decoration: const InputDecoration(
                          labelText: 'Forma de pago',
                        ),
                        items: [
                          for (final payment in SalePayment.values)
                            DropdownMenuItem(
                              value: payment,
                              child: Text(payment.label),
                            ),
                        ],
                        onChanged: locked
                            ? null
                            : (value) => setState(() => _payment = value!),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Productos',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      for (final product in products)
                        _productRow(product, locked),
                    ],
                  ),
                ),
                SafeArea(
                  top: false,
                  minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_error != null)
                        Text(
                          _error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      if (_error != null && !locked)
                        TextButton(
                          onPressed: _reload,
                          child: const Text('Actualizar productos'),
                        ),
                      Text(
                        'Total estimado  \$${_decimal(total)} MXN',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      FilledButton(
                        onPressed: _saving || _quantities.isEmpty
                            ? null
                            : () => _submit(products),
                        child: Text(
                          _saving
                              ? 'Registrando…'
                              : locked
                              ? 'Reintentar registro'
                              : 'Registrar venta',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _productRow(_SaleProduct product, bool locked) {
    final quantity = _quantities[product.id] ?? 0;
    final canAdd =
        !locked &&
        quantity < product.stock &&
        (quantity > 0 || _quantities.length < 50);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(product.name),
      subtitle: Text(
        '\$${_decimal(product.cents)} · ${product.stock} disponibles',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Quitar ${product.name}',
            onPressed: !locked && quantity > 0
                ? () => _changeQuantity(product.id, quantity - 1)
                : null,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          Text('$quantity'),
          IconButton(
            tooltip: 'Agregar ${product.name}',
            onPressed: canAdd
                ? () => _changeQuantity(product.id, quantity + 1)
                : null,
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _customer.dispose();
    super.dispose();
  }
}

class _SaleProduct {
  const _SaleProduct(this.id, this.name, this.stock, this.cents);
  final int id;
  final String name;
  final int stock;
  final int cents;

  static _SaleProduct? fromJson(Map<String, dynamic> json) {
    final id = json['productId'];
    final name = json['name'];
    final price = json['price'];
    final stock = json['stock'];
    if (id is! int ||
        name is! String ||
        stock is! int ||
        stock < 1 ||
        price is! num ||
        !price.isFinite ||
        price < 0 ||
        price > 999999999.99) {
      return null;
    }
    // The server rounds the decimal form of the legacy catalog double.
    final cents = price < 0.005 ? 0 : _roundCents(price.toString());
    return _SaleProduct(id, name, min(stock, 1000000), cents);
  }

  static int _roundCents(String value) {
    final parts = value.split('.');
    final fraction = (parts.length == 2 ? parts.last : '').padRight(3, '0');
    return int.parse(parts.first) * 100 +
        int.parse(fraction.substring(0, 2)) +
        (int.parse(fraction[2]) >= 5 ? 1 : 0);
  }
}
