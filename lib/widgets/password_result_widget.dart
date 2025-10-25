import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordResultWidget extends StatelessWidget {
  final String password;
  final VoidCallback onRegenerate;

  const PasswordResultWidget({
    super.key,
    required this.password,
    required this.onRegenerate,
  });

  void _copyToClipboard(BuildContext context, String password) {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Senha copiada!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              password,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontFamily: 'monospace'), // Fonte monoespaçada
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => _copyToClipboard(context, password),
                tooltip: "Copiar",
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: onRegenerate,
                tooltip: "Gerar Novamente",
              ),
            ],
          )
        ],
      ),
    );
  }
}