import '../models/experience.dart';
import '../services/api_client.dart';

class ExperienceRepository {
  ExperienceRepository(this._api);
  final ApiClient _api;

  Future<List<Experience>> fetch() async {
    final list = await _api.getExperiencesRaw();
    return list
        .map((e) => Experience.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
