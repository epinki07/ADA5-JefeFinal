import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../product_api.dart';

class ShoppingAssistantScreen extends StatefulWidget {
  const ShoppingAssistantScreen({super.key, required this.api});

  final ProductApi api;

  @override
  State<ShoppingAssistantScreen> createState() =>
      _ShoppingAssistantScreenState();
}

class _ShoppingAssistantScreenState extends State<ShoppingAssistantScreen> {
  final _questionController = TextEditingController();
  bool _loading = false;
  String? _answer;
  String? _error;

  Future<void> _ask() async {
    final question = _questionController.text.trim();
    if (question.isEmpty) {
      setState(() => _error = 'Escribe una pregunta sobre el catálogo.');
      return;
    }
    setState(() {
      _loading = true;
      _answer = null;
      _error = null;
    });
    try {
      final answer = await widget.api.askAssistant(question);
      if (mounted) setState(() => _answer = answer);
    } on ProductApiException catch (exception) {
      if (mounted) {
        setState(
          () => _error = exception.statusCode == 503
              ? 'El asistente no está disponible ahora. Inténtalo más tarde.'
              : 'No se pudo responder la pregunta. Inténtalo de nuevo.',
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'No se pudo conectar con el asistente.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asistente de compras')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Pregunta por productos, categorías, precios o existencias.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _questionController,
            maxLength: 500,
            maxLines: 3,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _loading ? null : _ask(),
            decoration: const InputDecoration(
              labelText: 'Tu pregunta',
              hintText: '¿Qué frutas hay disponibles?',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _loading ? null : _ask,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Preguntar'),
          ),
          if (_loading) ...[
            const SizedBox(height: 24),
            Center(
              child: MediaQuery.disableAnimationsOf(context)
                  ? const Icon(Icons.auto_awesome, size: 72)
                  : Lottie.asset(
                      'assets/assistant_pulse.json',
                      width: 88,
                      height: 88,
                    ),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 24),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          if (_answer != null) ...[
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(_answer!),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }
}
