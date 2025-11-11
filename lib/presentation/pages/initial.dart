import 'package:flutter/material.dart';
import 'package:agendai/presentation/pages/chats.dart';

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
            // ======= CONTEÚDO (igual ao que você já tinha) =======
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Header(),
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
                  Text(
                    'Acesso rápido,',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      QuickAction(icon: Icons.add, label: 'Criar\nreunião'),
                      QuickAction(
                        icon: Icons.cancel_outlined,
                        label: 'Cancelar\nreunião',
                      ),
                      QuickAction(
                        icon: Icons.link,
                        label: 'Inserir código\nde reunião',
                      ),
                      QuickAction(
                        icon: Icons.people_outline,
                        label: 'Histórico de\nreuniões',
                      ),
                      QuickAction(icon: Icons.help_outline, label: 'Ajuda'),
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
                          style: Theme.of(context).textTheme.titleMedium
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
                          child: Text(
                            'Reuniões',
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge?.copyWith(letterSpacing: .2),
                          ),
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

            // ======= NAVBAR (aba 0 ativa) =======
            _BottomPill(
              activeIndex: 0,
              onTapIndex: (i) {
                if (i == 1) {
                  Navigator.of(
                    context,
                  ).pushReplacementNamed(ChatPanelTab.route);
                }
                // i == 0: já estamos na inicial
                // i == 2: quando criar a tela de calendário, navegue aqui
              },
            ),
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
            child: Text(
              'Olá, João',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          const SizedBox(width: 4),
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu_rounded)),
        ],
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const QuickAction({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
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
  final int activeIndex; // 0=inicial, 1=chat, 2=calendário
  final ValueChanged<int> onTapIndex;
  const _BottomPill({required this.activeIndex, required this.onTapIndex});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget item(IconData icon, int i) {
      final active = activeIndex == i;
      final color = active ? cs.primary : Colors.white70;
      return InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => onTapIndex(i),
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
              item(Icons.home_outlined, 0),
              item(Icons.search, 1),
              item(Icons.calendar_month_outlined, 2),
            ],
          ),
        ),
      ),
    );
  }
}
