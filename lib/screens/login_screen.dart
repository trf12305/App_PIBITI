import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'femme_shell.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'forgot_passwors_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authService = AuthService();

  bool _mostrarSenha = false;
  bool _carregando = false;

  static const Color rosa = Color(0xFFC43F69);
  static const Color fundo = Color(0xFFFFF7F8);

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }
  Future<void> _entrar() async {
    debugPrint('LOGIN: botão Entrar acionado');

    if (!_formKey.currentState!.validate()) {
      debugPrint('LOGIN: formulário inválido');
      return;
    }

    setState(() => _carregando = true);

    try {
      debugPrint('LOGIN: iniciando autenticação Firebase');

      await _authService.entrar(
        email: _emailController.text.trim(),
        senha: _senhaController.text,
      );

      debugPrint('LOGIN: autenticação concluída');

      if (!mounted) return;

      debugPrint('LOGIN: abrindo FemmeShell');

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const FemmeShell(),
        ),
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('LOGIN: erro Firebase ${e.code} - ${e.message}');

      if (!mounted) return;

      _mensagem('Erro ao entrar: ${e.message ?? e.code}');
    } catch (e, stackTrace) {
      debugPrint('LOGIN: erro inesperado: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      _mensagem('Ocorreu um erro ao entrar.');
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  Future<void> _recuperarSenha() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _mensagem('Digite seu e-mail primeiro.');
      return;
    }

    try {
      await _authService.recuperarSenha(email);

      if (!mounted) return;

      _mensagem(
        'Se o e-mail estiver cadastrado, '
            'você receberá instruções de recuperação.',
      );
    } catch (_) {
      if (!mounted) return;
      _mensagem('Não foi possível solicitar a recuperação.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: rosa),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 24,
          ),
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

                const SizedBox(height: 20),

                const Text(
                  'Bem-vinda de volta!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    color: rosa,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Entre na sua conta para continuar '
                      'cuidando de você.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF666666),
                  ),
                ),

                const SizedBox(height: 45),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: rosa,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';

                    if (!RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(email)) {
                      return 'Informe um e-mail válido.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _senhaController,
                  obscureText: !_mostrarSenha,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite sua senha.';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Esqueci minha senha',
                      style: TextStyle(color: rosa),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _carregando ? null : _entrar,
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
                      'Entrar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Não tem uma conta?'),
                    TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: rosa,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
