import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  static const route = '/success';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final code = 'HSAD - H21H - 671K - KLM9'; // código gerado (exemplo)

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF0B0F17),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // topo: botão voltar
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(26),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1A29),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white.withOpacity(.08)),
                    ),
                    child: const Icon(Icons.arrow_back, size: 22),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Text(
                'Reunião gerada com sucesso!',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 32),

              Opacity(
                opacity: .85,
                child: Text(
                  'Para acessar sua reunião copie o código abaixo:',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

              const SizedBox(height: 20),

              // código da reunião
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1A29),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: cs.primary.withOpacity(.4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        code,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: .5,
                          color: cs.primary,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: code));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Código copiado para a área de transferência!')),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: cs.primary.withOpacity(.5)),
                        ),
                        child: Icon(Icons.copy, size: 18, color: cs.primary),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // botão acompanhar reuniões
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    side: BorderSide(color: cs.primary.withOpacity(.6)),
                  ),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text(
                    'Acompanhar reuniões',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
