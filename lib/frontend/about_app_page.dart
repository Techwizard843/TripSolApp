import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About TripSol")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "TripSol: Your AI-Powered Travel Companion",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "TripSol helps you discover destinations, plan customized itineraries, "
              "and save your favorite trips. Built with Flutter, "
              "our goal is to make travel planning easier, smarter, and more personalized.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Text(
              "👩‍💻 Developed by:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              "Hasini, Sudhiksha, Mounika, Siddhi",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 10),
            Text(
              "📅 IIT Indore SOC Project - June–July 2025",
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
