import 'package:dio/dio.dart';
import '../data/repositories/experience_repository.dart';
import '../data/services/api_client.dart';

class DI {
  static late final Dio dio;
  static late final ApiClient api;
  static late final ExperienceRepository experiences;

  static Future<void> init() async {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );
    api = ApiClient(dio);
    experiences = ExperienceRepository(api);
  }
}
