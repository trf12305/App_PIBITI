import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class FemmeStore {
 static String get uid { final u=FirebaseAuth.instance.currentUser; if(u==null) throw StateError('Faça login primeiro'); return u.uid; }
 static DocumentReference<Map<String,dynamic>> get profile => FirebaseFirestore.instance.collection('usuarios').doc(uid);
 static CollectionReference<Map<String,dynamic>> get logs => profile.collection('registros_diarios');
 static CollectionReference<Map<String,dynamic>> get periods => profile.collection('periodos');
 static String dayKey(DateTime d) => '${d.year.toString().padLeft(4,'0')}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
 static Stream<DocumentSnapshot<Map<String,dynamic>>> profileStream()=>profile.snapshots();
 static Stream<QuerySnapshot<Map<String,dynamic>>> periodStream()=>periods.orderBy('inicio',descending:true).snapshots();
 static Stream<QuerySnapshot<Map<String,dynamic>>> logStream()=>logs.snapshots();
 static Future<void> saveLog(DateTime date, Map<String,dynamic> values)=>logs.doc(dayKey(date)).set({...values,'data':Timestamp.fromDate(DateTime(date.year,date.month,date.day)),'atualizadoEm':FieldValue.serverTimestamp()},SetOptions(merge:true));
 static Future<void> addPeriod(DateTime date)=>periods.add({'inicio':Timestamp.fromDate(DateTime(date.year,date.month,date.day)),'criadoEm':FieldValue.serverTimestamp()});
 static Future<void> updateProfile(Map<String,dynamic> data)=>profile.set(data,SetOptions(merge:true));
}
