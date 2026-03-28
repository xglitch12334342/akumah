import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/study_service.dart';
import '../models/study_material.dart';
import 'study_material_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  List<StudyMaterial> _searchResults = [];

  void _navigateTo(Widget page) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    final studyService = Provider.of<StudyService>(context, listen: false);
    _searchResults = studyService.allStudyMaterials;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    final studyService = Provider.of<StudyService>(context, listen: false);
    setState(() {
      if (query.isEmpty) {
        _searchResults = studyService.allStudyMaterials;
      } else {
        _searchResults = studyService.allStudyMaterials
            .where(
              (material) =>
                  material.title.toLowerCase().contains(query.toLowerCase()) ||
                  material.subject.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  material.description.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Study Materials',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: 'Search by title, subject, or description...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF2196F3)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                        child: const Icon(
                          Icons.clear,
                          color: Color(0xFF2196F3),
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2196F3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF2196F3),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60,
                          color: Colors.grey.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No materials found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final material = _searchResults[index];
                      return GestureDetector(
                        onTap: () {
                          _navigateTo(
                            StudyMaterialDetailPage(materialId: material.id),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF2196F3),
                                      const Color(0xFF1565C0),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Icon(
                                  Icons.auto_stories_rounded,
                                  size: 50,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        material.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        material.subject,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xFF2196F3,
                                              ).withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              material.difficulty,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Color(0xFF2196F3),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.book,
                                            size: 14,
                                            color: Color(0xFF2196F3),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${material.totalTopics} topics',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
