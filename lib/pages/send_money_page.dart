import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudyCompanionPage extends StatefulWidget {
  const StudyCompanionPage({super.key});

  @override
  State<StudyCompanionPage> createState() => _StudyCompanionPageState();
}

class _StudyCompanionPageState extends State<StudyCompanionPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Tips'),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFF2196F3),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user?.email ?? 'Student',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Welcome to Smart Study App!',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Study Tips',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildTipCard(
                icon: Icons.lightbulb,
                title: 'Use Flashcards',
                description:
                    'Flashcards are great for memorizing facts and testing your knowledge regularly.',
              ),
              _buildTipCard(
                icon: Icons.quiz,
                title: 'Take Quizzes',
                description:
                    'Quizzes help you assess your understanding and identify weak areas.',
              ),
              _buildTipCard(
                icon: Icons.note,
                title: 'Write Notes',
                description:
                    'Taking notes helps reinforce learning and creates a reference guide.',
              ),
              _buildTipCard(
                icon: Icons.trending_up,
                title: 'Track Progress',
                description:
                    'Monitor your progress to stay motivated and identify improvement areas.',
              ),
              const SizedBox(height: 20),
              const Text(
                'Features',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildFeatureList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF2196F3), size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [
      'Interactive Flashcards for effective memorization',
      'Multiple Choice Quizzes with instant feedback',
      'Color-coded Notes for better organization',
      'Progress Tracking across all materials',
      'Search functionality to find topics quickly',
      'Bookmark important materials for quick access',
      'Dark/Light theme support',
      'Firebase integration for cloud sync',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features
          .map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(feature)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
