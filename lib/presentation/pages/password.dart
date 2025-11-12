import 'package:flutter/material.dart';

class EsqueciSenhaPage extends StatefulWidget {
  const EsqueciSenhaPage({super.key});

  @override
  State<EsqueciSenhaPage> createState() => _EsqueciSenhaPageState();
}

class _EsqueciSenhaPageState extends State<EsqueciSenhaPage> {
  // 0 = Telefone, 1 = Email
  int _modo = 1; // já inicia em Email como no seu print
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  // estados da tela
  // 0 = form, 1 = sucesso SMS, 2 = sucesso EMAIL
  int _estado = 0;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  // --- validações ---
  bool _telefoneValido(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 10 && digits.length <= 11;
  }

  bool _emailValido(String v) {
    final s = v.trim();
    if (s.isEmpty) return false;
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return re.hasMatch(s);
  }

  void _onRedefinir() {
    if (_modo == 0) {
      final fone = _phoneCtrl.text;
      if (_telefoneValido(fone)) {
        setState(() => _estado = 1); // sucesso SMS
      } else {
        _toast('Informe um telefone válido (ex.: 11 99999-9999)');
      }
    } else {
      final mail = _emailCtrl.text;
      if (_emailValido(mail)) {
        setState(() => _estado = 2); // sucesso EMAIL
      } else {
        _toast('Informe um e-mail válido (ex.: nome@dominio.com)');
      }
    }
  }

  void _toast(String msg) {
    final cs = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: cs.error),
    );
  }

  void _concluir() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _CardContainer(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _estado == 0
                      ? _FormContent(
                          key: const ValueKey('form'),
                          modo: _modo,
                          onModoChanged: (m) => setState(() => _modo = m),
                          phoneCtrl: _phoneCtrl,
                          emailCtrl: _emailCtrl,
                          onSubmit: _onRedefinir,
                        )
                      : _estado == 1
                          ? _SuccessContent(
                              key: const ValueKey('sms'),
                              isSms: true,
                              onDone: _concluir,
                            )
                          : _SuccessContent(
                              key: const ValueKey('email'),
                              isSms: false,
                              onDone: _concluir,
                            ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===================== WIDGETS =====================

class _FormContent extends StatelessWidget {
  final int modo; // 0 tel, 1 email
  final ValueChanged<int> onModoChanged;
  final TextEditingController phoneCtrl;
  final TextEditingController emailCtrl;
  final VoidCallback onSubmit;

  const _FormContent({
    super.key,
    required this.modo,
    required this.onModoChanged,
    required this.phoneCtrl,
    required this.emailCtrl,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Text(
          'Esqueceu a senha?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              color: cs.onSurface.withOpacity(.85),
              fontSize: 14.5,
            ),
            children: const [
              TextSpan(text: 'Escolha um dos campos abaixo para\nredefinir sua '),
              TextSpan(
                text: 'senha.',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Segmented
        _Segmented(
          leftLabel: 'Telefone',
          rightLabel: 'Email',
          value: modo,
          onChanged: onModoChanged,
        ),

        const SizedBox(height: 18),

        // Label do campo novo
        Text(
          modo == 0
              ? 'Insira o telefone vinculado à sua conta.'
              : 'Insira o e-mail vinculado à sua conta.',
          style: TextStyle(
            color: cs.onSurface.withOpacity(.9),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),

        // Campo
        _RoundedField(
          controller: modo == 0 ? phoneCtrl : emailCtrl,
          label: modo == 0 ? 'Telefone' : 'E-mail',
          hint: modo == 0 ? '11 99999-9999' : 'seumelhoremail@gmail.com',
          keyboardType:
              modo == 0 ? TextInputType.phone : TextInputType.emailAddress,
        ),

        const SizedBox(height: 24),

        _PrimaryRoundedButton(
          label: 'Redefinir',
          onPressed: onSubmit,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _SuccessContent extends StatelessWidget {
  final bool isSms; // true = SMS, false = EMAIL
  final VoidCallback onDone;

  const _SuccessContent({
    super.key,
    required this.isSms,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Text(
          'Esqueceu a senha?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 18),
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: cs.onSurface.withOpacity(.9),
              fontSize: 15,
              height: 1.4,
            ),
            children: [
              TextSpan(
                  text: 'Um ',
                  style: const TextStyle(fontWeight: FontWeight.w400)),
              TextSpan(
                text: isSms ? 'SMS' : 'E-MAIL',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              const TextSpan(
                  text:
                      ' de validação foi enviado para seu telefone para recuperação da sua senha.'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Obrigado!',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _PrimaryRoundedButton(
          label: 'Concluir',
          onPressed: onDone,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

/// Card central com borda azul arredondada (look do print)
class _CardContainer extends StatelessWidget {
  final Widget child;
  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
      decoration: BoxDecoration(
        color: cs.surface, // fundo do card
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.primary, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Segmented custom com borda azul e pílulas arredondadas
class _Segmented extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final int value; // 0 esq, 1 dir
  final ValueChanged<int> onChanged;

  const _Segmented({
    required this.leftLabel,
    required this.rightLabel,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: cs.primary, width: 1.2),
      ),
      child: Row(
        children: [
          _SegmentedItem(
            label: leftLabel,
            selected: value == 0,
            onTap: () => onChanged(0),
          ),
          _DividerDot(color: cs.primary),
          _SegmentedItem(
            label: rightLabel,
            selected: value == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

class _SegmentedItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentedItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? cs.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: selected ? cs.onPrimary : cs.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _DividerDot extends StatelessWidget {
  final Color color;
  const _DividerDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 6,
      child: Center(
        child: Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

/// Campo arredondado com borda azul e label/hint como no print
class _RoundedField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;

  const _RoundedField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: cs.onSurface),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: cs.onSurface.withOpacity(.5)),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: cs.primary, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: cs.primary, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: cs.primary, width: 1.8),
        ),
        labelStyle: TextStyle(
          color: cs.onSurface.withOpacity(.9),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Botão pill com contorno e fill de acordo com tema (igual vibe do print)
class _PrimaryRoundedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryRoundedButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: cs.primary, width: 1.2),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
