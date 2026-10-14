import 'package:flutter/material.dart';
class FemmeTheme {
 static const pink=Color(0xFFC13E69), dark=Color(0xFF98294E), bg=Color(0xFFFFF5F7), pale=Color(0xFFFBE6EC);
 static ThemeData get theme => ThemeData(useMaterial3:true, scaffoldBackgroundColor:bg, colorScheme:ColorScheme.fromSeed(seedColor:pink, surface:bg), appBarTheme:const AppBarTheme(backgroundColor:bg, foregroundColor:Color(0xFF28212A), centerTitle:true), inputDecorationTheme:InputDecorationTheme(filled:true,fillColor:Colors.white,border:OutlineInputBorder(borderRadius:BorderRadius.circular(16),borderSide:BorderSide.none)), elevatedButtonTheme:ElevatedButtonThemeData(style:ElevatedButton.styleFrom(backgroundColor:pink,foregroundColor:Colors.white,minimumSize:const Size(0,48),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14)))));
}
