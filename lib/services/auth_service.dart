
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get usuarioAtual => _auth.currentUser;

  Stream<User?> get estadoAutenticacao =>
      _auth.authStateChanges();

  Future<void> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );

    final user = credential.user;

    if (user == null) {
      throw Exception('Não foi possível criar a conta.');
    }

    await user.updateDisplayName(nome.trim());

    await _firestore.collection('usuarios').doc(user.uid).set({
      'uid': user.uid,
      'nome': nome.trim(),
      'email': user.email,
      'dataCadastro': FieldValue.serverTimestamp(),
    });
  }

  Future<void> entrar({
    required String email,
    required String senha,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );
  }

  Future<void> recuperarSenha(String email) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  Future<void> sair() async {
    await _auth.signOut();
  }
}
