import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/network_provider.dart';
import '../../core/network/network_service.dart';
import '../../widgets/history_card.dart';
import '../../widgets/network_error_view.dart';
import 'history_detail_screen.dart';
import 'history_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  void _retry(WidgetRef ref, String userId) {
    ref.invalidate(hasInternetProvider);
    ref.invalidate(moodHistoryStreamProvider(userId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mood History')),
        body: const Center(child: Text('Please sign in to view history.')),
      );
    }

    final connectionAsync = ref.watch(hasInternetProvider);
    final historyAsync = ref.watch(moodHistoryStreamProvider(user.uid));
    final firestoreService = ref.read(firestoreServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood History'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => _retry(ref, user.uid),
          ),
        ],
      ),
      body: connectionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => NetworkErrorView(
          failureType: NetworkFailureType.unknown,
          message: 'Could not check your connection. Please try again.',
          onRetry: () => _retry(ref, user.uid),
        ),
        data: (isConnected) {
          if (!isConnected) {
            return NetworkErrorView(
              failureType: NetworkFailureType.offline,
              message:
                  'Mood history is stored online. Turn on Wi‑Fi or mobile data to load your past moods.',
              onRetry: () => _retry(ref, user.uid),
            );
          }

          return historyAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) {
              final networkError = NetworkService.from(err);
              return NetworkErrorView(
                failureType: networkError.type,
                message: networkError.message,
                onRetry: () => _retry(ref, user.uid),
              );
            },
            data: (items) {
              if (items.isEmpty) {
                return const Center(child: Text('No history yet.'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Dismissible(
                    key: ValueKey(item.id),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete history?'),
                              content: const Text(
                                'This will permanently remove this mood record.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          ) ??
                          false;
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red.shade600,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) async {
                      try {
                        final network = ref.read(networkServiceProvider);
                        await network.ensureConnected();
                        await firestoreService.deleteHistory(user.uid, item.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('History deleted.')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          final networkError = NetworkService.from(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(networkError.message),
                              backgroundColor: Colors.red.shade700,
                            ),
                          );
                        }
                      }
                    },
                    child: HistoryCard(
                      history: item,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HistoryDetailScreen(history: item),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
