import 'package:flutter/material.dart';

class CriarReuniaoPage extends StatefulWidget {
  const CriarReuniaoPage({super.key});
  static const route = '/criar-reuniao';

  @override
  State<CriarReuniaoPage> createState() => _CriarReuniaoPageState();
}

class _CriarReuniaoPageState extends State<CriarReuniaoPage> {
  final _idCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  DateTime? _date;
  TimeOfDay _start = const TimeOfDay(hour: 12, minute: 00);
  TimeOfDay _end = const TimeOfDay(hour: 12, minute: 30);

  String _platform = 'meet'; // 'meet' | 'teams'

  @override
  void dispose() {
    _idCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Theme.of(context).colorScheme.primary,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime(bool isStart) async {
    final base = isStart ? _start : _end;
    final picked = await showTimePicker(
      context: context,
      initialTime: base,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme,
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _start = picked;
          // mantém fim pelo menos igual ao início
          final startMinutes = _start.hour * 60 + _start.minute;
          final endMinutes = _end.hour * 60 + _end.minute;
          if (endMinutes <= startMinutes) {
            final after = startMinutes + 30;
            _end = TimeOfDay(hour: (after ~/ 60) % 24, minute: after % 60);
          }
        } else {
          _end = picked;
        }
      });
    }
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header customizado (voltar + título) igual ao mock
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(26),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F1A29),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(.08)),
                      ),
                      child: const Icon(Icons.arrow_back, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Criar Reunião',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 16),

              // Identificador
              _FieldCard(
                label: 'Identificador da reunião',
                hint: 'ex: Entrevista',
                controller: _idCtrl,
              ),
              const SizedBox(height: 12),

              // Descrição
              _FieldCard(
                label: 'Descrição da reunião',
                hint: 'ex: Sala de reunião para entrevistas',
                controller: _descCtrl,
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              // Data
              _BlockCard(
                child: Row(
                  children: [
                    Expanded(
                      child: _BlockTitleSubtitle(
                        title: 'Data da reunião',
                        subtitle:
                            _date == null ? 'Sem data prevista' : _fmtDate(_date!),
                      ),
                    ),
                    _IconCircleButton(
                      icon: Icons.expand_more, // seta de dropdown
                      onTap: _pickDate,
                    ),
                    const SizedBox(width: 8),
                    _IconCircleButton(
                      icon: Icons.calendar_today,
                      onTap: _pickDate,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Horário
              _BlockCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Horário da reunião',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _TimePill(
                            label: 'Início',
                            value: _fmtTime(_start),
                            onTap: () => _pickTime(true),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('—'),
                        ),
                        Expanded(
                          child: _TimePill(
                            label: 'Fim',
                            value: _fmtTime(_end),
                            onTap: () => _pickTime(false),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Plataforma
              _BlockCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Plataforma',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _PlatformChip(
                          icon: Icons.videocam_outlined,
                          text: 'Google Meet',
                          selected: _platform == 'meet',
                          onTap: () => setState(() => _platform = 'meet'),
                        ),
                        const SizedBox(width: 10),
                        _PlatformChip(
                          icon: Icons.groups_2_outlined,
                          text: 'Microsoft Teams',
                          selected: _platform == 'teams',
                          onTap: () => setState(() => _platform = 'teams'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Botão
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                  ),
                  onPressed: () {
                    // aqui você pode salvar/enviar a reunião
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reunião gerada!')),
                    );
                  },
                  child: const Text('Gerar reunião'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------- UI helpers (cards/itens) ----------

class _FieldCard extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;

  const _FieldCard({
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1A29),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _BlockCard extends StatelessWidget {
  final Widget child;
  const _BlockCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1A29),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: child,
    );
  }
}

class _BlockTitleSubtitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const _BlockTitleSubtitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Opacity(
          opacity: .7,
          child: Text(subtitle, style: const TextStyle(fontSize: 12.5)),
        ),
      ],
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconCircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(.14)),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class _TimePill extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _TimePill({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: .7,
          child: Text(label, style: const TextStyle(fontSize: 12.5)),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cs.primary.withOpacity(.5)),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: cs.primary,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlatformChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _PlatformChip({
    required this.icon,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? cs.primary : Colors.white.withOpacity(.14),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: selected ? cs.primary : null),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? cs.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
