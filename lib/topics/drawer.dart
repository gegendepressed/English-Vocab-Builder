import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/services/models.dart';
import 'package:quizapp/quizzes/quiz.dart';
import 'package:quizapp/services/firestore.dart';

class TopicDrawer extends StatelessWidget {
  final List<Topic> topics;

  const TopicDrawer({super.key, required this.topics});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: topics.length,
        itemBuilder: (BuildContext context, int idx) {
          Topic topic = topics[idx];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Text(
                  topic.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ),
              CategoryList(topic: topic), // Pass the topic to fetch categories
            ],
          );
        },
        separatorBuilder: (BuildContext context, int idx) => const Divider(),
      ),
    );
  }
}

class CategoryList extends StatefulWidget {
  final Topic topic;
  const CategoryList({super.key, required this.topic});

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String selectedCategory = ''; // Keep track of selected category

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.topic.categories.map((category) {
        return ListTile(
          title: Text(category), // Show the category name (e.g., Adjectives)
          onTap: () {
            setState(() {
              selectedCategory = category; // Update the selected category
            });
          },
        );
      }).toList(),
    );
  }
}

class DifficultyList extends StatelessWidget {
  final String topicId;
  final String category;
  const DifficultyList({super.key, required this.topicId, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ['easy', 'medium', 'hard'].map((difficulty) {
        return Card(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 4,
          margin: const EdgeInsets.all(4),
          child: InkWell(
            onTap: () {
              // When a difficulty is selected, fetch quizzes for that difficulty
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => QuizListScreen(
                    topicId: topicId,
                    category: category,
                    difficulty: difficulty,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(
                  difficulty.toUpperCase(), // Show difficulty level (Easy, Medium, Hard)
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class QuizListScreen extends StatelessWidget {
  final String topicId;
  final String category;
  final String difficulty;
  const QuizListScreen({
    super.key,
    required this.topicId,
    required this.category,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$category - $difficulty')),
      body: FutureBuilder<List<Quiz>>(
        future: FirestoreService().getQuiz(
          topicId,        // Pass the topic ID
          category,       // Dynamic category
          difficulty,     // Dynamic difficulty
          '',             // Empty quizId (will fetch all quizzes for the difficulty)
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var quizzes = snapshot.data ?? [];

          return ListView(
            children: quizzes.map((quiz) {
              return Card(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                elevation: 4,
                margin: const EdgeInsets.all(4),
                child: InkWell(
                  onTap: () {
                    // Navigate to the quiz screen when a quiz is tapped
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => QuizScreen(
                          quizId: quiz.id, // Pass the quiz ID
                          topic: topicId,   // Pass the topic ID
                          category: quiz.category, // Pass category (synonyms, antonyms, etc.)
                          difficulty: quiz.difficulty, // Pass quiz difficulty
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                        quiz.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Text(
                        quiz.description,
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      leading: QuizBadge(topic: topicId, quizId: quiz.id),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class QuizBadge extends StatelessWidget {
  final String quizId;
  final String topic;

  const QuizBadge({super.key, required this.quizId, required this.topic});

  @override
  Widget build(BuildContext context) {
    Report report = Provider.of<Report>(context);
    List completed = report.topics[topic] ?? [];
    if (completed.contains(quizId)) {
      return const Icon(FontAwesomeIcons.checkDouble, color: Colors.green);
    } else {
      return const Icon(FontAwesomeIcons.solidCircle, color: Colors.grey);
    }
  }
}
