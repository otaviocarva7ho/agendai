import 'package:flutter/material.dart';
import 'meeting.dart';

/// Página inicial da Agenda.
/// Use como `home:` no MaterialApp ou registre em uma rota do seu Router.
class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  static const route = '/initial';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Header(),
                  const SizedBox(height: 24),

                  // Próxima reunião
                  Text('Próxima reunião,',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _Card(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Reunião com (nome).',
                            style: TextStyle(
                              color: Colors.white.withOpacity(.88),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          '23/08, 17h.',
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
                  Text('Acesso rápido,',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
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
                          // ou: Navigator.of(context).pushNamed(CriarReuniaoPage.route);
                        },
                      ),
                      const QuickAction(
                        icon: Icons.cancel_outlined,
                        label: 'Cancelar\nreunião',
                      ),
                      const QuickAction(
                        icon: Icons.link,
                        label: 'Inserir código\nde reunião',
                      ),
                      const QuickAction(
                        icon: Icons.people_outline,
                        label: 'Histórico de\nreuniões',
                      ),
                      const QuickAction(
                        icon: Icons.help_outline,
                        label: 'Ajuda',
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
                              child: const Icon(Icons.bolt, size: 16),
                            ),
                            const Spacer(),
                            Text(
                              '23/08/2025',
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
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Opacity(
                          opacity: .75,
                          child: Text(
                            '• Hoje, você possui 3 reuniões e é aniversário do João',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Opacity(
                          opacity: .9,
                          child: Text('Reuniões',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(letterSpacing: .2)),
                        ),
                        const SizedBox(height: 8),
                        const _Bullet('Reunião com João às 17h.'),
                        const _Bullet('Reunião com Ana às 18h.'),
                        const _Bullet('Reunião com José às 19h.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Agendamento com IA
                  _Card(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 22),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Agendamento inteligente com IA.',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(.14)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                              const Icon(Icons.chat_bubble_outline, size: 22),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom pill nav
            const _BottomPill(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

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
            child: Text('Olá, João',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu_rounded),
          ),
        ],
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap; // <- adicionado

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
                )
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
          )
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
                active: true,
                onTap: () {},
                activeColor: cs.primary,
              ),
              _PillItem(icon: Icons.search, onTap: () {}),
              _PillItem(icon: Icons.message_outlined, onTap: () {}),
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
    final color =
        active ? (activeColor ?? Theme.of(context).colorScheme.primary) : null;

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
