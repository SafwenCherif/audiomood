import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';
import '../emotion/camera_screen.dart';
import 'onboarding_screen.dart';
import 'auth_provider.dart';
import 'login_screen.dart';

final onboardingSeenProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onboarding_seen') ?? false;
});

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final authState = ref.watch(authStateProvider);
        final onboardingSeen = ref.watch(onboardingSeenProvider);

        return authState.when(
          data: (user) {
            if (user != null) {
              return const CameraScreen();
            }

            return onboardingSeen.when(
              data: (seen) {
                if (!seen) {
                  return const OnboardingScreen();
                }
                return const LoginScreen();
              },
              loading: () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) {
                final l10n = AppLocalizations.of(context)!;
                return Scaffold(
                  body: Center(child: Text(l10n.errorGeneric(e.toString()))),
                );
              },
            );
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (e, _) {
            final l10n = AppLocalizations.of(context)!;
            return Scaffold(
              body: Center(child: Text(l10n.errorGeneric(e.toString()))),
            );
          },
        );
      },
    );
  }
}
