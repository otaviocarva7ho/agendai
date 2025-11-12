import 'package:flutter/material.dart';
import 'meeting.dart';
import 'history.dart';
import 'help.dart'; // ajuste o caminho se for diferente
import 'insert_code.dart'; // ou o caminho correto


/// Página inicial da Agenda.
/// Use como `home:` no MaterialApp ou registre em uma rota do seu Router.
class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  static const route = '/initial';

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage>
    with SingleTickerProviderStateMixin {
  bool _menuOpen = false;
  late final AnimationController _menuCtrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _menuCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fade = CurvedAnimation(parent: _menuCtrl, curve: Curves.easeOut);
  }

  void _toggleMenu() {
    setState(() {
      _menuOpen = !_menuOpen;
      if (_menuOpen) {
        _menuCtrl.forward();
      } else {
        _menuCtrl.reverse();
      }
    });
  }

  void _closeMenu() {
    if (_menuOpen) {
      setState(() {
        _menuOpen = false;
        _menuCtrl.reverse();
      });
    }
  }

  @override
  void dispose() {
    _menuCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0C10),
        body: Stack(
          children: [
            // --- Conteúdo principal ---
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _closeMenu, // toca fora -> fecha
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(onMenuTap: _toggleMenu),
                    const SizedBox(height: 24),

                    // Próxima reunião
                    Text(
                      'Próxima reunião,',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _Card(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Reunião com João e Maria. Assunto: Daily stand-up',
                              style: TextStyle(
                                color: Colors.white.withOpacity(.88),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '12/11, 21:30h.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(.6),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Acesso rápido
                    Text(
                      'Acesso rápido,',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        QuickAction(
                          icon: Icons.add,
                          label: 'Criar\nreunião',
                          // navegação para a tela de criar reunião
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const CriarReuniaoPage(),
                              ),
                            );
                          },
                        ),
                        QuickAction(
                          icon: Icons.link,
                          label: 'Inserir código\nde reunião',
                          onTap: () async {
                            final code = await Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const InserirCodigoPage()),
                            );

                            // Opcional: use o código retornado
                            if (code is String && code.isNotEmpty) {
                              // Exemplo: mostrar um feedback ou navegar para a sala
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Código recebido: $code')),
                              );

                              // TODO: navegue para a sala de reunião correspondente, se já tiver essa tela.
                              // Navigator.push(context, MaterialPageRoute(
                              //   builder: (_) => MeetingRoomPage(code: code),
                              // ));
                            }
                          },
                        ),
                        QuickAction(
                          icon: Icons.people_outline,
                          label: 'Histórico de\nreuniões',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HistoricoReunioesPage(),
                              ),
                            );
                          },
                        ),
                        QuickAction(
                          icon: Icons.help_outline,
                          label: 'Ajuda',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const HelpPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Resumo do dia
                    _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: cs.primary.withOpacity(.18),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.directions_walk_outlined, size: 22),
                              ),
                              const Spacer(),
                              Text(
                                '12/11/2025',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.6),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Resumo de informações do dia.',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Opacity(
                            opacity: .75,
                            child: Text(
                              '• Hoje, você possui 2 reuniões e é aniversário do Otávio.',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Opacity(
                            opacity: .9,
                            child: Text(
                              'Reuniões',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(letterSpacing: .2),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const _Bullet('Reunião com Ana às 18h.'),
                          const _Bullet('Reunião com João e Maria às 21:30h.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Agendamento com IA
                    _Card(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 22,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Agendamento inteligente com IA.',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withOpacity(.14),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.chat_bubble_outline,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- Scrim (fundo) para capturar toque fora e escurecer ---
            if (_menuOpen) ...[
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeMenu,
                  child: AnimatedBuilder(
                    animation: _fade,
                    builder: (_, __) => Container(
                      color: Colors.black.withOpacity(0.35 * _fade.value),
                    ),
                  ),
                ),
              ),
            ],

            // --- Menu suspenso (tipo dropdown da 2ª tela) ---
            Positioned(
              top: 86,
              right: 16,
              child: FadeTransition(
                opacity: _fade,
                child: IgnorePointer(
                  ignoring: !_menuOpen,
                  child: _AccountMenu(onClose: _closeMenu),
                ),
              ),
            ),

            // Bottom pill nav (3 abas padrão: Inicial, Chat, Calendário)
            const _BottomPill(),
          ],
        ),
      ),
    );
  }
}

/// Header com botão de menu; ação vem de cima para abrir/fechar.
class _Header extends StatelessWidget {
  const _Header({required this.onMenuTap});
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: cs.primary.withOpacity(.15),
            child: const Icon(Icons.person, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Olá, João',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
    );
  }
}

/* ====================== MENU COM NOTIFICAÇÕES EXPANSÍVEIS ===================== */

class _AccountMenu extends StatefulWidget {
  const _AccountMenu({required this.onClose});
  final VoidCallback onClose;

  @override
  State<_AccountMenu> createState() => _AccountMenuState();
}

class _AccountMenuState extends State<_AccountMenu>
    with TickerProviderStateMixin {
  bool _showNotifications = false;

  // Lista de notificações (mock). Substitua pelos seus dados quando tiver backend/estado.
  final List<String> _notifications = [
    'João ingressou na reunião Daily stand-up',
    'Maria ingressou na reunião Daily stand-up',
  ];

  int get _unreadCount => _notifications.length;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.45),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 6),
            dense: true,
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              child: Icon(Icons.emoji_people, color: Colors.white),
            ),
            title: Text(
              'Olá, João',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(Icons.expand_less, color: Colors.white70),
          ),

          // Configurações
          _PillRowButton(
            icon: Icons.settings,
            label: 'Configurações',
            trailing: const Icon(Icons.settings, color: Colors.white),
            onTap: widget.onClose,
          ),
          const SizedBox(height: 10),

          // Notificações (expansível)
          _PillRowButton(
            icon: Icons.notifications_none,
            label: 'Notificações',
            trailing: _unreadCount > 0 ? _Badge(number: _unreadCount) : null,
            onTap: () {
              setState(() => _showNotifications = !_showNotifications);
            },
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: !_showNotifications
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        for (final msg in _notifications)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _NotifBubble(text: msg),
                          ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _notifications.clear();
                                _showNotifications = false;
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Excluir notificações',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          const SizedBox(height: 10),

          // Abrir uma conta Empresa
          _PillRowButton(
            icon: Icons.add,
            label: 'Abrir uma conta Empresa',
            onTap: widget.onClose,
          ),
        ],
      ),
    );
  }
}

/// Botão "pílula" usado nas linhas do menu
class _PillRowButton extends StatelessWidget {
  const _PillRowButton({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

/// Item de notificação (bolha arredondada)
class _NotifBubble extends StatelessWidget {
  const _NotifBubble({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1623),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 13.5),
      ),
    );
  }
}

/// Badge vermelho com número
class _Badge extends StatelessWidget {
  const _Badge({required this.number});
  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        number.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/* ====================== RESTANTE DOS SEUS WIDGETS ===================== */

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const QuickAction({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFF0E1623),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.35),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: cs.primary),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 74,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.2,
                fontSize: 11.5,
                color: Colors.white.withOpacity(.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _Card({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1A29),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: child,
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(.78),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomPill extends StatelessWidget {
  const _BottomPill();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
              _PillItem(
                icon: Icons.person_outline,
                active: true, // estamos na inicial
                onTap: () {}, // não faz nada
                activeColor: cs.primary,
              ),
              _PillItem(
                icon: Icons.message_outlined,
                onTap: () {
                  Navigator.pushNamed(context, '/chats');
                },
              ),
              _PillItem(
                icon: Icons.calendar_month,
                onTap: () {
                  Navigator.pushNamed(context, '/calendar');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillItem extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  final Color? activeColor;

  const _PillItem({
    required this.icon,
    this.active = false,
    required this.onTap,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? (activeColor ?? Theme.of(context).colorScheme.primary)
        : null;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        width: 64,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? color!.withOpacity(.14) : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(icon, color: active ? color : Colors.white70),
      ),
    );
  }
}
