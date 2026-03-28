class StudyMaterial {
  final String id;
  final String title;
  final String subject;
  final String description;
  final String coverImageUrl;
  final int totalTopics;
  double progressPercentage;
  final DateTime createdDate;
  bool isBookmarked;

  // New fields for study app
  final List<String> topics;
  List<bool> completedTopics;
  final String difficulty; // Beginner, Intermediate, Advanced
  final String source; // Textbook, Online Course, etc.
  final int estimatedHours; // Time to complete

  StudyMaterial({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.coverImageUrl,
    required this.totalTopics,
    required this.progressPercentage,
    required this.createdDate,
    this.isBookmarked = false,
    required this.topics,
    required this.difficulty,
    required this.source,
    required this.estimatedHours,
    List<bool>? completedTopics,
  }) : completedTopics =
           completedTopics ?? List<bool>.filled(topics.length, false);
}
