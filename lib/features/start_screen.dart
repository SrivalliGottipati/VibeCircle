import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import 'experience_select/view/experience_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with TickerProviderStateMixin {
  late AnimationController fadeCtrl;
  late AnimationController floatCtrl;
  late Animation<double> fadeIn;
  late Animation<double> floatAnim;

  @override
  void initState() {
    super.initState();

    fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    fadeIn = CurvedAnimation(parent: fadeCtrl, curve: Curves.easeOut);

    floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    floatAnim = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: floatCtrl, curve: Curves.easeInOut),
    );

    fadeCtrl.forward();
  }

  @override
  void dispose() {
    fadeCtrl.dispose();
    floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base1,
      body: Stack(
        children: [
          // Background soft glows
          Positioned(
            top: -120,
            left: -100,
            child: AnimatedBuilder(
              animation: floatAnim,
              builder: (_, __) => Transform.translate(
                offset: Offset(floatAnim.value, floatAnim.value),
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryAccent.withOpacity(0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -140,
            right: -120,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondaryAccent.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: fadeIn,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Welcome!",
                        style: Txt.h1.copyWith(
                          color: AppColors.text1,
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Before we begin, tell us why you want to host.\nWe’d love to understand your vision.",
                        style: Txt.body.copyWith(
                          color: AppColors.text3,
                          height: 1.5,
                          fontSize: 15.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 10),

                      GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ExperienceScreen()),
                          );
                        },
                        child: Container(
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryAccent.withOpacity(0.65),
                                AppColors.primaryAccent.withOpacity(0.38),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryAccent.withOpacity(0.18),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Start",
                            style: Txt.button.copyWith(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
