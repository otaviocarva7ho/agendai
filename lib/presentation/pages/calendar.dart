import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:agendai/presentation/pages/initial.dart';
import 'package:agendai/presentation/pages/chats.dart';

// ----------------------------- PAGE -----------------------------

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  static const route = '/calendar';

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime mesBase = DateTime(2025, 8, 1); // Agosto 2025
  DateTime? selecionado = DateTime(2025, 8, 1);

  // NOVO: armazenar reuniões canceladas (id estável por titulo+inicio)
  final Set<String> _cancelados = {};

  void _mudaMes(int delta) {
    // delta: -1 (anterior) | +1 (próximo)
    final novo = DateTime(mesBase.year, mesBase.month + delta, 1);
    setState(() {
      mesBase = novo;
      selecionado = DateTime(novo.year, novo.month, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final compromissosAll = _fakeCompromissos(selecionado ?? mesBase);
    final compromissos = compromissosAll
        .where((r) => !_cancelados.contains(_idReuniao(r)))
        .toList();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              child: Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: _Header(onBell: () {}, onMenu: () {}),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                        sliver: SliverToBoxAdapter(
                          child: _MesTitulo(
                            data: mesBase,
                            onPrev: () => _mudaMes(-1),
                            onNext: () => _mudaMes(1),
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
                                    onCancelar: () {
                                      setState(() {
                                        _cancelados.add(_idReuniao(r));
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Reunião cancelada!'),
                                        ),
                                      );
                                    },
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

                  // Navbar flutuante, estilo da primeira página
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

// NOVO: id estável para cada reunião
String _idReuniao(Reuniao r) => '${r.titulo}|${r.inicio.toIso8601String()}';

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

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh, // barra “cheia”
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cs.secondary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: cs.onSecondary),
            ),
            const SizedBox(width: 12),

            // Título
            Expanded(
              child: Text(
                'Calendário de João',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Sino
            _HeaderIconChip(
              icon: Icons.notifications_none_rounded,
              onTap: onBell,
            ),
            const SizedBox(width: 8),

            // Menu (apenas um)
            _HeaderIconChip(
              icon: Icons.menu_rounded,
              onTap: onMenu,
            ),
          ],
        )
      ),
    );
  }
}

class _HeaderIconChip extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderIconChip({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: cs.surface, // contraste leve com a barra
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Icon(
            icon,
            size: 20,
            // um toque de destaque, parecido com o print
            color: cs.primary,
          ),
        ),
      ),
    );
  }
}


class _MesTitulo extends StatelessWidget {
  final DateTime data;
  final VoidCallback onPrev; // NOVO
  final VoidCallback onNext; // NOVO
  const _MesTitulo({
    required this.data,
    required this.onPrev,
    required this.onNext,
  });

  static const _meses = [
    'Janeiro','Fevereiro','Março','Abril','Maio','Junho',
    'Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final titulo = '${_meses[data.month - 1]} ${data.year}';

    return Row(
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Center(
            child: Text(
              titulo,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
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

    const dias = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: dias
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
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
                  final date = inMonth
                      ? DateTime(month.year, month.month, dayNum)
                      : null;
                  final isSelected =
                      date != null &&
                      selecionado != null &&
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
  final VoidCallback onCancelar; // NOVO

  const _ReuniaoCard({
    required this.titulo,
    required this.resumo,
    required this.metodo,
    required this.dataCurta,
    required this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Future<void> _confirmarCancelamento() async {
      final resp = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Tem certeza que deseja cancelar a reunião?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Sim'),
            ),
          ],
        ),
      );
      if (resp == true) {
        onCancelar();
      }
    }

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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        titulo,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    // Botão X
                    InkWell(
                      onTap: _confirmarCancelamento,
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.close_rounded,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
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
              color: Theme.of(context).colorScheme.primary.withOpacity(.15),
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

    Widget item({
      required IconData icon,
      required bool active,
      required VoidCallback? onTap,
    }) {
      final color = active ? cs.primary : Colors.white70;

      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Container(
            width: 64,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // ESTILO AJUSTADO: igual à InitialPage (sem borda no ativo)
              color: active ? color.withOpacity(.14) : Colors.transparent,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(icon, color: color),
          ),
        ),
      );
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: 16,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1A29),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white.withOpacity(.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              item(
                icon: Icons.person_outline,
                active: false,
                onTap: () => Navigator.of(
                  context,
                ).pushReplacementNamed(InitialPage.route),
              ),
              item(
                icon: Icons.message_outlined,
                active: false,
                onTap: () => Navigator.of(
                  context,
                ).pushReplacementNamed(ChatPanelTab.route),
              ),
              item(
                icon: Icons.calendar_month,
                active: true, // estamos no calendário
                onTap: null, // não faz nada
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// (Opcional) Mantido caso você use em outro lugar; pode remover se estiver ocioso.
class _MiniButton extends StatelessWidget {
  final IconData icon;
  final bool filled;
  final VoidCallback? onTap;

  const _MiniButton({required this.icon, this.filled = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final child = Container(
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

    if (onTap == null) return child;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: child,
      ),
    );
  }
}
