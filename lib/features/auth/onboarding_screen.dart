import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_wrapper.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _pageIndex = 0;

  final List<_OnboardingPageData> _pages = const [
    _OnboardingPageData(
      title: 'Welcome to AudioMood',
      subtitle:
          'Capture a selfie and let AI detect your vibe to generate the perfect playlist.',
      icon: Icons.face_retouching_natural,
    ),
    _OnboardingPageData(
      title: 'Music that matches you',
      subtitle:
          'We search Deezer instantly to find tracks that fit your current mood.',
      icon: Icons.library_music,
    ),
    _OnboardingPageData(
      title: 'Save your vibe',
      subtitle:
          'Your last mood is saved so you can jump back in without waiting.',
      icon: Icons.bookmark_added,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    ref.invalidate(onboardingSeenProvider);
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _pageIndex == _pages.length - 1;

    return Consumer(
      builder: (context, ref, _) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _pages.length,
                      onPageChanged: (index) {
                        setState(() => _pageIndex = index);
                      },
                      itemBuilder: (context, index) {
                        final page = _pages[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 140,
                                width: 140,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  page.icon,
                                  size: 72,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                page.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                page.subtitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        height: 8,
                        width: _pageIndex == index ? 28 : 8,
                        decoration: BoxDecoration(
                          color: _pageIndex == index
                              ? Colors.white
                              : Colors.white54,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: isLast
                          ? ElevatedButton.icon(
                              key: const ValueKey('start'),
                              onPressed: () => _completeOnboarding(ref),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF2575FC),
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: const Icon(Icons.login),
                              label: const Text(
                                'Sign up or sign in to start',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            )
                          : OutlinedButton(
                              key: const ValueKey('next'),
                              onPressed: () {
                                _controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white70),
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text('Next'),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (!isLast)
                    TextButton(
                      onPressed: () => _completeOnboarding(ref),
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OnboardingPageData {
  final String title;
  final String subtitle;
  final IconData icon;

  const _OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
