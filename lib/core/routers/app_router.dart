import 'package:flutter/material.dart';
import '../../features/experience_select/view/experience_screen.dart';
import '../../features/onboarding_question/view/question_screen.dart';
import '../../features/start_screen.dart';

class AppRouter {
  static const start ='/start';
  static const experience = '/';
  static const question = '/question';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case experience:
        return MaterialPageRoute(builder: (_) => const ExperienceScreen());
      case question:
        return MaterialPageRoute(builder: (_) => const QuestionScreen());
      case start:
        return MaterialPageRoute(builder: (_) => const StartScreen());
      default:
        return MaterialPageRoute(builder: (_) => const StartScreen());
    }
  }
}
