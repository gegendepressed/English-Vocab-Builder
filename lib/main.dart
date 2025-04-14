import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/routes.dart';
import 'package:quizapp/services/services.dart';
import 'package:quizapp/shared/shared.dart';
import 'package:quizapp/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Error state
        if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Something went wrong')),
            ),
          );
        }

        // Firebase initialized
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<Report>(
            create: (_) => FirestoreService().streamReport(),
            catchError: (_, __) => Report(),
            initialData: Report(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              routes: appRoutes,
              theme: appTheme,
            ),
          );
        }

        // Loading state
        return const MaterialApp(
          home: LoadingScreen(),
        );
      },
    );
  }
}
