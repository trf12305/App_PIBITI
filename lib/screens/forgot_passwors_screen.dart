
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}
class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _enviando = false;

  static const Color rosa = Color(0xFFE45B8A);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _redefinirSenha() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enviando = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Se o e-mail estiver cadastrado, você receberá '
                'um link para redefinir sua senha.',
          ),
          duration: Duration(seconds: 6),
        ),
      );

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String mensagem = 'Não foi possível enviar o e-mail.';

      if (e.code == 'invalid-email') {
        mensagem = 'Informe um e-mail válido.';
      } else if (e.code == 'too-many-requests') {
        mensagem = 'Muitas tentativas. Tente novamente mais tarde.';
      } else if (e.code == 'network-request-failed') {
        mensagem = 'Verifique sua conexão com a internet.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocorreu um erro. Tente novamente.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _enviando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: rosa,
        elevation: 0,
        title: const Text('Recuperar senha'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 55),

                const Icon(
                  Icons.lock_reset_rounded,
                  color: rosa,
                  size: 85,
                ),

                const SizedBox(height: 25),

                const Text(
                  'Esqueceu sua senha?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: rosa,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Informe o e-mail cadastrado no Femme. '
                      'Enviaremos um link para você criar '
                      'uma nova senha.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [
                    AutofillHints.email,
                  ],
                  decoration: InputDecoration(
                    labelText: 'E-mail cadastrado',
                    hintText: 'exemplo@gmail.com',
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

                    if (email.isEmpty) {
                      return 'Digite seu e-mail.';
                    }

                    if (!RegExp(
                      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                    ).hasMatch(email)) {
                      return 'Digite um e-mail válido.';
                    }

                    return null;
                  },
                  onFieldSubmitted: (_) {
                    if (!_enviando) _redefinirSenha();
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed:
                    _enviando ? null : _redefinirSenha,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: rosa,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _enviando
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      'Enviar link de recuperação',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                TextButton(
                  onPressed: _enviando
                      ? null
                      : () => Navigator.pop(context),
                  child: const Text(
                    'Voltar para o login',
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
