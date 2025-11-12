import 'dart:async';
import 'package:flutter/material.dart';
import 'password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;

  late final AnimationController _heroCtrl;
  late final AnimationController _contentCtrl;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();

    _heroCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeIn = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOutCubic);
    _slideUp = Tween(begin: const Offset(0, .06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut));

    Future.microtask(() async {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      if (mounted) _contentCtrl.forward();
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _heroCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Informe seu e-mail';
    final ok = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$').hasMatch(v.trim());
    if (!ok) return 'E-mail inválido';
    return null;
  }

  String? _validatePass(String? v) {
    if (v == null || v.isEmpty) return 'Informe sua senha';
    if (v.length < 6) return 'Mínimo de 6 caracteres';
    return null;
  }

  Future<void> _submit() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    setState(() => _isLoading = true);

    try {
      await Future<void>.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Exibe snackbar de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso!')),
      );

      // 👇 Navega para a tela inicial (InitialPage)
      Navigator.of(context).pushReplacementNamed('/initial');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao entrar: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _heroCtrl,
                        builder: (context, _) {
                          final t = Curves.easeOutBack.transform(_heroCtrl.value);
                          return Opacity(
                            opacity: t.clamp(0, 1),
                            child: Transform.scale(
                              scale: 0.98 + (0.02 * t),
                              child: Column(
                                children: [
                                  Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      color: cs.primary.withOpacity(.12),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Icon(Icons.lock_rounded, color: cs.primary, size: 36),
                                  ),
                                  const SizedBox(height: 16),
                                  Text('Bem-vindo de volta',
                                      style: Theme.of(context).textTheme.titleLarge),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Entre para continuar',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: cs.outline),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 28),
                      FadeTransition(
                        opacity: _fadeIn,
                        child: SlideTransition(
                          position: _slideUp,
                          child: Card(
                            color: Theme.of(context).colorScheme.surface,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: BorderSide(color: cs.outlineVariant.withOpacity(.3)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _emailCtrl,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        labelText: 'E-mail',
                                        prefixIcon: Icon(Icons.email_outlined),
                                      ),
                                      validator: _validateEmail,
                                    ),
                                    const SizedBox(height: 14),
                                    TextFormField(
                                      controller: _passCtrl,
                                      obscureText: _obscure,
                                      decoration: InputDecoration(
                                        labelText: 'Senha',
                                        prefixIcon: const Icon(Icons.lock_outline),
                                        suffixIcon: IconButton(
                                          onPressed: () =>
                                              setState(() => _obscure = !_obscure),
                                          icon: Icon(_obscure
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined),
                                        ),
                                      ),
                                      validator: _validatePass,
                                    ),
                                    const SizedBox(height: 6),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => const EsqueciSenhaPage()),
                                          );
                                        },
                                            child: const Text('Esqueci minha senha'),
                                          ),
                                        ),
                                    const SizedBox(height: 6),
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 250),
                                      child: _isLoading
                                          ? ElevatedButton.icon(
                                              key: const ValueKey('loading'),
                                              onPressed: null,
                                              icon: const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              ),
                                              label: const Text('Entrando...'),
                                            )
                                          : ElevatedButton(
                                              key: const ValueKey('normal'),
                                              onPressed: _submit,
                                              child: const Text('Entrar'),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      FadeTransition(
                        opacity: _fadeIn,
                        child: SlideTransition(
                          position: _slideUp,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Não tem conta?',
                                  style: Theme.of(context).textTheme.bodyMedium),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Tela de cadastro em breve.')),
                                  );
                                },
                                child: const Text('Criar conta'),
                              ),
                            ],
                          ),
                        ),
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
