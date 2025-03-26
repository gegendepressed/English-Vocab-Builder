import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart'; // ✅ Import for SVG support

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Description
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "The place where the magic lies and goodness forge.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // Team Name
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "--- Team : CodeForcers ---",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
          ),

          const SizedBox(height: 10),

          // Team Members
          Expanded(
            child: ListView(
              children: const [
                TeamMember(
                  name: "Sairaj Pai",
                  description: "I'm passionate about tabla, sci-fi, sitcoms, and movies, while also exploring coding and embracing diverse experiences.",
                  college: "KC College Of Engineering, Thane",
                  avatar: "assets/avatars/sairaj.svg",
                ),
                TeamMember(
                  name: "Yash Patil",
                  description: "I'm passionate about Programming, sci-fi, OpenSource, and Philosophy while also Reading books.",
                  college: "KC College Of Engineering, Thane",
                  avatar: "assets/avatars/yash.svg",
                ),
                TeamMember(
                  name: "Nandini Nichite",
                  description: "Passionate about reading books and diving into coding, exploring new realms in literature and technology with enthusiasm.",
                  college: "KC College Of Engineering, Thane",
                  avatar: "assets/avatars/nandini.svg",
                ),
              ],
            ),
          ),

          // GitHub Button
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  final Uri url = Uri.parse("https://github.com/gegendepressed/Flutter-App");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    debugPrint("Could not launch $url");
                  }
                },
                icon: const Icon(Icons.code), // ✅ Added icon
                label: const Text("Project Source Code"), // ✅ Fixed missing label
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TeamMember extends StatelessWidget {
  final String name;
  final String description;
  final String college;
  final String avatar;

  const TeamMember({super.key, required this.name, required this.description, required this.college, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.transparent,
        child: SvgPicture.asset(avatar),
      ),
      title: Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          Text(college, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        ],
      ),
    );
  }
}
