  import 'package:flutter/material.dart';
  import 'package:font_awesome_flutter/font_awesome_flutter.dart';
  import 'package:provider/provider.dart';
  import 'package:quizapp/quizzes/quizstate.dart';
  import 'package:quizapp/services/firestore.dart';
  import 'package:quizapp/services/models.dart';
  import 'package:quizapp/shared/loading.dart';
  import 'package:quizapp/shared/progress_bar.dart';

  class QuizScreen extends StatelessWidget {
    const QuizScreen({super.key, required this.quizId});
    final String quizId;

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
        create: (_) => QuizState(),
        child: FutureBuilder<Quiz>(
          future: FirestoreService().getQuiz(quizId),
          builder: (context, snapshot) {
            var state = Provider.of<QuizState>(context);

            if (!snapshot.hasData || snapshot.hasError) {
              return const Center(child: Loader());
            } else {
              var quiz = snapshot.data!;

              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.blueGrey,
                  title: AnimatedProgressbar(value: state.progress),
                  leading: IconButton(
                    icon: const Icon(FontAwesomeIcons.xmark),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  controller: state.controller,
                  onPageChanged: (int idx) =>
                  state.progress = (idx / (quiz.questions.length + 1)),
                  itemBuilder: (BuildContext context, int idx) {
                    if (idx == 0) {
                      return StartPage(quiz: quiz);
                    } else if (idx == quiz.questions.length + 1) {
                      return CongratsPage(quiz: quiz);
                    } else {
                      return QuestionPage(question: quiz.questions[idx - 1]);
                    }
                  },
                ),
              );
            }
          },
        ),
      );
    }
  }

  class StartPage extends StatelessWidget {
    final Quiz quiz;
    const StartPage({super.key, required this.quiz});

    @override
    Widget build(BuildContext context) {
      var state = Provider.of<QuizState>(context);

      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

            // Description Text
            Text(
              quiz.description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const Spacer(),

            // Start Quiz Button
            ElevatedButton.icon(
              onPressed: state.nextPage,
              label: const Text('Start Quiz!'),
              icon: const Icon(Icons.poll),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Spacer(flex: 2),
          ],
        ),
      );
    }
  }


  class CongratsPage extends StatelessWidget {
    final Quiz quiz;
    const CongratsPage({super.key, required this.quiz});

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Congrats! You completed the ${quiz.title} quiz',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            const Divider(),
            Image.asset('assets/congrats.gif'),
            const Divider(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                    horizontal: 25, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: const Icon(FontAwesomeIcons.check),
              label: const Text('Mark Complete!'),
              onPressed: () {
                FirestoreService().updateUserReport(quiz);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/topics',
                      (route) => false,
                );
              },
            ),
          ],
        ),
      );
    }
  }

  class QuestionPage extends StatelessWidget {
    final Question question;
    const QuestionPage({super.key, required this.question});

    @override
    Widget build(BuildContext context) {
      var state = Provider.of<QuizState>(context);

      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Text(
                question.text,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: question.options.map((opt) {
                return Container(
                  height: 90,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: () {
                      state.selected = opt;
                      _bottomSheet(context, opt, state);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                              state.selected == opt
                                  ? FontAwesomeIcons.circleCheck
                                  : FontAwesomeIcons.circle,
                              size: 30,
                              color: Colors.white),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 16),
                              child: Text(
                                opt.value,
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    }

    /// Bottom sheet shown when Question is answered
    _bottomSheet(BuildContext context, Option opt, QuizState state) {
      bool correct = opt.correct;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 250,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(correct ? 'Good Job!' : 'Wrong',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                Text(
                  opt.detail,
                  style: const TextStyle(fontSize: 18, color: Colors.white54),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: correct ? Colors.green : Colors.red,
                  ),
                  child: Text(
                    correct ? 'Onward!' : 'Try Again',
                    style: const TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    if (correct) {
                      state.nextPage();
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }
