import 'package:flutter/material.dart';
import '../models/study_material.dart';

class StudyService with ChangeNotifier {
  final List<StudyMaterial> _allStudyMaterials = [
    StudyMaterial(
      id: '1',
      title: 'Introduction to Biology',
      subject: 'Biology',
      description:
          'Learn the basics of biology including cell structure, genetics, and ecosystems.',
      coverImageUrl: 'https://picsum.photos/400/600?random=1',
      totalTopics: 15,
      progressPercentage: 0.0,
      createdDate: DateTime(2024, 1, 1),
      topics: ['Cell Biology', 'Genetics', 'Evolution', 'Ecology'],
      difficulty: 'Beginner',
      source: 'Textbook',
      estimatedHours: 20,
    ),
    StudyMaterial(
      id: '2',
      title: 'Advanced Calculus',
      subject: 'Mathematics',
      description:
          'Master advanced calculus concepts including derivatives, integrals, and series.',
      coverImageUrl: 'https://picsum.photos/400/600?random=2',
      totalTopics: 25,
      progressPercentage: 0.0,
      createdDate: DateTime(2024, 1, 2),
      topics: [
        'Limits',
        'Derivatives',
        'Integrals',
        'Series',
        'Multivariable Calculus',
      ],
      difficulty: 'Advanced',
      source: 'Online Course',
      estimatedHours: 40,
    ),
    StudyMaterial(
      id: '3',
      title: 'World History 101',
      subject: 'History',
      description:
          'Explore major historical events from ancient civilizations to modern times.',
      coverImageUrl: 'https://picsum.photos/400/600?random=3',
      totalTopics: 20,
      progressPercentage: 0.0,
      createdDate: DateTime(2024, 1, 3),
      topics: [
        'Ancient Civilizations',
        'Middle Ages',
        'Renaissance',
        'Industrial Revolution',
        'Modern Era',
      ],
      difficulty: 'Intermediate',
      source: 'Textbook',
      estimatedHours: 30,
    ),
    StudyMaterial(
      id: '4',
      title: 'Programming Fundamentals',
      subject: 'Computer Science',
      description:
          'Learn the basics of programming with practical examples and exercises.',
      coverImageUrl: 'https://picsum.photos/400/600?random=4',
      totalTopics: 18,
      progressPercentage: 0.0,
      createdDate: DateTime(2024, 1, 4),
      topics: [
        'Variables',
        'Control Structures',
        'Functions',
        'Data Structures',
        'Algorithms',
      ],
      difficulty: 'Beginner',
      source: 'Online Course',
      estimatedHours: 25,
    ),
    StudyMaterial(
      id: '5',
      title: 'Physics Mechanics',
      subject: 'Physics',
      description:
          'Understand fundamental concepts of classical mechanics and motion.',
      coverImageUrl: 'https://picsum.photos/400/600?random=5',
      totalTopics: 22,
      progressPercentage: 0.0,
      createdDate: DateTime(2024, 1, 5),
      topics: [
        'Kinematics',
        'Dynamics',
        'Energy',
        'Momentum',
        'Rotational Motion',
      ],
      difficulty: 'Intermediate',
      source: 'Textbook',
      estimatedHours: 35,
    ),
  ];

  List<StudyMaterial> get allStudyMaterials => _allStudyMaterials;
  List<StudyMaterial> get bookmarked =>
      _allStudyMaterials.where((m) => m.isBookmarked).toList();

  void toggleBookmark(String materialId) {
    final material = _allStudyMaterials.firstWhere((m) => m.id == materialId);
    material.isBookmarked = !material.isBookmarked;
    notifyListeners();
  }

  void toggleTopicCompletion(String materialId, int topicIndex) {
    final material = _allStudyMaterials.firstWhere((m) => m.id == materialId);
    if (topicIndex < 0 || topicIndex >= material.topics.length) return;
    material.completedTopics[topicIndex] =
        !material.completedTopics[topicIndex];
    final completedCount = material.completedTopics.where((e) => e).length;
    material.progressPercentage =
        (completedCount / material.topics.length * 100).clamp(0, 100);
    notifyListeners();
  }

  List<StudyMaterial> getBySubject(String subject) {
    if (subject == 'All') return _allStudyMaterials;
    return _allStudyMaterials.where((m) => m.subject == subject).toList();
  }

  StudyMaterial getStudyMaterialById(String id) {
    return _allStudyMaterials.firstWhere((m) => m.id == id);
  }

  // Additional methods for study app
  List<String> getSubjects() {
    return _allStudyMaterials.map((m) => m.subject).toSet().toList();
  }

  List<StudyMaterial> getByDifficulty(String difficulty) {
    return _allStudyMaterials.where((m) => m.difficulty == difficulty).toList();
  }
}
