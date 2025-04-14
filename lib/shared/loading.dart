import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(); // Keep it minimal
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Loader(), // Already centered by Center widget
      ),
    );
  }
}
