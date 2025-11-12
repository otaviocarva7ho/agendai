import 'package:flutter/material.dart';
import 'package:agendai/presentation/pages/initial.dart';
import 'package:agendai/presentation/pages/calendar.dart';

class ChatPanelTab extends StatefulWidget {
  const ChatPanelTab({super.key});
  static const route = '/chats';

  @override
  State<ChatPanelTab> createState() => _ChatPanelTabState();
}

class _ChatPanelTabState extends State<ChatPanelTab> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _expandedHeader = true;

  // ===== Dados fictícios =====
  final List<_Meeting> _allMeetings = const [
    _Meeting(
      name: 'Reunião com Ana Silva',
      subtitle: 'Alinhar pauta do projeto.',
      day: 'Hoje',
    ),
    _Meeting(
      name: 'Reunião com Bruno Costa',
      subtitle: 'Revisar requisitos e prazos.',
      day: 'Ontem',
    ),
    _Meeting(
      name: 'Reunião com Carla Mendes',
      subtitle: 'Status do sprint e próximos passos.',
      day: 'Ontem',
    ),
    _Meeting(
      name: 'Reunião com Diego Rocha',
      subtitle: 'Planejamento do release.',
      day: 'Segunda',
    ),
    _Meeting(
      name: 'Reunião com Elisa Souza',
      subtitle: 'Integração com parceiros.',
      day: 'Segunda',
    ),
  ];

  String get _query => _searchCtrl.text.trim().toLowerCase();

  List<_Meeting> get _filteredMeetings {
    if (_query.isEmpty) return _allMeetings;
    return _allMeetings
        .where((m) => m.name.toLowerCase().contains(_query))
        .toList(growable: false);
  }

  void _toggleHeader() => setState(() => _expandedHeader = !_expandedHeader);

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroHeader(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    expanded: _expandedHeader,
                    onToggleExpanded: _toggleHeader,
                  ),
                  const SizedBox(height: 22),

                  // Lista filtrada; cada tile abre a tela de chat
                  ..._filteredMeetings.map(
                    (m) => _MeetingTile(
                      name: m.name,
                      subtitle: m.subtitle,
                      dayLabel: m.day,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChatDetailPage(title: m.name),
                          ),
                        );
                      },
                    ),
                  ),
                  if (_filteredMeetings.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Text(
                        'Nenhum resultado para “${_searchCtrl.text}”.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(.65),
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ======= NAVBAR (mantida, sem alterações) =======
            _BottomPillNav(
              index: 1,
              onChanged: (i) {
                switch (i) {
                  case 0:
                    Navigator.of(
                      context,
                    ).pushReplacementNamed(InitialPage.route);
                    break;
                  case 1:
                    break;
                  case 2:
                    Navigator.of(
                      context,
                    ).pushReplacementNamed(CalendarPage.route);
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Meeting {
  final String name;
  final String subtitle;
  final String day;
  const _Meeting({
    required this.name,
    required this.subtitle,
    required this.day,
  });
}

// ============================================================
// HEADER (hero) — busca funcional e recolhível, botões sem sombra
// ============================================================
class _HeroHeader extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool expanded;
  final VoidCallback onToggleExpanded;

  const _HeroHeader({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.expanded,
    required this.onToggleExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.9, -1.0),
          end: Alignment(0.9, 1.0),
          colors: [Color(0xFF468CFF), Color(0xFF6EA2FF), Color(0xFFE5EAF7)],
          stops: [0, .55, 1],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de busca + seta
          Row(
            children: [
              Expanded(
                child: _Frosted(
                  radius: 24,
                  child: SizedBox(
                    height: 42,
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.search,
                          size: 18,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: controller,
                            onChanged: onChanged,
                            style: t.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(.95),
                            ),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: 'Pesquisar',
                              hintStyle: t.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(.85),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onToggleExpanded,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white.withOpacity(.95),
                  ),
                ),
              ),
            ],
          ),

          // conteúdo recolhível
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18),
                RichText(
                  text: TextSpan(
                    style: t.headlineSmall?.copyWith(
                      color: Colors.white,
                      height: 1.15,
                      fontWeight: FontWeight.w600,
                    ),
                    children: const [
                      TextSpan(text: 'Crie sua reunião\n'),
                      TextSpan(text: 'de forma rápida\n'),
                      TextSpan(text: 'e fácil !'),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Botões redondos SEM sombra
                Row(
                  children: const [
                    _RoundAction(icon: Icons.add),
                    SizedBox(width: 12),
                    _RoundAction(icon: Icons.videocam_outlined),
                    SizedBox(width: 12),
                    _RoundAction(icon: Icons.groups_2_outlined),
                    SizedBox(width: 12),
                    _RoundAction(icon: Icons.insert_drive_file_outlined),
                  ],
                ),
              ],
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _Frosted extends StatelessWidget {
  final Widget child;
  final double radius;
  const _Frosted({required this.child, this.radius = 16, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.14),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withOpacity(.12)),
      ),
      child: child,
    );
  }
}

// ===== Botão redondo SEM sombra =====
class _RoundAction extends StatelessWidget {
  final IconData icon;
  const _RoundAction({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          .22,
        ), // um pouco mais sólido pra ler melhor
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 26, color: Colors.white),
    );
  }
}

// ============================================================
// ITEM DA LISTA — abre a tela de chat ao tocar
// ============================================================
class _MeetingTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final String? dayLabel;
  final VoidCallback? onTap;

  const _MeetingTile({
    super.key,
    required this.name,
    required this.subtitle,
    this.dayLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: Colors.white.withOpacity(.96),
    );
    final sub = TextStyle(fontSize: 12.5, color: Colors.white.withOpacity(.65));

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 26,
              backgroundColor: Color(0xFF17212B),
              child: Icon(Icons.person, color: Colors.white70),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: title),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: sub,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (dayLabel != null)
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  dayLabel!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(.54),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// NAVBAR — mantida (sem alterações)
// ============================================================
class _BottomPillNav extends StatelessWidget {
  final int index; // 0=inicial, 1=chat, 2=calendário
  final ValueChanged<int>? onChanged;

  const _BottomPillNav({required this.index, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget item(IconData icon, int i) {
      final active = index == i;
      final color = active ? cs.primary : Colors.white70;

      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => onChanged?.call(i),
          child: Container(
            width: 64,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
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
              item(Icons.person_outline, 0),
              item(Icons.message_outlined, 1),
              item(Icons.calendar_month, 2),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
// PÁGINA DE DETALHE DO CHAT
////////////////////////////////////////////////////////////////////////////////

class ChatDetailPage extends StatefulWidget {
  final String title; // ex.: "Reunião com X"
  const ChatDetailPage({super.key, required this.title});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final List<_Msg> _messages = [
    _Msg(text: 'Olá! Vamos começar?', mine: false, time: '12:00'),
    _Msg(text: 'Claro, bora lá.', mine: true, time: '12:01'),
  ];
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  void _send() {
    final txt = _inputCtrl.text.trim();
    if (txt.isEmpty) return;
    setState(() {
      _messages.add(_Msg(text: txt, mine: true, time: _nowHHmm()));
      _inputCtrl.clear();
    });
    // rola para o fim da lista
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _nowHHmm() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF0E1116),
        // mantém conteúdo visível quando o teclado abre
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            // ====== ÁREA DO CHAT: preenche o espaço disponível ======
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.9, -1.0),
                    end: Alignment(0.9, 1.0),
                    colors: [
                      Color(0xFF3F7FEF),
                      Color(0xFF73A4FF),
                      Color(0xFFE5EAF7),
                    ],
                    stops: [0, .55, 1],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(48),
                  ),
                ),
                child: Column(
                  children: [
                    // header do cartão
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xFF17212B),
                          child: Icon(Icons.person, color: Colors.white70),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const _RoundAction(
                          icon: Icons.video_camera_front_outlined,
                        ),
                        const SizedBox(width: 10),
                        const _RoundAction(icon: Icons.groups_2_outlined),
                        const SizedBox(width: 6),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // ====== LISTA DE MENSAGENS: rola dentro do cartão ======
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollCtrl,
                        padding: EdgeInsets.zero,
                        itemCount: _messages.length,
                        itemBuilder: (context, i) => _Bubble(msg: _messages[i]),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ====== INPUT FIXO NO RODAPÉ ======
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                8,
                16,
                // garante espaço quando o teclado está aberto
                16 + MediaQuery.of(context).viewInsets.bottom * 0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF151A22),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(.06),
                        ),
                      ),
                      child: TextField(
                        controller: _inputCtrl,
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Mensagem',
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(.08),
                        ),
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Msg {
  final String text;
  final bool mine;
  final String time;
  _Msg({required this.text, required this.mine, required this.time});
}

class _Bubble extends StatelessWidget {
  final _Msg msg;
  const _Bubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    final isMine = msg.mine;
    final bg = isMine ? const Color(0xFF76A6FF).withOpacity(.55) : Colors.white;
    final fg = isMine ? Colors.white : const Color(0xFF222831);
    final align = isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(isMine ? 18 : 6),
      bottomRight: Radius.circular(isMine ? 6 : 18),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(isMine ? 56 : 8, 6, isMine ? 8 : 56, 6),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Container(
            decoration: BoxDecoration(color: bg, borderRadius: radius),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(msg.text, style: TextStyle(color: fg, fontSize: 14)),
          ),
          const SizedBox(height: 4),
          Text(
            msg.time,
            style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 11),
          ),
        ],
      ),
    );
  }
}
