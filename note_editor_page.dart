import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'note_model.dart';


class NoteEditScreen extends StatefulWidget {
  final Note? note;

  const NoteEditScreen({super.key, this.note});

  @override
  NoteEditScreenState createState() => NoteEditScreenState();
}

class NoteEditScreenState extends State<NoteEditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  Future<void> _saveNote() async {
    final title = _titleController.text;
    final content = _contentController.text;
    final lastEdited = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    if (title.isNotEmpty && content.isNotEmpty) {
      if (widget.note == null) {
        // Adding a new note
        await DatabaseHelper.instance.addNote(
          Note(
            title: title,
            content: content,
            lastEdited: lastEdited,
          ),
        );
      } else {
        // Editing an existing note
        await DatabaseHelper.instance.updateNote(
          Note(
            id: widget.note!.id,
            title: title,
            content: content,
            lastEdited: lastEdited,
          ),
        );
      }
      Navigator.pop(context, true); // Pop with success status
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Notes go here',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}