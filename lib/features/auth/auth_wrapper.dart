import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../emotion/camera_screen.dart';
import 'onboarding_screen.dart';
import 'auth_provider.dart';
import 'login_screen.dart';

const String googleWebClientId =
    'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';

final onboardingSeenProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onboarding_seen') ?? false;
});

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final onboardingSeen = ref.watch(onboardingSeenProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          // If logged in, go to the main app screen
          return const CameraScreen();
        }

        return onboardingSeen.when(
          data: (seen) {
            if (!seen) {
              return const OnboardingScreen();
            }
            return const LoginScreen();
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (e, trace) => Scaffold(body: Center(child: Text("Error: $e"))),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, trace) => Scaffold(body: Center(child: Text("Error: $e"))),
    );
  }
}
