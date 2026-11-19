import '../models/giveaway_model.dart';
import '../utils/app_constants.dart';
import 'api_service.dart';

class GiveawayService {
  final ApiService _apiService;

  GiveawayService(this._apiService);

  // Get all giveaways
  Future<List<GiveawayModel>> getGiveaways() async {
    final response = await _apiService.get(AppConstants.giveaways);

    if (response is! List) {
      throw Exception('Invalid giveaways response');
    }

    return response.map((item) {
      return GiveawayModel.fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }

  // Get giveaway by ID
  Future<GiveawayModel> getGiveawayById(int id) async {
    final response = await _apiService.get(
      AppConstants.giveawayDetail,
      queryParameters: {'id': id},
    );

    if (response is! Map) {
      throw Exception('Invalid giveaway detail response');
    }

    return GiveawayModel.fromJson(Map<String, dynamic>.from(response));
  }
}
