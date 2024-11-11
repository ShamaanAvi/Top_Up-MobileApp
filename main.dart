// main.dart
import 'package:flutter/material.dart';
import 'note_model.dart';
import 'database_helper.dart';
import 'note_editor_page.dart';

void main() {
  runApp(const MySimpleNoteApp());
}

class MySimpleNoteApp extends StatelessWidget {
  const MySimpleNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Simple Note',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
  List<Note> _notes = [];
  final List<int> _selectedNoteIds = [];
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    final notes = await DatabaseHelper.instance.fetchNotes();
    setState(() {
      _notes = notes;
    });
  }

  Future<void> _addOrEditNote([Note? note]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditScreen(note: note),
      ),
    );

    if (result == true) _fetchNotes(); // Refresh after saving
  }

  void _startDeleting() {
    if (_notes.isEmpty) {
      // Prevent entering selection mode if there are no notes
      setState(() {
        _isSelecting = false;
      });
      return;
    }

    setState(() {
      _isSelecting = true;
      _selectedNoteIds.clear(); // Clear previous selections
    });
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedNoteIds.contains(id)) {
        _selectedNoteIds.remove(id);
      } else {
        _selectedNoteIds.add(id);
      }
    });
  }

  Future<void> _deleteSelectedNotes() async {
    await DatabaseHelper.instance.deleteNotes(_selectedNoteIds);
    _selectedNoteIds.clear();
    setState(() {
      _isSelecting = false;
    });
    _fetchNotes();
  }

  void _cancelSelection() {
    setState(() {
      _isSelecting = false;
      _selectedNoteIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Simple Note'),
        actions: [
          if (_isSelecting)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _selectedNoteIds.isNotEmpty ? _deleteSelectedNotes : null,
            ),
          if (!_isSelecting && _notes.isNotEmpty) // Show delete icon only if there are notes
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _startDeleting,
            ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          if (_isSelecting) _cancelSelection(); // Dismiss selection mode
        },
        child: _notes.isEmpty
            ? const Center(child: Text('Start your first note'))
            : ListView.builder(
          itemCount: _notes.length,
          itemBuilder: (context, index) {
            final note = _notes[index];
            return ListTile(
              title: Text(note.title),
              subtitle: Text('Last edited: ${note.lastEdited}'),
              onTap: () => _isSelecting
                  ? _toggleSelection(note.id!)
                  : _addOrEditNote(note),
              onLongPress: _startDeleting,
              trailing: _isSelecting
                  ? Checkbox(
                value: _selectedNoteIds.contains(note.id),
                onChanged: (selected) => _toggleSelection(note.id!),
              )
                  : null,
            );
          },
        ),
      ),
      floatingActionButton: _isSelecting
          ? null
          : FloatingActionButton(
        onPressed: () => _addOrEditNote(),
        child: const Icon(Icons.add),
      ),
    );
  }
}