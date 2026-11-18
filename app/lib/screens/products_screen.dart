import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../product_api.dart';
import 'login_screen.dart';
import 'product_form_screen.dart';
import 'settings_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _api = ProductApi();
  final _searchController = TextEditingController();
  final _speech = SpeechToText();
  late Future<List<Map<String, dynamic>>> _products;
  String _query = '';
  int? _categoryId;
  bool _speechReady = false;
  bool _listening = false;

  @override
  void initState() {
    super.initState();
    _products = _api.getProducts();
  }

  void _retry() => setState(() => _products = _api.getProducts());

  Future<void> _toggleSpeech() async {
    if (_listening) {
      await _speech.stop();
      if (mounted) setState(() => _listening = false);
      return;
    }
    try {
      if (!_speechReady) {
        _speechReady = await _speech.initialize(
          onStatus: (_) {
            if (mounted) setState(() => _listening = _speech.isListening);
          },
          onError: (_) {
            if (mounted) setState(() => _listening = false);
          },
        );
      }
      if (!_speechReady) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('El reconocimiento de voz no está disponible.'),
            ),
          );
        }
        return;
      }
      await _speech.listen(
        onResult: (result) {
          if (!mounted) return;
          _searchController.text = result.recognizedWords;
          setState(() => _query = result.recognizedWords);
        },
      );
      if (mounted) setState(() => _listening = _speech.isListening);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo iniciar la búsqueda por voz.'),
          ),
        );
      }
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Map<int, String> _categories(List<Map<String, dynamic>> products) {
    final result = <int, String>{};
    for (final product in products) {
      final id = product['categoryId'];
      final category = product['category'];
      if (id is int && category is Map) {
        result[id] = category['category']?.toString() ?? 'Categoría $id';
      }
    }
    return result;
  }

  Future<void> _openForm(
    Map<int, String> categories, [
    Map<String, dynamic>? product,
  ]) async {
    if (categories.isEmpty) {
      try {
        categories = await _api.getCategories();
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudieron cargar las categorías.'),
            ),
          );
        }
        return;
      }
    }
    if (!mounted) return;
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFormScreen(
          api: _api,
          categories: categories,
          product: product,
        ),
      ),
    );
    if (saved == true && mounted) _retry();
  }

  Future<void> _delete(Map<String, dynamic> product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('¿Eliminar ${product['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await _api.deleteProduct(product['productId'] as int);
      if (mounted) _retry();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo eliminar el producto. Inténtalo de nuevo.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de productos'),
        actions: [
          IconButton(
            tooltip: 'Configuración',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            tooltip: 'Actualizar',
            onPressed: _retry,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Servidor no disponible. Comprueba tu conexión y vuelve a intentar.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _retry,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final products = snapshot.data ?? [];
          final categories = _categories(products);
          final visible = products.where((product) {
            final name = product['name']?.toString().toLowerCase() ?? '';
            return name.contains(_query.toLowerCase()) &&
                (_categoryId == null || product['categoryId'] == _categoryId);
          }).toList();

          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Buscar productos',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => setState(() => _query = value),
                    ),
                  ),
                  IconButton(
                    tooltip: _listening
                        ? 'Detener búsqueda por voz'
                        : 'Buscar por voz',
                    onPressed: _toggleSpeech,
                    icon: Icon(_listening ? Icons.mic : Icons.mic_none),
                  ),
                  if (categories.isNotEmpty)
                    SizedBox(
                      height: 48,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          const SizedBox(width: 12),
                          ChoiceChip(
                            label: const Text('Todas'),
                            selected: _categoryId == null,
                            onSelected: (_) =>
                                setState(() => _categoryId = null),
                          ),
                          ...categories.entries.map(
                            (entry) => Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: ChoiceChip(
                                label: Text(entry.value),
                                selected: _categoryId == entry.key,
                                onSelected: (_) =>
                                    setState(() => _categoryId = entry.key),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: visible.isEmpty
                        ? const Center(
                            child: Text('No hay productos para mostrar.'),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              final columns = constraints.maxWidth >= 680
                                  ? 3
                                  : constraints.maxWidth >= 420
                                  ? 2
                                  : 1;
                              return GridView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  12,
                                  12,
                                  84,
                                ),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: columns,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      mainAxisExtent: 300,
                                    ),
                                itemCount: visible.length,
                                itemBuilder: (context, index) {
                                  final product = visible[index];
                                  final category = product['category'];
                                  final categoryName = category is Map
                                      ? category['category']?.toString() ??
                                            'Sin categoría'
                                      : 'Sin categoría';
                                  final imageUrl =
                                      product['imageUrl']?.toString() ?? '';
                                  final price =
                                      (product['price'] as num?)?.toDouble() ??
                                      0;
                                  final stock =
                                      (product['stock'] as num?)?.toInt() ?? 0;
                                  return Card(
                                    clipBehavior: Clip.antiAlias,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 120,
                                          width: double.infinity,
                                          child: imageUrl.isEmpty
                                              ? const Icon(
                                                  Icons.image_not_supported,
                                                  size: 48,
                                                )
                                              : Image.network(
                                                  imageUrl,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, _, _) =>
                                                      const Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        size: 48,
                                                      ),
                                                ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            12,
                                            8,
                                            12,
                                            0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product['name']?.toString() ??
                                                    'Sin nombre',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                              Text(
                                                categoryName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                '\$${price.toStringAsFixed(2)}',
                                              ),
                                              Text(
                                                stock < 50
                                                    ? 'Poco stock: $stock'
                                                    : 'Stock: $stock',
                                                style: TextStyle(
                                                  color: stock < 50
                                                      ? Colors.deepOrange
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              tooltip: 'Editar',
                                              onPressed: () => _openForm(
                                                categories,
                                                product,
                                              ),
                                              icon: const Icon(Icons.edit),
                                            ),
                                            IconButton(
                                              tooltip: 'Eliminar',
                                              onPressed: () => _delete(product),
                                              icon: const Icon(
                                                Icons.delete_outline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton.extended(
                  onPressed: () => _openForm(categories),
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _speech.cancel();
    _searchController.dispose();
    super.dispose();
  }
}
