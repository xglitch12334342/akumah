import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../theme_manager.dart';
import '../services/study_service.dart';
import '../models/study_material.dart';
import 'study_material_detail_page.dart';
import 'search_page.dart';
import 'flashcard_study_page.dart';
import 'quiz_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _selectedSubject = 'All';

  void _navigateTo(Widget page) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final themeManager = Provider.of<ThemeManager>(context);
    final studyService = Provider.of<StudyService>(context);

    return Scaffold(
      backgroundColor: themeManager.themeMode == ThemeMode.dark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F5F5),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildSubjectsTab(studyService),
          _buildFlashcardsTab(studyService),
          _buildQuizzesTab(studyService),
          _buildProgressTab(user, studyService),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2196F3),
        unselectedItemColor: Colors.grey,
        backgroundColor: themeManager.themeMode == ThemeMode.dark
            ? Colors.black
            : Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark_rounded),
            label: 'Flashcards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt_rounded),
            label: 'Quizzes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Progress',
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsTab(StudyService studyService) {
    final filteredMaterials = _selectedSubject == 'All'
        ? studyService.allStudyMaterials
        : studyService.getBySubject(_selectedSubject);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 100,
          pinned: true,
          backgroundColor: const Color(0xFF2196F3),
          flexibleSpace: const FlexibleSpaceBar(
            title: Text(
              'Smart Study App',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              ),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Study Materials',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: ['All', ...studyService.getSubjects()].map((
                      subject,
                    ) {
                      final isSelected = _selectedSubject == subject;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSubject = subject),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF2196F3)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              subject,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.6,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  _buildStudyMaterialCard(filteredMaterials[index]),
              childCount: filteredMaterials.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudyMaterialCard(StudyMaterial material) {
    return GestureDetector(
      onTap: () =>
          _navigateTo(StudyMaterialDetailPage(materialId: material.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF2196F3), const Color(0xFF1565C0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Decorative icon
                    Center(
                      child: Icon(
                        Icons.auto_stories_rounded,
                        size: 50,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    // Bookmark button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Consumer<StudyService>(
                        builder: (context, service, _) => GestureDetector(
                          onTap: () => service.toggleBookmark(material.id),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                            child: Icon(
                              material.isBookmarked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            material.title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: material.progressPercentage / 100,
            minHeight: 6,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation(Color(0xFF2196F3)),
          ),
          const SizedBox(height: 4),
          Text(
            '${material.progressPercentage.toStringAsFixed(0)}% completed',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.school, color: Color(0xFF2196F3), size: 14),
              Text(
                ' ${material.difficulty}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  material.subject,
                  style: const TextStyle(
                    color: Color(0xFF2196F3),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcardsTab(StudyService studyService) {
    final materials = studyService.allStudyMaterials;
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          backgroundColor: Color(0xFF2196F3),
          title: Text(
            'Flashcards',
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ),
        if (materials.isEmpty)
          const SliverFillRemaining(
            child: Center(child: Text('No study materials available')),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final material = materials[index];
                return GestureDetector(
                  onTap: () =>
                      _navigateTo(FlashcardStudyPage(material: material)),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey[50]!],
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(
                              0xFF2196F3,
                            ).withValues(alpha: 0.1),
                          ),
                          child: const Icon(
                            Icons.collections_bookmark,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                        title: Text(
                          material.title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text('${material.totalTopics} topics'),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              }, childCount: materials.length),
            ),
          ),
      ],
    );
  }

  Widget _buildQuizzesTab(StudyService studyService) {
    final materials = studyService.allStudyMaterials;
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          backgroundColor: Color(0xFF2196F3),
          title: Text(
            'Quizzes',
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ),
        if (materials.isEmpty)
          const SliverFillRemaining(
            child: Center(child: Text('No quizzes available')),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final material = materials[index];
                return GestureDetector(
                  onTap: () => _navigateTo(QuizPage(material: material)),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey[50]!],
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(
                              0xFF2196F3,
                            ).withValues(alpha: 0.1),
                          ),
                          child: const Icon(
                            Icons.quiz,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                        title: Text(
                          material.title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(material.subject),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              }, childCount: materials.length),
            ),
          ),
      ],
    );
  }

  Widget _buildProgressTab(User? user, StudyService studyService) {
    final materials = studyService.allStudyMaterials;
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          backgroundColor: Color(0xFF2196F3),
          title: Text(
            'Progress',
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF2196F3),
                            const Color(0xFF1565C0),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF2196F3,
                            ).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.school_rounded,
                              size: 50,
                              color: Color(0xFF2196F3),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user?.email ?? 'Student',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatBox('${materials.length}', 'Materials'),
                              _buildStatBox(
                                '${studyService.bookmarked.length}',
                                'Bookmarked',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final navigator = Navigator.of(context);
                                await FirebaseAuth.instance.signOut();
                                if (mounted) {
                                  navigator.popUntil((route) => route.isFirst);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF2196F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              icon: const Icon(Icons.logout),
                              label: const Text(
                                'Sign Out',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Your Learning Progress',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              } else {
                final material = materials[index - 1];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey[50]!],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(
                                0xFF2196F3,
                              ).withValues(alpha: 0.1),
                            ),
                            child: Center(
                              child: Text(
                                '${(index - 1) + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xFF2196F3),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  material.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: material.progressPercentage / 100,
                                    minHeight: 6,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: const AlwaysStoppedAnimation(
                                      Color(0xFF2196F3),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${material.progressPercentage.toStringAsFixed(1)}% complete',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }, childCount: materials.length + 1),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
