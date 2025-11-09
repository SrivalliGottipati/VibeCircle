import 'package:dio/dio.dart';
import '../../core/constants.dart';

class ApiClient {
  ApiClient(this._dio);
  final Dio _dio;

  Future<List<dynamic>> getExperiencesRaw() async {
    final res = await _dio.get(Api.experiences);
    final map = res.data as Map<String, dynamic>;
    return (map['data']['experiences'] as List).cast<dynamic>();
  }
}
