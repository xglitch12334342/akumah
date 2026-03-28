import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/study_service.dart';
import 'flashcard_study_page.dart';
import 'quiz_page.dart';
import 'notes_page.dart';

class StudyMaterialDetailPage extends StatelessWidget {
  final String materialId;

  const StudyMaterialDetailPage({super.key, required this.materialId});

  void _navigateTo(BuildContext context, Widget page) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    });
  }

  @override
  Widget build(BuildContext context) {
    final studyService = Provider.of<StudyService>(context);
    final material = studyService.getStudyMaterialById(materialId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF2196F3),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [const Color(0xFF2196F3), const Color(0xFF1565C0)],
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -50,
                      left: -50,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    // Icon in center
                    Center(
                      child: Icon(
                        Icons.auto_stories_rounded,
                        size: 80,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
              ),
              collapseMode: CollapseMode.parallax,
            ),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.6),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              material.title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              material.subject,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Consumer<StudyService>(
                        builder: (context, service, _) => GestureDetector(
                          onTap: () => service.toggleBookmark(material.id),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(
                                0xFF2196F3,
                              ).withValues(alpha: 0.1),
                            ),
                            child: Icon(
                              material.isBookmarked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: const Color(0xFF2196F3),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildStatCard(
                        'Difficulty',
                        material.difficulty,
                        Icons.trending_up,
                      ),
                      const SizedBox(width: 10),
                      _buildStatCard(
                        'Topics',
                        material.totalTopics.toString(),
                        Icons.book,
                      ),
                      const SizedBox(width: 10),
                      _buildStatCard(
                        'Est. Hours',
                        material.estimatedHours.toString(),
                        Icons.timer,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Wrap(
                      spacing: 10,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2196F3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            material.subject,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    material.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Study Progress',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${material.progressPercentage.toStringAsFixed(0)}% Complete',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        '${material.completedTopics.where((e) => e).length}/${material.topics.length} topics',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: material.progressPercentage / 100,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Topics',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  ...material.topics.asMap().entries.map((entry) {
                    final index = entry.key;
                    final topic = entry.value;
                    final completed = material.completedTopics[index];
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(topic),
                      value: completed,
                      activeColor: const Color(0xFF2196F3),
                      onChanged: (_) {
                        Provider.of<StudyService>(
                          context,
                          listen: false,
                        ).toggleTopicCompletion(material.id, index);
                      },
                    );
                  }),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      // Quick mark all topics as completed
                      final service = Provider.of<StudyService>(
                        context,
                        listen: false,
                      );
                      for (var i = 0; i < material.topics.length; i++) {
                        if (!material.completedTopics[i]) {
                          service.toggleTopicCompletion(material.id, i);
                        }
                      }
                    },
                    child: const Text(
                      'Start / Complete Topics',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Study Tools',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () => _navigateTo(
                      context,
                      FlashcardStudyPage(material: material),
                    ),
                    child: const Text(
                      'STUDY WITH FLASHCARDS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () =>
                        _navigateTo(context, QuizPage(material: material)),
                    child: const Text(
                      'TAKE A QUIZ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () =>
                        _navigateTo(context, NotesPage(material: material)),
                    child: const Text(
                      'MY NOTES',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF2196F3).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF2196F3), size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
