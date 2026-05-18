import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'network_service.dart';

final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService();
});

final hasInternetProvider = FutureProvider<bool>((ref) async {
  return ref.watch(networkServiceProvider).hasInternetConnection();
});
