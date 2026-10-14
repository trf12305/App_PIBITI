import 'package:flutter/material.dart';

import '../services/femme_store.dart';
import '../theme/femme_theme.dart';

class FemmeLog extends StatefulWidget {
  const FemmeLog({super.key});
  @override
  State<FemmeLog> createState() => _FemmeLogState();
}

class _FemmeLogState extends State<FemmeLog> {
  DateTime date = DateTime.now();
  final Map<String, String> values = {};
  bool saving = false;
  Future<void> pick() async {
    final d = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => date = d);
  }

  Future<void> save() async {
    setState(() => saving = true);
    try {
      await FemmeStore.saveLog(date, values);
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro salvo com segurança.')),
        );
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Não foi possível salvar: $e')));
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Registro diário',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton.icon(
              onPressed: pick,
              icon: const Icon(Icons.calendar_today),
              label: Text('${date.day}/${date.month}/${date.year}'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'Selecione as opções que descrevem seu dia. Você pode deixar categorias sem resposta.',
        ),
        const SizedBox(height: 20),
        _group('Menstruação', [
          'Leve',
          'Mediana',
          'Intensa',
          'Muito intensa',
        ], Icons.water_drop),
        _group('Corrimento', [
          'Branco',
          'Transparente',
          'Amarelo/verde',
          'Marrom',
          'Outro',
        ], Icons.opacity),
        _group('Odor', ['Sem odor', 'Odor diferente', 'Odor forte'], Icons.air),
        _group('Dores', [
          'Sem dor',
          'Dor pélvica',
          'Seios sensíveis',
          'Ardor ao urinar',
          'Dor durante relação',
        ], Icons.healing),
        _group('Outros sintomas', [
          'Coceira',
          'Ardência',
          'Irritação',
          'Inchaço',
          'Nenhum',
        ], Icons.favorite_border),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: saving ? null : save,
          child: Text(saving ? 'Salvando...' : 'Salvar registro'),
        ),
        const SizedBox(height: 12),
        const Text(
          'Este registro não fornece diagnóstico. Sintomas persistentes ou intensos devem ser avaliados por um profissional de saúde.',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    ),
  );
  Widget _group(String title, List<String> opts, IconData icon) => Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 9,
          runSpacing: 9,
          children: opts.map((o) {
            final selected = values[title] == o;
            return InkWell(
              onTap: () => setState(() => values[title] = o),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 100,
                height: 104,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: selected ? FemmeTheme.pale : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected ? FemmeTheme.pink : const Color(0xFFE9B4C5),
                    width: selected ? 2.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: FemmeTheme.pink, size: 30),
                    const SizedBox(height: 10),
                    Text(
                      o,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}
