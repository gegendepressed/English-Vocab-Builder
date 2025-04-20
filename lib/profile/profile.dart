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

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent, // Updated AppBar color
          title: Text(
            user.displayName ?? 'Guest',
            style: const TextStyle(color: Colors.white), // White text for contrast
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    user.photoURL ??
                        'https://www.gravatar.com/avatar/placeholder', // Placeholder for non-logged-in user
                  ),
                  backgroundColor: Colors.transparent,
                ),

                const SizedBox(height: 20),

                // User Email
                Text(
                  user.email ?? 'No Email Available',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                // Quizzes Completed Stats
                Text(
                  '${report.total}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                Text(
                  'Quizzes Attempted',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.orangeAccent,
                  ),
                ),

                const SizedBox(height: 30),

                // Logout Button
                ElevatedButton(
                  onPressed: () async {
                    await AuthService().signOut();
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                    }
                  },
                  child: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.redAccent, // White text color for contrast
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Guest user - load default guest profile
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: const Text('Profile', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Guest Profile Image
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage('https://www.gravatar.com/avatar/placeholder'), // Placeholder for guests
                  backgroundColor: Colors.transparent,
                ),

                const SizedBox(height: 20),

                // Guest Email
                Text(
                  'Guest User',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 10),

                // Quizzes Completed Stats (For Guest, set to 0)
                Text(
                  '0',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                Text(
                  'Quizzes Attempted',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black45,
                  ),
                ),

                const SizedBox(height: 30),

                // Login Button (Guest User)
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the login screen if guest clicks login
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Login'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.green, // White text color for contrast
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
