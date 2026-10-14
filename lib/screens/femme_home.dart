import 'package:flutter/material.dart';

import '../services/femme_store.dart';
import '../theme/femme_theme.dart';
import 'femme_content.dart';

class FemmeHome extends StatelessWidget {
  final ValueChanged<int> openTab;
  const FemmeHome({super.key, required this.openTab});
  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
      children: [
        StreamBuilder(
          stream: FemmeStore.profileStream(),
          builder: (context, snapshot) {
            final data = snapshot.data?.data();
            final name = (data?['nome'] ?? '')
                .toString()
                .trim()
                .split(' ')
                .first;
            return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá, ${name.isEmpty ? 'Bem-vinda' : name}! 👋',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('Como você está hoje?'),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Suas notificações aparecerão aqui.'),
                    ),
                  ),
                  icon: const Icon(
                    Icons.notifications_none,
                    color: FemmeTheme.pink,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        StreamBuilder(
          stream: FemmeStore.periodStream(),
          builder: (context, s) {
            final docs = s.data?.docs ?? [];
            final start = docs.isNotEmpty
                ? (docs.first.data()['inicio'] as dynamic).toDate() as DateTime
                : null;
            final day = start == null
                ? null
                : DateTime.now().difference(start).inDays + 1;
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(color: Color(0x12B23C67), blurRadius: 18),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Seu ciclo atual',
                          style: TextStyle(
                            color: FemmeTheme.dark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          day == null
                              ? 'Registre seu período'
                              : 'Dia $day do ciclo',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => openTab(2),
                          child: const Text('Registrar período'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  SizedBox(
                    width: 98,
                    height: 98,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const CircularProgressIndicator(
                          value: .38,
                          strokeWidth: 11,
                          color: FemmeTheme.pink,
                          backgroundColor: FemmeTheme.pale,
                        ),
                        Icon(
                          Icons.water_drop,
                          color: FemmeTheme.pink,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 22),
        const Text(
          'Acesso rápido',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 14),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: .98,
          children: [
            _tile(
              context,
              'Calendário',
              Icons.calendar_month,
              () => openTab(1),
            ),
            _tile(
              context,
              'Higiene',
              Icons.favorite_border,
              () => _article(context, 'Higiene'),
            ),
            _tile(
              context,
              'Conteúdo',
              Icons.menu_book_outlined,
              () => openTab(3),
            ),
            _tile(
              context,
              'Saúde Vaginal',
              Icons.local_florist_outlined,
              () => _article(context, 'Saúde Vaginal'),
            ),
            _tile(
              context,
              'Prevenção',
              Icons.health_and_safety_outlined,
              () => _article(context, 'Prevenção'),
            ),
            _tile(
              context,
              'Sintomas',
              Icons.self_improvement_outlined,
              () => _article(context, 'Sintomas'),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: FemmeTheme.pale,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dica do dia',
                style: TextStyle(
                  color: FemmeTheme.dark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Você tem o direito de conversar sobre prevenção e exigir respeito às suas escolhas. O autocuidado também envolve informação e diálogo.',
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ],
    ),
  );
  Widget _tile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback tap,
  ) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: tap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: FemmeTheme.pink, size: 31),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
  void _article(BuildContext context, String title) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => FemmeArticlePage(title: title)),
  );
}
