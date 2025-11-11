import 'package:flutter/material.dart';
import 'dart:math' as math;

// ----------------------------- PAGE -----------------------------

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime mesBase = DateTime(2025, 8, 1); // Agosto 2025
  DateTime? selecionado = DateTime(2025, 8, 1);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final compromissos = _fakeCompromissos(selecionado ?? mesBase);

    return Scaffold(
      backgroundColor: cs.background,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              color: cs.surface,
              child: Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: _Header(
                          onBell: () {},
                          onMenu: () {},
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                        sliver: SliverToBoxAdapter(
                          child: _MesTitulo(
                            data: selecionado ?? mesBase,
                            onAbrirMes: () {},
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverToBoxAdapter(
                          child: _CalendarioGrid(
                            month: mesBase,
                            selecionado: selecionado,
                            onDiaTap: (d) => setState(() => selecionado = d),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                        sliver: compromissos.isEmpty
                            ? SliverToBoxAdapter(
                                child: _VazioCard(date: selecionado),
                              )
                            : SliverList.separated(
                                itemBuilder: (_, i) {
                                  final r = compromissos[i];
                                  return _ReuniaoCard(
                                    titulo: r.titulo,
                                    resumo: r.resumo,
                                    metodo: r.metodo,
                                    dataCurta: _formataCurto(r.inicio),
                                  );
                                },
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemCount: compromissos.length,
                              ),
                      ),
                      const SliverPadding(
                        padding: EdgeInsets.only(bottom: 140),
                      ),
                    ],
                  ),
                  const _DockFlutuante(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------- MODELO & DADOS FAKE -----------------------------

class Reuniao {
  final String titulo;
  final String resumo;
  final String metodo;
  final DateTime inicio;
  Reuniao({
    required this.titulo,
    required this.resumo,
    required this.metodo,
    required this.inicio,
  });
}

/// Gera compromissos determinísticos "de mentirinha" a partir do dia tocado.
/// Assim, praticamente todo dia tem algo diferente — sem depender de rede/BD.
List<Reuniao> _fakeCompromissos(DateTime d) {
  // normaliza
  d = DateTime(d.year, d.month, d.day);

  // Alguns dias especiais com agenda “personalizada”
  final especiais = <DateTime, List<Reuniao>>{
    DateTime(2025, 8, 23): [
      Reuniao(
        titulo: 'Reunião com João',
        resumo: 'Tratar assuntos da criação do aplicativo',
        metodo: 'Google Meet',
        inicio: DateTime(2025, 8, 23, 17, 00),
      ),
      Reuniao(
        titulo: 'Reunião com Ruan',
        resumo: 'Alinhar backlog e prazos do sprint',
        metodo: 'Google Meet',
        inicio: DateTime(2025, 8, 23, 18, 00),
      ),
    ],
    DateTime(2025, 8, 5): [
      Reuniao(
        titulo: 'Kickoff Design',
        resumo: 'Definir identidade visual e fluxos críticos',
        metodo: 'Presencial',
        inicio: DateTime(2025, 8, 5, 10, 30),
      ),
    ],
    DateTime(2025, 8, 12): [
      Reuniao(
        titulo: 'Revisão Sprint 3',
        resumo: 'Apresentar entregas e métricas',
        metodo: 'Google Meet',
        inicio: DateTime(2025, 8, 12, 16, 00),
      ),
      Reuniao(
        titulo: '1:1 com Maria',
        resumo: 'Ajustar prioridades e tirar bloqueios',
        metodo: 'Zoom',
        inicio: DateTime(2025, 8, 12, 17, 15),
      ),
    ],
  };

  if (especiais.containsKey(d)) return especiais[d]!;

  // Geração leve baseada no dia para “variar” a agenda
  final seed = d.millisecondsSinceEpoch ~/ (1000 * 60 * 60 * 24);
  final rnd = math.Random(seed);

  final count = rnd.nextInt(3); // 0..2 compromissos
  return List.generate(count, (i) {
    final hour = 9 + rnd.nextInt(8); // 9h..16h
    final min = [0, 15, 30, 45][rnd.nextInt(4)];
    final inicio = DateTime(d.year, d.month, d.day, hour, min);
    final temas = [
      ['Daily stand-up', 'Sincronizar andamento do time', 'Google Meet'],
      ['Refinamento', 'Especificar histórias e critérios', 'Google Meet'],
      ['Alinhamento Produto', 'Roadmap e trade-offs', 'Zoom'],
      ['Revisão Código', 'PRs pendentes e padrões', 'Presencial'],
      ['Cliente', 'Apresentar protótipo e próximos passos', 'Google Meet'],
    ];
    final t = temas[rnd.nextInt(temas.length)];
    return Reuniao(titulo: t[0], resumo: t[1], metodo: t[2], inicio: inicio);
  });
}

String _formataCurto(DateTime d) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(d.day)}/${two(d.month)}, ${two(d.hour)}h${d.minute == 0 ? '' : two(d.minute)}.';
}

// ----------------------------- COMPONENTES -----------------------------

class _Header extends StatelessWidget {
  final VoidCallback onBell;
  final VoidCallback onMenu;
  const _Header({required this.onBell, required this.onMenu});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 16, 18),
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: cs.secondary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: cs.onSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Calendário de João',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
            IconButton(
              onPressed: onBell,
              icon: const Icon(Icons.notifications_none_rounded),
            ),
            IconButton(
              onPressed: onMenu,
              icon: const Icon(Icons.menu_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _MesTitulo extends StatelessWidget {
  final DateTime data;
  final VoidCallback onAbrirMes;
  const _MesTitulo({required this.data, required this.onAbrirMes});

  static const _meses = [
    'Janeiro','Fevereiro','Março','Abril','Maio','Junho',
    'Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'
  ];
  static const _dias = [
    'Domingo','Segunda','Terça','Quarta','Quinta','Sexta','Sábado'
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final titulo =
        '${_dias[data.weekday % 7]}, ${_meses[data.month - 1]} ${data.year}';
    return Row(
      children: [
        Text(
          titulo,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
        const Spacer(),
        Transform.rotate(
          angle: math.pi,
          child: IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onAbrirMes,
            icon: const Icon(Icons.arrow_drop_down),
          ),
        ),
      ],
    );
  }
}

class _CalendarioGrid extends StatelessWidget {
  final DateTime month;
  final DateTime? selecionado;
  final ValueChanged<DateTime> onDiaTap;

  const _CalendarioGrid({
    required this.month,
    required this.selecionado,
    required this.onDiaTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final firstDay = DateTime(month.year, month.month, 1);
    final totalDays = DateTime(month.year, month.month + 1, 0).day;
    final startWeekday = (firstDay.weekday) % 7;
    final cells = startWeekday + totalDays;
    final rows = (cells / 7.0).ceil();

    const dias = ['D','S','T','Q','Q','S','S'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: dias
              .map((d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        Column(
          children: List.generate(rows, (r) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: List.generate(7, (c) {
                  final index = r * 7 + c;
                  final dayNum = index - startWeekday + 1;
                  final inMonth = dayNum >= 1 && dayNum <= totalDays;
                  final date =
                      inMonth ? DateTime(month.year, month.month, dayNum) : null;
                  final isSelected =
                      date != null && selecionado != null &&
                      date.year == selecionado!.year &&
                      date.month == selecionado!.month &&
                      date.day == selecionado!.day;

                  return Expanded(
                    child: Center(
                      child: GestureDetector(
                        onTap: date == null ? null : () => onDiaTap(date),
                        child: Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: cs.primary, width: 1.6)
                                : null,
                            color: isSelected
                                ? cs.primary.withOpacity(.10)
                                : Colors.transparent,
                          ),
                          child: Text(
                            inMonth ? '$dayNum' : '',
                            style: TextStyle(color: cs.onSurface),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ReuniaoCard extends StatelessWidget {
  final String titulo;
  final String resumo;
  final String metodo;
  final String dataCurta;

  const _ReuniaoCard({
    required this.titulo,
    required this.resumo,
    required this.metodo,
    required this.dataCurta,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: cs.onSurface.withOpacity(.75),
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: 'Resumo: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      TextSpan(text: resumo),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: cs.onSurface.withOpacity(.75),
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: 'Método: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      TextSpan(text: metodo),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  dataCurta,
                  style: TextStyle(
                    color: cs.onSurface.withOpacity(.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.group_outlined, color: cs.onSurface),
          ),
        ],
      ),
    );
  }
}

class _VazioCard extends StatelessWidget {
  final DateTime? date;
  const _VazioCard({this.date});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          Icon(Icons.event_busy, color: cs.onSurface.withOpacity(.8)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Sem compromissos para este dia.',
              style: TextStyle(color: cs.onSurface.withOpacity(.9)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DockFlutuante extends StatelessWidget {
  const _DockFlutuante();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 24,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _MiniButton(icon: Icons.chat_bubble_outline_rounded),
              SizedBox(width: 12),
              _MiniButton(icon: Icons.search_rounded),
              SizedBox(width: 12),
              _MiniButton(
                icon: Icons.calendar_today_rounded,
                filled: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniButton extends StatelessWidget {
  final IconData icon;
  final bool filled;
  const _MiniButton({
    required this.icon,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: filled ? cs.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        border: filled ? null : Border.all(color: cs.outline),
      ),
      child: Icon(
        icon,
        size: 22,
        color: filled ? cs.onPrimary : cs.onSurface.withOpacity(.7),
      ),
    );
  }
}
