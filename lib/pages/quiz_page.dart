import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../models/study_material.dart';

class QuizPage extends StatefulWidget {
  final StudyMaterial material;

  const QuizPage({required this.material, super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Quiz quiz;
  int currentQuestionIndex = 0;
  List<int?> userAnswers = [];
  bool questionsAnswered = false;

  @override
  void initState() {
    super.initState();
    quiz = _generateSampleQuiz();
    userAnswers = List<int?>.filled(quiz.questions.length, null);
  }

  Quiz _generateSampleQuiz() {
    return Quiz(
      id: '1',
      studyMaterialId: widget.material.id,
      title: '${widget.material.title} Quiz',
      timeLimit: 30,
      passingScore: 70,
      questions: [
        QuizQuestion(
          id: '1',
          question: 'What is the capital of France?',
          options: ['London', 'Paris', 'Berlin', 'Madrid'],
          correctAnswerIndex: 1,
        ),
        QuizQuestion(
          id: '2',
          question: 'What is 5 + 3?',
          options: ['7', '8', '9', '10'],
          correctAnswerIndex: 1,
        ),
        QuizQuestion(
          id: '3',
          question: 'Which planet is closest to the sun?',
          options: ['Venus', 'Mercury', 'Earth', 'Mars'],
          correctAnswerIndex: 1,
        ),
        QuizQuestion(
          id: '4',
          question: 'Who wrote Romeo and Juliet?',
          options: [
            'Jane Austen',
            'William Shakespeare',
            'Mark Twain',
            'Charles Dickens',
          ],
          correctAnswerIndex: 1,
        ),
        QuizQuestion(
          id: '5',
          question: 'What is the chemical symbol for Gold?',
          options: ['Go', 'Gd', 'Au', 'Ag'],
          correctAnswerIndex: 2,
        ),
      ],
    );
  }

  void _selectAnswer(int optionIndex) {
    setState(() {
      userAnswers[currentQuestionIndex] = optionIndex;
      quiz.questions[currentQuestionIndex].userAnswer =
          quiz.questions[currentQuestionIndex].options[optionIndex];
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < quiz.questions.length - 1) {
      setState(() => currentQuestionIndex++);
    } else {
      _showResults();
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() => currentQuestionIndex--);
    }
  }

  void _showResults() {
    int correctCount = 0;
    for (int i = 0; i < quiz.questions.length; i++) {
      if (userAnswers[i] == quiz.questions[i].correctAnswerIndex) {
        correctCount++;
      }
    }

    final score = (correctCount / quiz.questions.length * 100).toStringAsFixed(
      1,
    );
    final isPassed = double.parse(score) >= quiz.passingScore;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isPassed ? 'Congratulations!' : 'Results'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: isPassed ? Colors.green : Colors.orange,
              child: Icon(
                isPassed ? Icons.check : Icons.info,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Score: $score%',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Correct: $correctCount/${quiz.questions.length}'),
            Text('Required: ${quiz.passingScore}%'),
            const SizedBox(height: 8),
            if (!isPassed)
              const Text(
                'Try again to improve your score!',
                style: TextStyle(color: Colors.orange),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = quiz.questions[currentQuestionIndex];
    final selectedAnswer = userAnswers[currentQuestionIndex];
    final answeredCount = userAnswers.where((a) => a != null).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.title),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${currentQuestionIndex + 1}/${quiz.questions.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Answered: $answeredCount/${quiz.questions.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF2196F3),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (currentQuestionIndex + 1) / quiz.questions.length,
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    currentQuestion.question,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(currentQuestion.options.length, (index) {
                    final option = currentQuestion.options[index];
                    final isSelected = selectedAnswer == index;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => _selectAnswer(index),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF2196F3)
                                  : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected
                                ? const Color(0xFF2196F3).withValues(alpha: 0.1)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF2196F3)
                                        : Colors.grey[300]!,
                                  ),
                                  color: isSelected
                                      ? const Color(0xFF2196F3)
                                      : Colors.transparent,
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  option,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: currentQuestionIndex > 0
                          ? _previousQuestion
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Previous'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: selectedAnswer != null ? _nextQuestion : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        currentQuestionIndex == quiz.questions.length - 1
                            ? 'Finish'
                            : 'Next',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
