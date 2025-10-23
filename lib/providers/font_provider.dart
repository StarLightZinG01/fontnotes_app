import 'package:flutter/foundation.dart';
import '../helpers/database_helper.dart';
import '../models/font_note.dart';

class FontProvider extends ChangeNotifier {
  final db = DatabaseHelper.instance;
  List<FontNote> _notes = [];

  List<FontNote> get notes => _notes;

  Future<void> loadNotes() async {
    _notes = await db.getAllNotes();
    notifyListeners();
  }

  Future<void> addNote(String name, String usage, String? tags) async {
    final newNote = FontNote(
      name: name,
      usage: usage,
      tags: tags,
      date: DateTime.now().toString().split(' ')[0],
    );
    await db.insert(newNote);
    await loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await db.delete(id);
    await loadNotes();
  }

  Future<void> updateNote(
    int id,
    String name,
    String usage,
    String? tags,
  ) async {
    final updatedNote = FontNote(
      id: id,
      name: name,
      usage: usage,
      tags: tags,
      date: DateTime.now().toString().split(' ')[0],
    );
    await db.update(updatedNote);
    await loadNotes();
  }

  Future<void> toggleFavorite(FontNote note) async {
    final updatedNote = FontNote(
      id: note.id,
      name: note.name,
      usage: note.usage,
      tags: note.tags,
      date: note.date,
      isFavorite: !note.isFavorite,
    );
    await db.update(updatedNote);
    await loadNotes();
  }
}
