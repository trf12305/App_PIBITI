import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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

              // ==========================================
              // DECORAÇÃO SUPERIOR
              // ==========================================

              Positioned(
                top: -80,
                left: -70,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9DCE3),
                    borderRadius: BorderRadius.circular(130),
                  ),
                ),
              ),

              // ==========================================
              // CONTEÚDO
              // ==========================================

              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    38,
                    110,
                    38,
                    110,
                  ),
                  child: Column(
                    children: [

                      // ==================================
                      // TÍTULO
                      // ==================================

                      const Text(
                        'Bem-vinda!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // ==================================
                      // CORAÇÃO
                      // ==================================

                      const Icon(
                        Icons.favorite_border,
                        color: AppColors.darkPink,
                        size: 40,
                      ),

                      const SizedBox(height: 28),

                      // ==================================
                      // TEXTO
                      // ==================================

                      const Text(
                        'Um espaço feito para você\n'
                            'cuidar da sua saúde, do seu\n'
                            'bem-estar e da sua essência.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.45,
                          color: Color(0xFF48252E),
                        ),
                      ),

                      const SizedBox(height: 42),

                      // ==================================
                      // CARTÃO 1
                      // ==================================

                      _InfoCard(
                        icon: Icons.calendar_month_outlined,
                        title: 'Acompanhe seu ciclo',
                        subtitle: 'menstrual',
                      ),

                      const SizedBox(height: 14),

                      // ==================================
                      // CARTÃO 2
                      // ==================================

                      _InfoCard(
                        icon: Icons.favorite_border,
                        title: 'Dicas e conteúdos',
                        subtitle: 'exclusivos',
                      ),

                      const SizedBox(height: 14),

                      // ==================================
                      // CARTÃO 3
                      // ==================================

                      _InfoCard(
                        icon: Icons.verified_user_outlined,
                        title: 'Cuide da sua saúde',
                        subtitle: 'e previna-se',
                      ),

                      const SizedBox(height: 58),

                      // ==================================
                      // BOTÃO
                      // ==================================

                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            _continuar(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Vamos lá!',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 38),

                      // ==================================
                      // INDICADOR DE PÁGINAS
                      // ==================================

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _PageDot(active: true),
                          _PageDot(active: false),
                          _PageDot(active: false),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ==========================================
              // SETA ESQUERDA
              // ==========================================

              Positioned(
                left: -7,
                top: 430,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              ),

              // ==========================================
              // SETA DIREITA
              // ==========================================

              Positioned(
                right: -7,
                top: 430,
                child: GestureDetector(
                  onTap: () {
                    _continuar(context);
                  },
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _continuar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }
}


// ======================================================
// CARTÃO DE INFORMAÇÃO
// ======================================================

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 88,
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFF2E2E6),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [

          Icon(
            icon,
            color: AppColors.primary,
            size: 39,
          ),

          const SizedBox(width: 28),

          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$title\n',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: subtitle,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageDot extends StatelessWidget {
  final bool active;

  const _PageDot({
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7),
      width: active ? 13 : 10,
      height: active ? 13 : 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active
            ? AppColors.primary
            : const Color(0xFFE9E3E5),
      ),
    );
  }
}