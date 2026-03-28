import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';
import '../models/study_material.dart';

class NotesPage extends StatefulWidget {
  final StudyMaterial material;

  const NotesPage({required this.material, super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<StudyNote> notes;
  final colors = ['#FF6B6B', '#4ECDC4', '#FFE66D', '#A8E6CF', '#FFD3B6'];

  @override
  void initState() {
    super.initState();
    notes = _generateSampleNotes();
  }

  List<StudyNote> _generateSampleNotes() {
    return [
      StudyNote(
        id: '1',
        studyMaterialId: widget.material.id,
        title: 'Important Concepts',
        content:
            'Remember to focus on the main concepts that appear frequently in exams.',
        color: colors[0],
        tags: ['important', 'review'],
        createdDate: DateTime.now().subtract(const Duration(days: 2)),
        lastModifiedDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  void _addNote() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedColor = colors[0];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Note Content',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                StatefulBuilder(
                  builder: (context, setState) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Color:'),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: colors.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() => selectedColor = colors[index]);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: Color(
                                    int.parse(
                                      colors[index].replaceFirst('#', '0xff'),
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: selectedColor == colors[index]
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  contentController.text.isNotEmpty) {
                setState(() {
                  notes.add(
                    StudyNote(
                      id: const Uuid().v4(),
                      studyMaterialId: widget.material.id,
                      title: titleController.text,
                      content: contentController.text,
                      color: selectedColor,
                      tags: [],
                      createdDate: DateTime.now(),
                      lastModifiedDate: DateTime.now(),
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editNote(int index) {
    final note = notes[index];
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);
    String selectedColor = note.color ?? colors[0];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Note'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Note Content',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                StatefulBuilder(
                  builder: (context, setState) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Color:'),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: colors.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() => selectedColor = colors[index]);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: Color(
                                    int.parse(
                                      colors[index].replaceFirst('#', '0xff'),
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: selectedColor == colors[index]
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                notes[index] = StudyNote(
                  id: note.id,
                  studyMaterialId: note.studyMaterialId,
                  title: titleController.text,
                  content: contentController.text,
                  color: selectedColor,
                  tags: note.tags,
                  createdDate: note.createdDate,
                  lastModifiedDate: DateTime.now(),
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteNote(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => notes.removeAt(index));
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.material.title} - Notes'),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
      ),
      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_outlined, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'No notes yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add your first note to get started',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final cardColor = Color(
                  int.parse(
                    (note.color ?? colors[0]).replaceFirst('#', '0xff'),
                  ),
                );

                return GestureDetector(
                  onLongPress: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.edit),
                            title: const Text('Edit'),
                            onTap: () {
                              Navigator.pop(context);
                              _editNote(index);
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            title: const Text('Delete'),
                            onTap: () {
                              Navigator.pop(context);
                              _deleteNote(index);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: cardColor.withValues(alpha: 0.1),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: cardColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    note.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              note.content,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (note.tags.isNotEmpty)
                                  SizedBox(
                                    height: 24,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      children: note.tags
                                          .map(
                                            (tag) => Container(
                                              margin: const EdgeInsets.only(
                                                right: 6,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: cardColor.withValues(
                                                  alpha: 0.2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                tag,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: cardColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  )
                                else
                                  const SizedBox(),
                                Text(
                                  _formatDate(note.lastModifiedDate),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        backgroundColor: const Color(0xFF2196F3),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
