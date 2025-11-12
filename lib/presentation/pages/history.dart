import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'initial.dart'; // navegação de volta

// ----------------------------- PAGE -----------------------------

class HistoricoReunioesPage extends StatefulWidget {
  const HistoricoReunioesPage({super.key});

  @override
  State<HistoricoReunioesPage> createState() => _HistoricoReunioesPageState();
}

class _HistoricoReunioesPageState extends State<HistoricoReunioesPage> {
  late final List<ReuniaoHistorico> _historicoOriginal;
  List<ReuniaoHistorico> _historicoFiltrado = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _historicoOriginal = _geraHistoricoUltimos6Meses();
    _historicoFiltrado = List.from(_historicoOriginal);
    _searchController.addListener(_filtrar);
  }

  void _filtrar() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() => _historicoFiltrado = List.from(_historicoOriginal));
    } else {
      setState(() {
        _historicoFiltrado = _historicoOriginal.where((r) {
          return r.participantes.any(
            (p) => p.toLowerCase().contains(query),
          );
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // 🔻 Navbar removida
                    const SliverPadding(padding: EdgeInsets.only(top: 16)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Buscar por participante...',
                            prefixIcon: const Icon(Icons.search_rounded),
                            filled: true,
                            fillColor: cs.surfaceContainerLow,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: cs.outlineVariant),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: cs.outlineVariant),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: _historicoFiltrado.isEmpty
                          ? SliverToBoxAdapter(child: _VazioCardHistorico())
                          : SliverList.separated(
                              itemCount: _historicoFiltrado.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, i) {
                                final r = _historicoFiltrado[i];
                                return _HistoricoCard(r: r);
                              },
                            ),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 140)),
                  ],
                ),

                // 🔹 Botão de voltar fixo no canto superior esquerdo
                Positioned(
                  top: 12,
                  left: 12,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () {
                        // Volta para a InitialPage substituindo a tela atual
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const InitialPage()),
                        );

                        // Alternativa com rotas nomeadas:
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //   InitialPage.route,
                        //   (route) => false,
                        // );
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: cs.outlineVariant),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.10),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(Icons.arrow_back_rounded, color: cs.primary, size: 22),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------- MODELO + MOCK -----------------------------

class ReuniaoHistorico {
  final String id;
  final String titulo;
  final DateTime inicio;
  final Duration duracao;
  final List<String> participantes;

  ReuniaoHistorico({
    required this.id,
    required this.titulo,
    required this.inicio,
    required this.duracao,
    required this.participantes,
  });
}

List<ReuniaoHistorico> _geraHistoricoUltimos6Meses() {
  final agora = DateTime.now();
  final inicioJanela = DateTime(agora.year, agora.month - 6, 1);
  final rnd = math.Random(12345);
  final nomesPool = [
    'Você', 'João', 'Maria', 'Ana', 'Ruan', 'Carlos', 'Beatriz', 'Luís'
  ];
  final temas = [
    'Daily stand-up',
    'Alinhamento de Produto',
    'Revisão Sprint',
    'Refinamento',
    'Demonstração para Cliente',
    'Retrospectiva',
    'Planejamento do Sprint',
    '1:1 com liderança',
  ];

  final List<ReuniaoHistorico> list = [];
  final total = 28 + rnd.nextInt(12);

  for (var i = 0; i < total; i++) {
    final diasRange = agora.difference(inicioJanela).inDays;
    final offsetDias = rnd.nextInt(diasRange + 1);
    final dia = inicioJanela.add(Duration(days: offsetDias));
    final hora = 9 + rnd.nextInt(8);
    final minuto = [0, 15, 30, 45][rnd.nextInt(4)];
    final inicio = DateTime(dia.year, dia.month, dia.day, hora, minuto);
    if (inicio.isAfter(agora)) continue;
    final duracao = Duration(minutes: 15 + rnd.nextInt(106));
    final qtd = 2 + rnd.nextInt(4);
    final participantes = <String>{};
    while (participantes.length < qtd) {
      participantes.add(nomesPool[rnd.nextInt(nomesPool.length)]);
    }
    if (!participantes.contains('Você') && rnd.nextBool()) {
      participantes
        ..remove(participantes.first)
        ..add('Você');
    }
    final titulo = temas[rnd.nextInt(temas.length)];
    final id = _geraId(inicio, i);
    list.add(ReuniaoHistorico(
      id: id,
      titulo: titulo,
      inicio: inicio,
      duracao: duracao,
      participantes: participantes.toList(),
    ));
  }

  final filtrado = list
      .where((r) => r.inicio.isAfter(inicioJanela) && r.inicio.isBefore(agora))
      .toList()
    ..sort((a, b) => b.inicio.compareTo(a.inicio));

  return filtrado;
}

String _geraId(DateTime d, int i) {
  String two(int n) => n.toString().padLeft(2, '0');
  return 'R-${d.year}${two(d.month)}${two(d.day)}-${two(d.hour)}${two(d.minute)}-${i.toString().padLeft(3, '0')}';
}

String _formataDataHora(DateTime d) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(d.day)}/${two(d.month)}/${d.year} • ${two(d.hour)}:${two(d.minute)}';
}

String _formataDuracao(Duration dur) {
  final h = dur.inHours;
  final m = dur.inMinutes % 60;
  if (h == 0) return '${m} min';
  if (m == 0) return '${h}h';
  return '${h}h ${m}min';
}

// ----------------------------- UI COMPONENTES -----------------------------

class _HistoricoCard extends StatelessWidget {
  final ReuniaoHistorico r;
  const _HistoricoCard({required this.r});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  r.titulo,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.surface,
                  border: Border.all(color: cs.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  r.id,
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withValues(alpha: .8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.event_available_rounded, size: 18, color: cs.onSurface.withValues(alpha: .75)),
              const SizedBox(width: 6),
              Text(
                _formataDataHora(r.inicio),
                style: TextStyle(color: cs.onSurface.withValues(alpha: .75), fontSize: 13),
              ),
              const SizedBox(width: 10),
              Icon(Icons.timer_outlined, size: 18, color: cs.onSurface.withValues(alpha: .75)),
              const SizedBox(width: 6),
              Text(
                _formataDuracao(r.duracao),
                style: TextStyle(color: cs.onSurface.withValues(alpha: .75), fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Participantes',
            style: TextStyle(
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: r.participantes.map((p) => _ChipParticipante(nome: p)).toList(),
          ),
        ],
      ),
    );
  }
}

class _ChipParticipante extends StatelessWidget {
  final String nome;
  const _ChipParticipante({required this.nome});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_outline_rounded, size: 16, color: cs.onSurface.withValues(alpha: .8)),
          const SizedBox(width: 6),
          Text(
            nome,
            style: TextStyle(
              fontSize: 13,
              color: cs.onSurface.withValues(alpha: .9),
            ),
          ),
        ],
      ),
    );
  }
}

class _VazioCardHistorico extends StatelessWidget {
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
          Icon(Icons.history_toggle_off, color: cs.onSurface.withValues(alpha: .8)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Nenhuma reunião encontrada.',
              style: TextStyle(color: cs.onSurface.withValues(alpha: .9)),
            ),
          ),
        ],
      ),
    );
  }
}