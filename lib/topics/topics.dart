import 'package:flutter/material.dart';
import 'package:quizapp/services/firestore.dart';
import 'package:quizapp/shared/bottom_nav.dart';
import 'package:quizapp/topics/drawer.dart';
import 'package:quizapp/topics/topic_item.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreService().getTopics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading topics'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No topics available'));
        }

        final topics = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            title: const Text('Topics'),
          ),

          drawer: TopicDrawer(topics:topics),
          body: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            crossAxisCount: 2,
            children: topics.map((topic) => TopicItem(topic : topic)).toList(),
          ),
          bottomNavigationBar: const BottomNav(),
        );
      },
    );
  }
}
