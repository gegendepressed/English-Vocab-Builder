import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:quizapp/services/auth.dart';
import 'package:quizapp/services/models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all topics from Firestore (synonyms, antonyms, etc.)
  Future<List<Topic>> getTopics() async {
    try {
      var ref = _db.collection('topics');
      var snapshot = await ref.get();

      if (snapshot.docs.isEmpty) {
        print("No topics found");
        return [];
      }

      var data = snapshot.docs.map((s) => s.data()).toList();
      var topics = data.map((d) => Topic.fromJson(d ?? {}));
      return topics.toList();
    } catch (e) {
      print("Error fetching topics: $e");
      return []; // Return an empty list in case of an error
    }
  }

  // Get a specific quiz from Firestore (now with a specific path under difficulty level)
  // Get a specific quiz from Firestore (now with a specific path under difficulty level)
// Get a specific quiz from Firestore (now with a specific path under difficulty level)
  Future<List<Quiz>> getQuiz(String topic, String category, String difficulty, String quizId) async {
    try {
      // Construct the path dynamically using the parameters provided
      var ref = _db.collection('quizzes') // The top-level collection
          .doc(topic) // Dynamically set topic, e.g., "synonyms", "antonyms", etc.
          .collection(category)  // Dynamically set category, e.g., "noun", "verb", etc.
          .doc(difficulty)  // Dynamically set difficulty level, e.g., "easy", "medium", "hard"
          .collection('$difficulty.yaml') // The sub-collection under difficulty level with .yaml suffix
          .doc(quizId);  // Dynamically set quiz ID (e.g., "hard_1.yaml", "easy_2.yaml", etc.)

      // Print the constructed Firestore path for debugging
      print("Firestore Path: ${ref.path}");

      var snapshot = await ref.get();  // Get the specific quiz document

      if (!snapshot.exists) {
        print("No quizzes found at path: ${ref.path}");
        return []; // Return an empty list if no quizzes are found
      }

      // Convert the document to a Quiz object
      var quiz = Quiz.fromJson(snapshot.data() ?? {});

      return [quiz];  // Return the quiz as a list

    } catch (e) {
      print("Error fetching quizzes: $e");
      return []; // Return an empty list in case of an error
    }
  }



  // Stream of the user's report, with proper error handling
  Stream<Report> streamReport() {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var ref = _db.collection('reports').doc(user.uid);
        return ref.snapshots().map((doc) {
          return doc.exists ? Report.fromJson(doc.data() ?? {}) : Report();
        }).handleError((e) {
          print("Error fetching report: $e");
        });
      } else {
        return Stream.value(Report()); // Stream a default report when user is null
      }
    });
  }

  // Update the user's report after completing a quiz
  Future<void> updateUserReport(Quiz quiz) async {
    try {
      var user = AuthService().user!;
      var ref = _db.collection('reports').doc(user.uid);

      // Ensure quiz.topic and quiz.id are not null, providing default values
      var topic = quiz.topic ?? 'default_topic';
      var quizId = quiz.id ?? 'default_quiz_id';

      var data = {
        'total': FieldValue.increment(1),
        'topics': {
          topic: FieldValue.arrayUnion([quizId])
        }
      };

      await ref.set(data, SetOptions(merge: true));
      print("User report updated successfully");
    } catch (e) {
      print("Error updating user report: $e");
    }
  }
}
