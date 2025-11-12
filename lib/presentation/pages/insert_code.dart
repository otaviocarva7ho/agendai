import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InserirCodigoPage extends StatefulWidget {
  const InserirCodigoPage({super.key});

  @override
  State<InserirCodigoPage> createState() => _InserirCodigoPageState();
}

class _InserirCodigoPageState extends State<InserirCodigoPage> {
  final _formKey = GlobalKey<FormState>();
  final _ctrl = TextEditingController();
  bool _valid = false;

  // ---- Helpers de formatação/validação ----
  static final _allowed = RegExp(r'[A-Za-z0-9]');

  String _normalize(String text) {
    // remove tudo que não é alfanumérico
    final only = text.toUpperCase().split('').where(_allowed.hasMatch).join();
    // limita a 8 e injeta traço após 4 -> ABCD-1234
    final trimmed = only.substring(0, only.length.clamp(0, 8));
    if (trimmed.length <= 4) return trimmed;
    return '${trimmed.substring(0, 4)}-${trimmed.substring(4)}';
  }

  bool _isValid(String text) {
    return RegExp(r'^[A-Z0-9]{4}-[A-Z0-9]{4}$').hasMatch(text);
  }

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() {
      final formatted = _normalize(_ctrl.text);
      if (_ctrl.text != formatted) {
        final pos = formatted.length;
        _ctrl.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: pos),
        );
      }
      setState(() => _valid = _isValid(_ctrl.text));
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _colar() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text == null) return;
    _ctrl.text = _normalize(data!.text!);
  }

  void _continuar() {
    if (!_valid) return;
    Navigator.pop(context, _ctrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir código'),
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            // Header “bonito”
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cs.primary.withOpacity(.18),
                    cs.primary.withOpacity(.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(.08)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(.20),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.link, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Entrar com código',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                )),
                        const SizedBox(height: 4),
                        Opacity(
                          opacity: .80,
                          child: Text(
                            'Cole ou digite o código no formato ABCD-1234.',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Código da reunião',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _ctrl,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(
                      letterSpacing: 1.6,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: 'ABCD-1234',
                      prefixIcon: const Icon(Icons.confirmation_number_outlined),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Colar',
                            onPressed: _colar,
                            icon: const Icon(Icons.content_paste),
                          ),
                          if (_ctrl.text.isNotEmpty)
                            IconButton(
                              tooltip: 'Limpar',
                              onPressed: () => _ctrl.clear(),
                              icon: const Icon(Icons.clear),
                            ),
                        ],
                      ),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: cs.primary, width: 1.4),
                      ),
                    ),
                    validator: (v) =>
                        _isValid(v ?? '') ? null : 'Use o formato ABCD-1234',
                    onFieldSubmitted: (_) => _continuar(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16),
                      const SizedBox(width: 6),
                      Opacity(
                        opacity: .75,
                        child: Text(
                          _valid ? 'Código válido' : '8 caracteres alfanuméricos',
                          style: TextStyle(
                            fontSize: 12,
                            color: _valid ? cs.primary : Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Botão principal
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _valid ? _continuar : null,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Continuar'),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Alternativa: QR Code (placeholder)
            OutlinedButton.icon(
              onPressed: () {
                // TODO: abrir câmera/QR (ex.: package mobile_scanner / qr_code_scanner)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Scanner de QR ainda não implementado.')),
                );
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Ler QR Code'),
              ),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
