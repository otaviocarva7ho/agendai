import 'package:flutter/material.dart';
import 'package:agendai/presentation/pages/initial.dart';

class ChatPanelTab extends StatelessWidget {
  const ChatPanelTab({super.key});
  static const route = '/chats';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // ========= CONTEÚDO =========
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _HeroHeader(),
                  SizedBox(height: 20),
                  _MeetingsSection(label: 'Hoje'),
                  SizedBox(height: 6),
                  _MeetingTile(
                    name: 'Reunião com X',
                    subtitle: 'Lorem ipsum dolor sit amet.',
                    avatarAsset: null,
                  ),
                  _MeetingTile(
                    name: 'Reunião com X',
                    subtitle: 'Lorem ipsum dolor sit amet.',
                    avatarAsset: null,
                  ),
                  SizedBox(height: 18),
                  _MeetingsSection(label: 'Ontem'),
                  SizedBox(height: 6),
                  _MeetingTile(
                    name: 'Reunião com X',
                    subtitle: 'Lorem ipsum dolor sit amet.',
                    avatarAsset: null,
                  ),
                  SizedBox(height: 18),
                  _MeetingsSection(label: 'Segunda'),
                  SizedBox(height: 6),
                  _MeetingTile(
                    name: 'Reunião com X',
                    subtitle: 'Lorem ipsum dolor sit amet.',
                    avatarAsset: null,
                  ),
                  _MeetingTile(
                    name: 'Reunião com X',
                    subtitle: 'Lorem ipsum dolor sit amet.',
                    avatarAsset: null,
                  ),
                ],
              ),
            ),

            // ========= NAVBAR FLUTUANTE =========
            _BottomPillNav(
              index: 1, // chat selecionado
              onChanged: (i) {
                switch (i) {
                  case 0:
                    Navigator.of(
                      context,
                    ).pushReplacementNamed(InitialPage.route);
                    break;
                  case 1:
                    // já está no chat
                    break;
                  case 2:
                    // TODO: quando criar a tela de calendário, navegar aqui
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

// -------------------- HEADER --------------------

class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4C8DFF), Color(0xFF86A5FF), Color(0xFFBAC7FF)],
          stops: [0.0, 0.6, 1.0],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomRight: Radius.circular(38),
          bottomLeft: Radius.circular(18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.12),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      const Icon(Icons.search, size: 18, color: Colors.white70),
                      const SizedBox(width: 8),
                      Text(
                        'Pesquisar',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.expand_less, color: Colors.white.withOpacity(.9)),
            ],
          ),
          const SizedBox(height: 18),
          RichText(
            text: TextSpan(
              style: textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                height: 1.15,
              ),
              children: const [
                TextSpan(text: 'Crie sua reunião\nde forma rápida\ne '),
                TextSpan(
                  text: 'facil',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ' !'),
              ],
            ),
          ),
          const SizedBox(height: 18),
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
    );
  }
}

class _RoundAction extends StatelessWidget {
  final IconData icon;
  const _RoundAction({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(.1),
            blurRadius: 6,
            offset: const Offset(-2, -2),
            spreadRadius: -2,
          ),
        ],
      ),
      child: const Icon(Icons.add, size: 26, color: Colors.white),
    );
  }
}

// -------------------- LISTA DE REUNIÕES --------------------

class _MeetingsSection extends StatelessWidget {
  final String label;
  const _MeetingsSection({required this.label});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: Colors.white.withOpacity(.7)),
      ),
    );
  }
}

class _MeetingTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final String? avatarAsset;

  const _MeetingTile({
    required this.name,
    required this.subtitle,
    this.avatarAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFF17212B),
            backgroundImage: avatarAsset != null
                ? AssetImage(avatarAsset!)
                : null,
            child: avatarAsset == null
                ? const Icon(Icons.person, color: Colors.white70)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(.94),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white.withOpacity(.65),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- NAVBAR --------------------

class _BottomPillNav extends StatelessWidget {
  final int index; // 0=inicial, 1=chat, 2=calendário (ex.)
  final ValueChanged<int>? onChanged;

  const _BottomPillNav({required this.index, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget item(IconData icon, int i) {
      final active = index == i;
      final color = active ? cs.primary : Colors.white70;

      return InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => onChanged?.call(i),
        child: Container(
          width: 64,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? color.withOpacity(.14) : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            border: active ? Border.all(color: color, width: 1) : null,
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
