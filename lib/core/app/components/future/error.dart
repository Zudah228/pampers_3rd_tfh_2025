import 'package:flutter/material.dart';

class ErrorInline extends StatelessWidget {
  const ErrorInline(
    this.error,
    this.stackTrace, {
    super.key,
  });

  final Object? error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.error, color: Theme.of(context).colorScheme.error),
    );
  }
}

class ErrorFullScreen extends StatelessWidget {
  const ErrorFullScreen(
    this.error,
    this.stackTrace, {
    super.key,
  });

  final Object? error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(error?.toString() ?? 'Unknown error'),
      ),
    );
  }
}

class ErrorListView extends StatelessWidget {
  const ErrorListView(
    this.error,
    this.stackTrace, {
    super.key,
  });

  final Object? error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(child: ErrorInline(error, stackTrace)),
    );
  }
}
