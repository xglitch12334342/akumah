class UserProgress {
  final String userId;
  final String studyMaterialId;
  final double progressPercentage;
  final int topicsCompleted;
  final int totalTopics;
  final DateTime lastStudiedDate;
  final Map<String, bool> topicCompletionStatus; // topicId -> completed

  UserProgress({
    required this.userId,
    required this.studyMaterialId,
    required this.progressPercentage,
    required this.topicsCompleted,
    required this.totalTopics,
    required this.lastStudiedDate,
    required this.topicCompletionStatus,
  });
}
