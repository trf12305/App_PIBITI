import 'dart:math';

const List<String> frasesFemme = [
  'Cuidar de você é um ato de amor.',
  'Você merece cuidar de si todos os dias.',
  'Seu bem-estar também importa.',
  'Reserve um momento para cuidar de você.',
  'Ouça seu corpo e respeite seu tempo.',
  'Você é importante. Cuide-se.',
  'Pequenos cuidados fazem uma grande diferença.',
  'Seu corpo merece atenção e carinho.',
  'Cuide de si com o mesmo carinho que oferece aos outros.',
  'Você merece se sentir bem.',
  'Hoje é um bom dia para cuidar de você.',
  'Seu cuidado também deve estar na sua rotina.',
];

String obterFraseAleatoria() {
  final random = Random();
  return frasesFemme[random.nextInt(frasesFemme.length)];
}