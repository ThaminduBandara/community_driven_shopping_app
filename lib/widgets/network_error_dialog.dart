import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/api_client.dart';

class NetworkErrorDialog extends StatefulWidget {
  final ApiException error;
  final VoidCallback onRetry;
  final VoidCallback? onClose;

  const NetworkErrorDialog({
    Key? key,
    required this.error,
    required this.onRetry,
    this.onClose,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required ApiException error,
    required VoidCallback onRetry,
    VoidCallback? onClose,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => NetworkErrorDialog(
        error: error,
        onRetry: onRetry,
        onClose: onClose,
      ),
    );
  }

  @override
  State<NetworkErrorDialog> createState() => _NetworkErrorDialogState();
}

class _NetworkErrorDialogState extends State<NetworkErrorDialog> {
  bool _isRetrying = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1a1a2e).withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_outlined,
                size: 48,
                color: Color(0xFFFF6B6B),
              ),
              const SizedBox(height: 16),
              Text(
                'Connection Error',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.error.message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[300],
                    ),
                textAlign: TextAlign.center,
              ),
              if (widget.error.statusCode != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Error Code: ${widget.error.statusCode}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[400],
                        ),
                  ),
                ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isRetrying
                          ? null
                          : () {
                              Navigator.of(context).pop();
                              widget.onClose?.call();
                            },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.grey,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Dismiss',
                        style: TextStyle(
                          color: _isRetrying ? Colors.grey : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isRetrying
                          ? null
                          : () async {
                              setState(() => _isRetrying = true);
                              try {
                                widget.onRetry();
                                if (mounted) {
                                  Navigator.of(context).pop();
                                }
                              } finally {
                                if (mounted) {
                                  setState(() => _isRetrying = false);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00D4FF),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        disabledBackgroundColor: Colors.grey[700],
                      ),
                      child: _isRetrying
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.grey[700] ?? Colors.grey,
                                ),
                              ),
                            )
                          : const Text(
                              'Retry',
                              style: TextStyle(
                                color: Color(0xFF1a1a2e),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
