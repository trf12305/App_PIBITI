import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/femme_store.dart';
import '../theme/femme_theme.dart';

class FemmeCycle extends StatefulWidget {
  const FemmeCycle({super.key});
  @override
  State<FemmeCycle> createState() => _FemmeCycleState();
}

class _FemmeCycleState extends State<FemmeCycle> {
  DateTime month = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime selected = DateTime.now();
  Future<void> _add() async {
    try {
      await FemmeStore.addPeriod(selected);
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Início do período registrado!')),
        );
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.all(22),
      children: [
        const Text(
          'Calendário do ciclo',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 26),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () =>
                  setState(() => month = DateTime(month.year, month.month - 1)),
              icon: const Icon(Icons.chevron_left),
            ),
            Text(
              '${_monthName(month.month)} ${month.year}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () =>
                  setState(() => month = DateTime(month.year, month.month + 1)),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FemmeStore.periodStream(),
          builder: (context, s) {
            final starts = (s.data?.docs ?? [])
                .map((e) => (e.data()['inicio'] as Timestamp).toDate())
                .toList();
            final offset = DateTime(month.year, month.month, 1).weekday % 7;
            final days = DateTime(month.year, month.month + 1, 0).day;
            return Column(
              children: [
                Row(
                  children: ['D', 'S', 'T', 'Q', 'Q', 'S', 'S']
                      .map(
                        (d) => Expanded(
                          child: Center(
                            child: Text(
                              d,
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: offset + days,
                  itemBuilder: (context, i) {
                    if (i < offset) return const SizedBox.shrink();
                    final d = DateTime(month.year, month.month, i - offset + 1);
                    final period = starts.any((start) {
                      final delta = d
                          .difference(
                            DateTime(start.year, start.month, start.day),
                          )
                          .inDays;
                      return delta >= 0 && delta < 5;
                    });
                    final active =
                        FemmeStore.dayKey(d) == FemmeStore.dayKey(selected);
                    return InkWell(
                      onTap: () => setState(() => selected = d),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: period ? FemmeTheme.pale : null,
                          border: active
                              ? Border.all(color: FemmeTheme.pink, width: 2)
                              : null,
                        ),
                        child: Text(
                          '${d.day}',
                          style: TextStyle(
                            color: period ? FemmeTheme.dark : null,
                            fontWeight: active ? FontWeight.bold : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 22),
        const Wrap(
          spacing: 14,
          runSpacing: 8,
          children: [
            _Legend('Menstruação', FemmeTheme.pink),
            _Legend('Estimativas não exibidas', Colors.grey),
          ],
        ),
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dia selecionado: ${selected.day}/${selected.month}/${selected.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Os dias em rosa representam uma janela visual de até cinco dias após cada início registrado. Não é uma previsão de duração, ovulação ou fertilidade.',
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _add,
                child: const Text('Registrar início do período'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  String _monthName(int m) => const [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ][m - 1];
}

class _Legend extends StatelessWidget {
  final String label;
  final Color color;
  const _Legend(this.label, this.color);
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircleAvatar(radius: 4, backgroundColor: color),
      const SizedBox(width: 5),
      Text(label, style: const TextStyle(fontSize: 11)),
    ],
  );
}
