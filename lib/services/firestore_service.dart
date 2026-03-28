import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_progress.dart';
import '../models/flashcard.dart';
import '../models/quiz.dart';
import '../models/note.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User Progress Collection
  Future<void> saveUserProgress(UserProgress progress) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('progress')
          .doc(progress.studyMaterialId)
          .set({
            'progressPercentage': progress.progressPercentage,
            'topicsCompleted': progress.topicsCompleted,
            'totalTopics': progress.totalTopics,
            'lastStudiedDate': progress.lastStudiedDate,
            'topicCompletionStatus': progress.topicCompletionStatus,
          });
    } catch (e) {
      throw Exception('Failed to save progress: $e');
    }
  }

  Future<UserProgress?> getUserProgress(String studyMaterialId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('progress')
          .doc(studyMaterialId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        return UserProgress(
          userId: _auth.currentUser!.uid,
          studyMaterialId: studyMaterialId,
          progressPercentage: data['progressPercentage'] ?? 0.0,
          topicsCompleted: data['topicsCompleted'] ?? 0,
          totalTopics: data['totalTopics'] ?? 0,
          lastStudiedDate: (data['lastStudiedDate'] as Timestamp).toDate(),
          topicCompletionStatus: Map<String, bool>.from(
            data['topicCompletionStatus'] ?? {},
          ),
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get progress: $e');
    }
  }

  // Flashcards Collection
  Future<void> saveFlashcard(Flashcard flashcard) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('flashcards')
          .doc(flashcard.id)
          .set({
            'studyMaterialId': flashcard.studyMaterialId,
            'question': flashcard.question,
            'answer': flashcard.answer,
            'category': flashcard.category,
            'correctCount': flashcard.correctCount,
            'incorrectCount': flashcard.incorrectCount,
            'lastReviewedDate': flashcard.lastReviewedDate,
          });
    } catch (e) {
      throw Exception('Failed to save flashcard: $e');
    }
  }

  Future<List<Flashcard>> getFlashcards(String studyMaterialId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('flashcards')
          .where('studyMaterialId', isEqualTo: studyMaterialId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Flashcard(
          id: doc.id,
          studyMaterialId: data['studyMaterialId'],
          question: data['question'],
          answer: data['answer'],
          category: data['category'],
          correctCount: data['correctCount'],
          incorrectCount: data['incorrectCount'],
          lastReviewedDate: (data['lastReviewedDate'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get flashcards: $e');
    }
  }

  // Quiz Results Collection
  Future<void> saveQuizResult(QuizResult result) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('quiz_results')
          .add({
            'quizId': result.quizId,
            'score': result.score,
            'timeSpent': result.timeSpent,
            'completedDate': result.completedDate,
            'userAnswers': result.userAnswers,
          });
    } catch (e) {
      throw Exception('Failed to save quiz result: $e');
    }
  }

  Future<List<QuizResult>> getQuizResults(String quizId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('quiz_results')
          .where('quizId', isEqualTo: quizId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return QuizResult(
          quizId: data['quizId'],
          userId: _auth.currentUser!.uid,
          score: data['score'],
          timeSpent: data['timeSpent'],
          completedDate: (data['completedDate'] as Timestamp).toDate(),
          userAnswers: List<int>.from(data['userAnswers'] ?? []),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get quiz results: $e');
    }
  }

  // Notes Collection
  Future<void> saveNote(StudyNote note) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(note.id)
          .set({
            'studyMaterialId': note.studyMaterialId,
            'title': note.title,
            'content': note.content,
            'color': note.color,
            'tags': note.tags,
            'createdDate': note.createdDate,
            'lastModifiedDate': note.lastModifiedDate,
          });
    } catch (e) {
      throw Exception('Failed to save note: $e');
    }
  }

  Future<List<StudyNote>> getNotes(String studyMaterialId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .where('studyMaterialId', isEqualTo: studyMaterialId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return StudyNote(
          id: doc.id,
          studyMaterialId: data['studyMaterialId'],
          title: data['title'],
          content: data['content'],
          color: data['color'],
          tags: List<String>.from(data['tags'] ?? []),
          createdDate: (data['createdDate'] as Timestamp).toDate(),
          lastModifiedDate: (data['lastModifiedDate'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get notes: $e');
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(noteId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }
}
