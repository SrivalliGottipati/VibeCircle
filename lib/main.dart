import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di.dart';
import 'core/routers/app_router.dart';
import 'core/theme/theme.dart';
import 'data/repositories/experience_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DI.init();
  runApp(const HotspotApp());
}

class HotspotApp extends StatelessWidget {
  const HotspotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ExperienceRepository>.value(
      value: DI.experiences,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hotspot Onboarding',
        theme: buildTheme(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.start,
      ),
    );
  }
}
