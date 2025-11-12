import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AccountType { cliente, empresa }

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  AccountType _type = AccountType.cliente;

  // controllers comuns
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  // só empresa
  final _cnpjCtrl = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _loading = false;

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _senhaCtrl.dispose();
    _confirmCtrl.dispose();
    _cnpjCtrl.dispose();
    super.dispose();
  }

  String? _validaNome(String? v) {
    if (v == null || v.trim().isEmpty) return 'Informe o nome';
    if (v.trim().length < 3) return 'Muito curto';
    return null;
  }

  String? _validaEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Informe o e-mail';
    final ok = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$').hasMatch(v.trim());
    if (!ok) return 'E-mail inválido';
    return null;
  }

  String? _validaTelefone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Informe o telefone';
    final digits = v.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) return 'Telefone incompleto';
    return null;
  }

  String? _validaCnpj(String? v) {
    if (_type == AccountType.empresa) {
      if (v == null || v.trim().isEmpty) return 'Informe o CNPJ';
      final digits = v.replaceAll(RegExp(r'\D'), '');
      if (digits.length != 14) return 'CNPJ deve ter 14 dígitos';
    }
    return null;
  }

  String? _validaSenha(String? v) {
    if (v == null || v.isEmpty) return 'Informe a senha';
    if (v.length < 6) return 'Mínimo de 6 caracteres';
    return null;
  }

  String? _validaConfirmacao(String? v) {
    if (v == null || v.isEmpty) return 'Confirme a senha';
    if (v != _senhaCtrl.text) return 'As senhas não coincidem';
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _type == AccountType.cliente
              ? 'Cliente cadastrado com sucesso!'
              : 'Empresa cadastrada com sucesso!',
        ),
      ),
    );

    // volta para o login
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    InputDecoration deco({
      required String label,
      String? hint,
      Widget? prefixIcon,
      Widget? suffixIcon,
    }) {
      return InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.outlineVariant.withOpacity(.35)),
        ),
      );
    }

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
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Cadastre-se',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 20),

                      // Seletor Cliente / Empresa
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(color: cs.outlineVariant.withOpacity(.6)),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _ChipTab(
                                label: 'Cliente',
                                selected: _type == AccountType.cliente,
                                onTap: () => setState(() => _type = AccountType.cliente),
                              ),
                              const SizedBox(width: 6),
                              _ChipTab(
                                label: 'Empresa',
                                selected: _type == AccountType.empresa,
                                onTap: () => setState(() => _type = AccountType.empresa),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Card com o formulário
                      Card(
                        color: Theme.of(context).colorScheme.surface.withOpacity(.95),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(color: cs.outlineVariant.withOpacity(.3)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Campos que mudam por tipo
                                if (_type == AccountType.cliente) ...[
                                  TextFormField(
                                    controller: _nomeCtrl,
                                    textInputAction: TextInputAction.next,
                                    validator: _validaNome,
                                    decoration: deco(
                                      label: 'Nome',
                                      hint: 'Seu nome completo',
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    validator: _validaEmail,
                                    decoration: deco(
                                      label: 'Email',
                                      hint: 'seumelhoremail@gmail.com',
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _telCtrl,
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-\(\)]'))],
                                    validator: _validaTelefone,
                                    decoration: deco(
                                      label: 'Telefone',
                                      hint: '99 99999-9999',
                                    ),
                                  ),
                                ] else ...[
                                  TextFormField(
                                    controller: _nomeCtrl,
                                    textInputAction: TextInputAction.next,
                                    validator: _validaNome,
                                    decoration: deco(
                                      label: 'Nome Empresa',
                                      hint: 'Nome da empresa',
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    validator: _validaEmail,
                                    decoration: deco(
                                      label: 'Email Corporativo',
                                      hint: 'seumelhoremail@gmail.com',
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _telCtrl,
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-\(\)]'))],
                                    validator: _validaTelefone,
                                    decoration: deco(
                                      label: 'Telefone',
                                      hint: '99 99999-9999',
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _cnpjCtrl,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    validator: _validaCnpj,
                                    decoration: deco(
                                      label: 'CNPJ',
                                      hint: 'XX. XXX. XXX/0001-XX',
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _senhaCtrl,
                                  obscureText: _obscure1,
                                  textInputAction: TextInputAction.next,
                                  validator: _validaSenha,
                                  decoration: deco(
                                    label: 'Senha',
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(() => _obscure1 = !_obscure1),
                                      icon: Icon(_obscure1
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _confirmCtrl,
                                  obscureText: _obscure2,
                                  validator: _validaConfirmacao,
                                  decoration: deco(
                                    label: 'Confirme sua senha',
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(() => _obscure2 = !_obscure2),
                                      icon: Icon(_obscure2
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                SizedBox(
                                  width: double.infinity,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: _loading
                                        ? ElevatedButton.icon(
                                            key: const ValueKey('loading'),
                                            onPressed: null,
                                            icon: const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            ),
                                            label: const Text('Cadastrando...'),
                                          )
                                        : ElevatedButton(
                                            key: const ValueKey('ready'),
                                            onPressed: _submit,
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(22),
                                              ),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(vertical: 12),
                                              child: Text('cadastrar-se'),
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Rodapé: voltar ao login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Já possui cadastro?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Abinha arredondada (Cliente/Empresa)
class _ChipTab extends StatelessWidget {
  const _ChipTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? cs.primary.withOpacity(.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? cs.primary : Colors.transparent,
            width: selected ? 1 : 0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? cs.primary : cs.onSurface.withOpacity(.8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
