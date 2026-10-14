import 'package:flutter/material.dart';
import '../services/content_repository.dart';
import '../theme/femme_theme.dart';

class FemmeContent extends StatefulWidget {
 const FemmeContent({super.key});

 @override
 State<FemmeContent> createState() => _FemmeContentState();
}

class _FemmeContentState extends State<FemmeContent> {
 String query = '';
 String category = 'Todos';

 @override
 Widget build(BuildContext context) {
  return SafeArea(
   child: FutureBuilder<List<FemmeArticle>>(
    future: ContentRepository.load(),
    builder: (context, snapshot) {
     if (snapshot.hasError) {
      return const Center(
       child: Text('Erro ao carregar os conteúdos.'),
      );
     }

     if (!snapshot.hasData) {
      return const Center(
       child: CircularProgressIndicator(),
      );
     }

     final all = snapshot.data!;

     final filtered = all.where((article) {
      final matchesCategory =
          category == 'Todos' || article.title == category;

      final matchesQuery =
      '${article.title} ${article.paragraphs.join(' ')}'
          .toLowerCase()
          .contains(query.toLowerCase());

      return matchesCategory && matchesQuery;
     }).toList();

     return ListView(
      padding: const EdgeInsets.all(22),
      children: [
       const Text(
        'Conteúdos',
        style: TextStyle(
         fontSize: 27,
         fontWeight: FontWeight.w600,
        ),
       ),
       const SizedBox(height: 18),

       TextField(
        onChanged: (value) {
         setState(() => query = value);
        },
        decoration: const InputDecoration(
         prefixIcon: Icon(Icons.search),
         hintText: 'Buscar conteúdos...',
        ),
       ),

       const SizedBox(height: 14),

       SizedBox(
        height: 42,
        child: ListView(
         scrollDirection: Axis.horizontal,
         children: [
          'Todos',
          ...all.map((article) => article.title),
         ].map((item) {
          return Padding(
           padding: const EdgeInsets.only(right: 8),
           child: ChoiceChip(
            label: Text(item),
            selected: category == item,
            selectedColor: FemmeTheme.pale,
            onSelected: (_) {
             setState(() => category = item);
            },
           ),
          );
         }).toList(),
        ),
       ),

       const SizedBox(height: 20),

       const Text(
        'Recomendados para você',
        style: TextStyle(
         fontWeight: FontWeight.bold,
         fontSize: 17,
        ),
       ),

       const SizedBox(height: 12),

       ...filtered.map((article) {
        return Card(
         color: Colors.white,
         margin: const EdgeInsets.only(bottom: 12),
         child: ListTile(
          contentPadding: const EdgeInsets.all(15),
          leading: const CircleAvatar(
           backgroundColor: FemmeTheme.pale,
           child: Icon(
            Icons.auto_stories,
            color: FemmeTheme.pink,
           ),
          ),
          title: Text(
           article.title,
           style: const TextStyle(
            fontWeight: FontWeight.w600,
           ),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
           Navigator.push(
            context,
            MaterialPageRoute(
             builder: (_) => FemmeArticlePage(
              title: article.title,
             ),
            ),
           );
          },
         ),
        );
       }),

       const SizedBox(height: 18),

      ],
     );
    },
   ),
  );
 }
}

class FemmeArticlePage extends StatelessWidget {
 final String title;

 const FemmeArticlePage({
  super.key,
  required this.title,
 });

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: Text(title),
   ),
   body: FutureBuilder<List<FemmeArticle>>(
    future: ContentRepository.load(),
    builder: (context, snapshot) {
     if (snapshot.hasError) {
      return const Center(
       child: Text('Erro ao carregar o artigo.'),
      );
     }

     if (!snapshot.hasData) {
      return const Center(
       child: CircularProgressIndicator(),
      );
     }

     final matches = snapshot.data!
         .where((article) => article.title == title);

     if (matches.isEmpty) {
      return const Center(
       child: Text('Conteúdo não encontrado.'),
      );
     }

     final article = matches.first;

     return ListView(
      padding: const EdgeInsets.all(22),
      children: [
       Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
         color: FemmeTheme.pale,
         borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
         'Material extraído do documento PIBITI, '
             'sem revisão clínica final. '
             'Não substitui avaliação profissional.',
         style: TextStyle(fontSize: 12),
        ),
       ),

       const SizedBox(height: 20),

       ...article.paragraphs.map((paragraph) {
        final isHeading = paragraph.length < 75;

        return Padding(
         padding: const EdgeInsets.only(bottom: 15),
         child: Text(
          paragraph,
          style: TextStyle(
           fontSize: isHeading ? 16 : 14,
           height: 1.55,
           fontWeight: isHeading
               ? FontWeight.w600
               : FontWeight.normal,
           color: const Color(0xFF392D33),
          ),
         ),
        );
       }),
      ],
     );
    },
   ),
  );
 }
}
