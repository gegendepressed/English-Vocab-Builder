import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/services/services.dart';
import 'package:quizapp/shared/shared.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var report = Provider.of<Report>(context);
    var user = AuthService().user;

    // Get the current theme data
    final theme = Theme.of(context);

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          title: Text(user.displayName ?? 'Guest'),
          elevation: 0, // Remove shadow for a cleaner look
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding around content
          child: Center(
            child: SingleChildScrollView(  // Allows scrolling if content overflows
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                children: [
                  // Profile Picture (Circle Avatar)
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(user.photoURL ??
                        'https://www.gravatar.com/avatar/placeholder'), // Placeholder if no photo
                  ),
                  const SizedBox(height: 16), // Spacing between profile and email

                  // Display User Email
                  Text(
                    user.email ?? 'No Email Available',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20), // Spacing between email and quizzes completed

                  // Display Quizzes Completed
                  Text(
                    '${report.total}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Quizzes Completed',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 14,
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),

                  const SizedBox(height: 40), // Add spacing before the button

                  // Logout Button
                  ElevatedButton(
                    onPressed: () async {
                      await AuthService().signOut();
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return const Loading();
    }
  }
}
