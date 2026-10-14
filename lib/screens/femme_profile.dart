import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/femme_store.dart';
import '../theme/femme_theme.dart';

class FemmeProfile extends StatefulWidget {
  const FemmeProfile({super.key});
  @override
  State<FemmeProfile> createState() => _FemmeProfileState();
}

class _FemmeProfileState extends State<FemmeProfile> {
  final name = TextEditingController();
  bool loaded = false;
  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: StreamBuilder(
      stream: FemmeStore.profileStream(),
      builder: (context, s) {
        final data = s.data?.data() ?? {};
        if (!loaded && s.hasData) {
          name.text = (data['nome'] ?? '').toString();
          loaded = true;
        }
        return ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const Icon(Icons.account_circle, color: FemmeTheme.pink, size: 75),
            const SizedBox(height: 12),
            const Text(
              'Meu perfil',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 14),
            Text('E-mail: ${FirebaseAuth.instance.currentUser?.email ?? '-'}'),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                await FemmeStore.updateProfile({'nome': name.text.trim()});
                if (context.mounted)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Perfil atualizado.')),
                  );
              },
              child: const Text('Salvar perfil'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted)
                  Navigator.of(context).popUntil((r) => r.isFirst);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sair da conta'),
            ),
            const SizedBox(height: 25),
            const Text(
              'Privacidade: seus registros são dados sensíveis. Configure as regras do Firestore e uma política de privacidade antes da publicação.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        );
      },
    ),
  );
}
