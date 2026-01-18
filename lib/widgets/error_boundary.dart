import 'package:flutter/material.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final void Function(Object error, StackTrace stackTrace)? onError;

  const ErrorBoundary({
    Key? key,
    required this.child,
    this.onError,
  }) : super(key: key);

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (FlutterErrorDetails details) {
      setState(() {
        _error = details.exception;
        _stackTrace = details.stack;
      });
      widget.onError?.call(details.exception, details.stack ?? StackTrace.current);
    };
  }

  void _reset() {
    setState(() {
      _error = null;
      _stackTrace = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF1a1a2e),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Color(0xFFFF6B6B),
                ),
                const SizedBox(height: 24),
                Text(
                  'Oops! Something went wrong',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  _error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[300],
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _reset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D4FF),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(
                      color: Color(0xFF1a1a2e),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widget.child;
  }
}
