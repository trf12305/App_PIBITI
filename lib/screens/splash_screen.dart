import 'package:flutter/material.dart';
import 'welcome_screen.dart';

import '../data/phrases.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String frase;

  @override
  void initState() {
    super.initState();

    frase = obterFraseAleatoria();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(
              color: AppColors.border,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [

              // =====================================================
              // IMAGEM PRINCIPAL
              // =====================================================

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 570,
                child: Image.asset(
                  'assets/images/femme_illustracao.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),

              // =====================================================
              // LOGO
              // =====================================================

              Positioned(
                top: 430,
                left: 0,
                right: 0,
                child: Column(
                  children: [

                    // Flor
                    Icon(
                      Icons.local_florist,
                      color: AppColors.darkPink,
                      size: 58,
                    ),

                    const SizedBox(height: 2),

                    // Femme
                    const Text(
                      'Femme',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 52,
                        height: 0.9,
                        color: AppColors.darkPink,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Subtítulo
                    const Text(
                      'CUIDADOS FEMININOS',
                      style: TextStyle(
                        color: AppColors.darkPink,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ],
                ),
              ),

              // =====================================================
              // FRASE DINÂMICA
              // =====================================================

              Positioned(
                left: 30,
                right: 30,
                bottom: 185,
                child: Text(
                  frase,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 19,
                    height: 1.35,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              // =====================================================
              // CORAÇÃO
              // =====================================================

              const Positioned(
                left: 0,
                right: 0,
                bottom: 125,
                child: Icon(
                  Icons.favorite_border,
                  color: AppColors.darkPink,
                  size: 32,
                ),
              ),

              // =====================================================
              // BOTÃO COMEÇAR
              // =====================================================

              Positioned(
                left: 30,
                right: 30,
                bottom: 30,
                child: SizedBox(
                  height: 58,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WelcomeScreen(),
                          ),
                        );
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Começar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  }