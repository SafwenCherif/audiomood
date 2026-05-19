import 'package:flutter/material.dart';
import '../core/network/network_service.dart';
import '../l10n/app_localizations.dart';

class NetworkErrorView extends StatelessWidget {
  const NetworkErrorView({
    super.key,
    required this.failureType,
    required this.message,
    this.onRetry,
  });

  final NetworkFailureType failureType;
  final String message;
  final VoidCallback? onRetry;

  IconData get _icon {
    switch (failureType) {
      case NetworkFailureType.offline:
        return Icons.wifi_off_rounded;
      case NetworkFailureType.timeout:
        return Icons.timer_off_rounded;
      case NetworkFailureType.server:
        return Icons.cloud_off_rounded;
      case NetworkFailureType.unknown:
        return Icons.error_outline_rounded;
    }
  }

  String _title(AppLocalizations l10n) {
    switch (failureType) {
      case NetworkFailureType.offline:
        return l10n.errorTitleOffline;
      case NetworkFailureType.timeout:
        return l10n.errorTitleTimeout;
      case NetworkFailureType.server:
        return l10n.errorTitleServer;
      case NetworkFailureType.unknown:
        return l10n.errorTitleUnknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_icon, size: 72, color: Colors.deepPurple.shade300),
            const SizedBox(height: 16),
            Text(
              _title(l10n),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.tryAgain),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 48),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
