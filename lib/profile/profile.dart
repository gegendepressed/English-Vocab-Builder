import 'package:flutter/material.dart';
import 'package:quizapp/services/auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Screen'),  
      ),
      body: ElevatedButton(onPressed : ()async {
        await AuthService().signOut();
        Navigator.pushNamedAndRemoveUntil(context, '/');
      }, child: child),
    );
  }
}
