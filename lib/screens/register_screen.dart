
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _confirmarSenha = TextEditingController();

  final _authService = AuthService();

  bool _carregando = false;
  bool _mostrarSenha = false;

  static const Color rosa = Color(0xFFC43F69);
  static const Color fundo = Color(0xFFFFF7F8);

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _senha.dispose();
    _confirmarSenha.dispose();
    super.dispose();
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    try {
      await _authService.cadastrar(
        nome: _nome.text,
        email: _email.text,
        senha: _senha.text,
      );

      if (!mounted) return;

      _mensagem('Conta criada com sucesso!');

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String mensagem = 'Não foi possível criar a conta.';

      if (e.code == 'email-already-in-use') {
        mensagem = 'Este e-mail já está cadastrado.';
      } else if (e.code == 'weak-password') {
        mensagem = 'Escolha uma senha mais forte.';
      } else if (e.code == 'invalid-email') {
        mensagem = 'E-mail inválido.';
      }

      _mensagem(mensagem);
    } catch (e) {
      if (!mounted) return;

      _mensagem(
        'Erro ao finalizar o cadastro. '
            'Confira a conexão e as regras do Firestore.',
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  InputDecoration _campo(String titulo, IconData icone) {
    return InputDecoration(
      labelText: titulo,
      prefixIcon: Icon(icone),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        title: const Text('Criar conta'),
        backgroundColor: fundo,
        foregroundColor: rosa,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(26),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.favorite,
                  color: rosa,
                  size: 48,
                ),

                const SizedBox(height: 18),

                const Text(
                  'Crie sua conta',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: rosa,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Comece sua jornada de autocuidado.',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 35),

                TextFormField(
                  controller: _nome,
                  textCapitalization: TextCapitalization.words,
                  decoration: _campo(
                    'Nome completo',
                    Icons.person_outline,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Informe seu nome.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _campo(
                    'E-mail',
                    Icons.email_outlined,
                  ),
                  validator: (v) {
                    final email = v?.trim() ?? '';

                    if (!RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(email)) {
                      return 'Informe um e-mail válido.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                TextFormField(
                  controller: _senha,
                  obscureText: !_mostrarSenha,
                  decoration: _campo(
                    'Senha',
                    Icons.lock_outline,
                  ).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _mostrarSenha
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _mostrarSenha = !_mostrarSenha;
                        });
                      },
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.length < 6) {
                      return 'A senha precisa ter pelo menos 6 caracteres.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                TextFormField(
                  controller: _confirmarSenha,
                  obscureText: !_mostrarSenha,
                  decoration: _campo(
                    'Confirmar senha',
                    Icons.lock_reset_outlined,
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Confirme sua senha.';
                    }

                    if (v != _senha.text) {
                      return 'As senhas não coincidem.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _carregando ? null : _cadastrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: rosa,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _carregando
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      'Criar minha conta',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Já tenho uma conta',
                    style: TextStyle(color: rosa),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
