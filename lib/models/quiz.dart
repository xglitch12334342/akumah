class Quiz {
  final String id;
  final String studyMaterialId;
  final String title;
  final List<QuizQuestion> questions;
  final int timeLimit; // minutes
  final double passingScore; // 70, 80, etc.

  Quiz({
    required this.id,
    required this.studyMaterialId,
    required this.title,
    required this.questions,
    required this.timeLimit,
    required this.passingScore,
  });
}

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  String? userAnswer;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.userAnswer,
  });
}

class QuizResult {
  final String quizId;
  final String userId;
  final double score;
  final int timeSpent;
  final DateTime completedDate;
  final List<int> userAnswers;

  QuizResult({
    required this.quizId,
    required this.userId,
    required this.score,
    required this.timeSpent,
    required this.completedDate,
    required this.userAnswers,
  });
}
