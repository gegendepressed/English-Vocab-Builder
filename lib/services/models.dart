import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart'; // Add this to generate the part file

@JsonSerializable()
class Option {
  String value;
  String detail;
  bool correct;

  Option({
    this.value = '',
    this.detail = '',
    this.correct = false,
  });

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);
  Map<String, dynamic> toJson() => _$OptionToJson(this);
}

@JsonSerializable()
class Question {
  String text;
  List<Option> options;

  Question({
    this.options = const [],
    this.text = '',
  });

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class Quiz {
  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final String video;
  final String topic;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    this.video = '',
    this.topic = '',
    this.questions = const [],
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? 'default_id',
      title: json['title'] ?? 'Untitled Quiz',
      description: json['description'] ?? 'No description provided',
      category: json['category'] ?? 'General',
      difficulty: json['difficulty'] ?? 'Easy',
      video: json['video'] ?? '',
      topic: json['topic'] ?? '',
      questions: (json['questions'] as List<dynamic>?)
          ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'video': video,
      'topic': topic,
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }
}

@JsonSerializable()
class Topic {
  String id; // Default value for id
  final String title;
  final String description;
  final String img;
  final List<String> categories; // Added categories field to store topic categories
  final List<Quiz> quizzes;

  Topic({
    this.id = '', // Default value for id
    this.title = '',
    this.description = '',
    this.img = 'default.png',
    this.categories = const [], // Default empty list for categories
    this.quizzes = const [], // Default empty list for quizzes
  });

  // Factory constructor for creating a Topic from JSON
  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      img: json['img'] ?? 'default.png',
      categories: List<String>.from(json['categories'] ?? []), // Deserialize categories field
      quizzes: (json['quizzes'] as List<dynamic>?)
          ?.map((quizJson) => Quiz.fromJson(quizJson)) // Convert quizzes from JSON if available
          .toList() ??
          [], // Default to an empty list if no quizzes found
    );
  }

  // Convert Topic to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'img': img,
      'categories': categories,
      'quizzes': quizzes.map((quiz) => quiz.toJson()).toList(), // Convert quizzes to JSON
    };
  }
}

@JsonSerializable()
class Report {
  String uid;
  int total;
  Map topics;

  Report({
    this.uid = '',
    this.topics = const {},
    this.total = 0,
  });

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
