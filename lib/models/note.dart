class StudyNote {
  final String id;
  final String studyMaterialId;
  final String title;
  final String content;
  final String? color; // For color-coded notes
  final List<String> tags;
  final DateTime createdDate;
  final DateTime lastModifiedDate;

  StudyNote({
    required this.id,
    required this.studyMaterialId,
    required this.title,
    required this.content,
    this.color,
    required this.tags,
    required this.createdDate,
    required this.lastModifiedDate,
  });
}
