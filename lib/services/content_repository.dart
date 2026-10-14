import 'dart:convert';
import 'package:flutter/services.dart';
class FemmeArticle {
 final String title; final List<String> paragraphs;
 FemmeArticle(this.title,this.paragraphs);
 factory FemmeArticle.fromJson(Map<String,dynamic> j)=>FemmeArticle(j['title'] as String,List<String>.from(j['paragraphs'] as List));
}
class ContentRepository {
 static Future<List<FemmeArticle>> load() async {
  final text=await rootBundle.loadString('assets/data/pibiti.json');
  return (jsonDecode(text) as List).map((e)=>FemmeArticle.fromJson(e as Map<String,dynamic>)).toList();
 }
}
