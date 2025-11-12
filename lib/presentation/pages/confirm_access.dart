import 'package:flutter/material.dart';

class ConfirmarAcessoPage extends StatefulWidget {
  final String email;

  const ConfirmarAcessoPage({super.key, required this.email});

  @override
  State<ConfirmarAcessoPage> createState() => _ConfirmarAcessoPageState();
}

class _ConfirmarAcessoPageState extends State<ConfirmarAcessoPage> {
  final _codigoCtrl = List.generate(6, (_) => TextEditingController());
  bool _isLoading = false;

  @override
  void dispose() {
    for (final c in _codigoCtrl) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _confirmarCodigo() async {
    FocusScope.of(context).unfocus();

    final code = _codigoCtrl.map((c) => c.text).join();
    if (code.length < 6) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Digite o código completo.')));
      return;
    }

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Código confirmado!')));

    // volta ao Login limpando as telas de Cadastro/Confirmação
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _reenviarCodigo() {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Acabamos de reenviar um código de validação para o e-mail',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  widget.email,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Confirmar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0B0C0F),
                  const Color(0xFF12131A),
                  cs.primary.withOpacity(.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        size: 48, color: cs.primary),
                    const SizedBox(height: 16),
                    Text('Confirme seu acesso',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 24),

                    // Mensagem de envio do código
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: cs.primary),
                        borderRadius: BorderRadius.circular(12),
                        color: cs.surface.withOpacity(.3),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Acabamos de enviar um código de validação para o e-mail',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.email,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text('Digite o código abaixo para continuar:',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 16),

                    // Campos do código
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        6,
                        (i) => SizedBox(
                          width: 45,
                          child: TextField(
                            controller: _codigoCtrl[i],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            decoration: InputDecoration(
                              counterText: '',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: cs.primary),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: cs.primary, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (v) {
                              if (v.isNotEmpty && i < 5) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _confirmarCodigo,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Confirmar'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _reenviarCodigo,
                      child: Text(
                        'Não recebeu o código? Reenviar',
                        style: TextStyle(
                            color: cs.primary, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
