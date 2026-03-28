class Flashcard {
  final String id;
  final String studyMaterialId; // Foreign key
  final String question;
  final String answer;
  final String category;
  int correctCount;
  int incorrectCount;
  DateTime lastReviewedDate;

  Flashcard({
    required this.id,
    required this.studyMaterialId,
    required this.question,
    required this.answer,
    required this.category,
    this.correctCount = 0,
    this.incorrectCount = 0,
    required this.lastReviewedDate,
  });
}
