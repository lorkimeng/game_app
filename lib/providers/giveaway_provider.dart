import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/giveaway_model.dart';
import '../services/api_service.dart';
import '../services/giveaway_service.dart';

// 1. API Service Provider
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// 2. Giveaway Service Provider
final giveawayServiceProvider = Provider<GiveawayService>((ref) {
  final apiService = ref.watch(apiServiceProvider);

  return GiveawayService(apiService);
});

// 3. Get All Giveaways Provider
final giveawayProvider = FutureProvider<List<GiveawayModel>>((ref) async {
  final service = ref.watch(giveawayServiceProvider);

  return service.getGiveaways();
});

// 4. Get Giveaway Detail Provider
final giveawayDetailProvider = FutureProvider.family<GiveawayModel, int>((
  ref,
  id,
) async {
  final service = ref.watch(giveawayServiceProvider);

  return service.getGiveawayById(id);
});
