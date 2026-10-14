import 'package:flutter/material.dart';
import '../theme/femme_theme.dart';
class FemmeNav extends StatelessWidget {
 final int index; final ValueChanged<int> onTap;
 const FemmeNav({super.key,required this.index,required this.onTap});
 @override Widget build(BuildContext context)=>NavigationBar(height:76,selectedIndex:index,onDestinationSelected:onTap,indicatorColor:FemmeTheme.pale,backgroundColor:Colors.white,destinations:const [
 NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home,color:FemmeTheme.pink),label:'Início'),
 NavigationDestination(icon:Icon(Icons.access_time),selectedIcon:Icon(Icons.access_time_filled,color:FemmeTheme.pink),label:'Ciclo'),
 NavigationDestination(icon:Icon(Icons.add_circle_outline,size:32),selectedIcon:Icon(Icons.add_circle,color:FemmeTheme.pink,size:34),label:'Registrar'),
 NavigationDestination(icon:Icon(Icons.menu_book_outlined),selectedIcon:Icon(Icons.menu_book,color:FemmeTheme.pink),label:'Conteúdos'),
 NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person,color:FemmeTheme.pink),label:'Perfil')]);
}
