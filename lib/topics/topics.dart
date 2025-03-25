import 'package:flutter/material.dart';
import 'package:quizapp/shared/bottom_nav.dart';


class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Topics Screen', style: Theme.of(context).textTheme.titleLarge)),
      bottomNavigationBar: const BottomNav(),// ✅ Added a body
    );
  }
}
