import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../models/study_material.dart';

class FlashcardStudyPage extends StatefulWidget {
  final StudyMaterial material;

  const FlashcardStudyPage({required this.material, super.key});

  @override
  State<FlashcardStudyPage> createState() => _FlashcardStudyPageState();
}

class _FlashcardStudyPageState extends State<FlashcardStudyPage> {
  late List<Flashcard> flashcards;
  late List<bool> showAnswers;
  int currentIndex = 0;
  late PageController _pageController;
  Map<String, bool> answered = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Generate sample flashcards
    flashcards = _generateSampleFlashcards();
    showAnswers = List<bool>.filled(flashcards.length, false);
  }

  List<Flashcard> _generateSampleFlashcards() {
    return [
      Flashcard(
        id: '1',
        studyMaterialId: widget.material.id,
        question: 'What is the capital of France?',
        answer: 'Paris',
        category: 'Geography',
        lastReviewedDate: DateTime.now(),
      ),
      Flashcard(
        id: '2',
        studyMaterialId: widget.material.id,
        question: 'What is 2 + 2?',
        answer: '4',
        category: 'Math',
        lastReviewedDate: DateTime.now(),
      ),
      Flashcard(
        id: '3',
        studyMaterialId: widget.material.id,
        question: 'What is the largest planet in our solar system?',
        answer: 'Jupiter',
        category: 'Science',
        lastReviewedDate: DateTime.now(),
      ),
    ];
  }

  void _markCorrect() {
    flashcards[currentIndex].correctCount++;
    answered[flashcards[currentIndex].id] = true;
    setState(() => showAnswers[currentIndex] = false);
    _nextCard();
  }

  void _markIncorrect() {
    flashcards[currentIndex].incorrectCount++;
    answered[flashcards[currentIndex].id] = true;
    setState(() => showAnswers[currentIndex] = false);
    _nextCard();
  }

  void _nextCard() {
    if (!mounted || !_pageController.hasClients) return;
    if (currentIndex < flashcards.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    final correctCount = flashcards.where((f) => f.correctCount > 0).length;
    final accuracy = (correctCount / flashcards.length * 100).toStringAsFixed(
      1,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Session Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Total Cards: ${flashcards.length}'),
            Text('Correct: $correctCount'),
            Text('Accuracy: $accuracy%'),
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.material.title),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Card ${currentIndex + 1}/${flashcards.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                LinearProgressIndicator(
                  value: (currentIndex + 1) / flashcards.length,
                  minHeight: 8,
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                  showAnswers[index] = false;
                });
              },
              itemCount: flashcards.length,
              itemBuilder: (context, index) {
                final flashcard = flashcards[index];
                return GestureDetector(
                  onTap: () {
                    setState(() => showAnswers[index] = !showAnswers[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Card(
                        key: ValueKey(showAnswers[index]),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: showAnswers[index]
                                  ? [
                                      const Color(0xFF4CAF50),
                                      const Color(0xFF45a049),
                                    ]
                                  : [
                                      const Color(0xFF2196F3),
                                      const Color(0xFF1976D2),
                                    ],
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    showAnswers[index] ? 'Answer' : 'Question',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    showAnswers[index]
                                        ? flashcard.answer
                                        : flashcard.question,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'Tap to ${showAnswers[index] ? 'see question' : 'reveal answer'}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (showAnswers[currentIndex])
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _markIncorrect,
                      icon: const Icon(Icons.clear),
                      label: const Text('Incorrect'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _markCorrect,
                      icon: const Icon(Icons.check),
                      label: const Text('Correct'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
