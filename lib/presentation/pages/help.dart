import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final _searchCtrl = TextEditingController();
  final List<_FaqItem> _faqs = const [
    _FaqItem(
      q: 'Como recuperar minha senha?',
      a:
          'Na tela de login, toque em "Esqueci minha senha" e siga as instruções. '
          'Se o e-mail não chegar em alguns minutos, verifique a caixa de spam.',
      tags: ['senha', 'login', 'email'],
    ),
    _FaqItem(
      q: 'Não consigo entrar, o app diz "credenciais inválidas".',
      a:
          'Confirme se digitou o e-mail corretamente e se a senha possui pelo menos 6 caracteres. '
          'Se o problema persistir, redefina a senha.',
      tags: ['erro', 'login', 'credenciais'],
    ),
    _FaqItem(
      q: 'Posso usar o app sem internet?',
      a:
          'Algumas funções exigem conexão. Você consegue abrir o app e visualizar dados já baixados, '
          'mas para sincronizar ou autenticar é preciso estar online.',
      tags: ['offline', 'internet'],
    ),
    _FaqItem(
      q: 'Como alterar meu e-mail?',
      a:
          'Após entrar, abra o menu Perfil > Conta e edite seu e-mail. '
          'Por segurança, confirmaremos a alteração via mensagem.',
      tags: ['perfil', 'conta', 'email'],
    ),
    _FaqItem(
      q: 'Onde falo com o suporte?',
      a:
          'Na seção "Contato & Suporte" abaixo você encontra as opções para enviar mensagem, '
          'abrir um ticket ou consultar a documentação.',
      tags: ['suporte', 'contato'],
    ),
  ];

  String get _query => _searchCtrl.text.toLowerCase().trim();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final filtered = _query.isEmpty
        ? _faqs
        : _faqs.where((f) {
            final hay = (f.q + ' ' + f.a + ' ' + f.tags.join(' '))
                .toLowerCase();
            return hay.contains(_query);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuda'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Enviar feedback',
            icon: const Icon(Icons.feedback_outlined),
            onPressed: () => _openFeedbackDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // BUSCA
          TextField(
            controller: _searchCtrl,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Busque por dúvida (ex.: senha, login, suporte)',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Limpar',
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() {});
                      },
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // DICAS RÁPIDAS (chips)
          Wrap(
            spacing: 8,
            runSpacing: -6,
            children: [
              _QuickChip(label: 'Login', onTap: () => _setQuery('login')),
              _QuickChip(label: 'Senha', onTap: () => _setQuery('senha')),
              _QuickChip(label: 'Suporte', onTap: () => _setQuery('suporte')),
              _QuickChip(label: 'Offline', onTap: () => _setQuery('offline')),
            ],
          ),
          const SizedBox(height: 10),

          // RESULTADOS/FAQ
          if (filtered.isEmpty)
            _EmptyState(
              query: _query,
              onContact: () => _scrollToContact(context),
            )
          else
            ...filtered.map((f) => _FaqTile(item: f, key: ValueKey(f.q))),

          const SizedBox(height: 18),

          // CONTATO & SUPORTE
          Text(
            'Contato & Suporte',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.chat_bubble_outline),
                  title: const Text('Abrir ticket de suporte'),
                  subtitle: const Text('Descreva o problema e anexe prints'),
                  onTap: () => _fakeAction(context, 'Abrir ticket'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Enviar e-mail'),
                  subtitle: const Text('suporte@exemplo.com'),
                  onTap: () => _fakeAction(context, 'Enviar e-mail'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.menu_book_outlined),
                  title: const Text('Documentação'),
                  subtitle: const Text('Guias rápidos e respostas'),
                  onTap: () => _fakeAction(context, 'Abrir documentação'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // OUTROS
          Text(
            'Outros recursos',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          _LinkRow(
            icon: Icons.privacy_tip_outlined,
            title: 'Política de Privacidade',
            onTap: () => _fakeAction(context, 'Abrir política de privacidade'),
          ),
          _LinkRow(
            icon: Icons.article_outlined,
            title: 'Termos de Uso',
            onTap: () => _fakeAction(context, 'Abrir termos de uso'),
          ),

          const SizedBox(height: 24),
          Center(
            child: Text(
              'Precisa de algo que não está aqui? Toque em “Enviar feedback” no topo.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: cs.outline),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _setQuery(String q) {
    _searchCtrl.text = q;
    _searchCtrl.selection = TextSelection.fromPosition(
      TextPosition(offset: q.length),
    );
    setState(() {});
  }

  void _fakeAction(BuildContext context, String label) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label — ação de exemplo')));
  }

  void _scrollToContact(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Role até "Contato & Suporte" para falar conosco.'),
      ),
    );
  }

  Future<void> _openFeedbackDialog(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enviar feedback'),
          content: TextField(
            controller: controller,
            minLines: 3,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText:
                  'Conte brevemente o que você precisa ou o problema encontrado',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback enviado! Obrigado.')),
      );
    }
  }
}

/* ============================= WIDGETS AUXILIARES ============================= */

class _FaqItem {
  final String q;
  final String a;
  final List<String> tags;
  const _FaqItem({required this.q, required this.a, this.tags = const []});
}

class _FaqTile extends StatelessWidget {
  final _FaqItem item;
  const _FaqTile({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Theme(
        data: Theme.of(
          context,
        ).copyWith(dividerColor: cs.outlineVariant.withOpacity(.15)),
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          collapsedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(item.q),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.a,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _LinkRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: cs.primary),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      tileColor: Theme.of(context).colorScheme.surface,
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: cs.primary.withOpacity(.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.outlineVariant.withOpacity(.3)),
        ),
        child: Text(label, style: TextStyle(color: cs.onSurface)),
      ),
    );
  }
}

/// Estado de “nenhum resultado encontrado”
class _EmptyState extends StatelessWidget {
  final String query;
  final VoidCallback onContact;

  const _EmptyState({required this.query, required this.onContact});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          const Icon(Icons.help_outline, size: 56),
          const SizedBox(height: 12),
          Text(
            'Nenhum resultado',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            query.isEmpty
                ? 'Tente buscar por um termo.'
                : 'Não encontramos nada para "$query".',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: cs.outline),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onContact,
            icon: const Icon(Icons.support_agent_outlined),
            label: const Text('Falar com o suporte'),
          ),
        ],
      ),
    );
  }
}
