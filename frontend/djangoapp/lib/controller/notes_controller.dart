

import '../models/notes.dart';
import '../services/notes_services.dart';

class NotesController {
  final NotesService _service = NotesService();

  List<Note> notes = [];
  bool isLoading = true;

  Future<void> loadNotes() async {
    isLoading = true;
    notes = await _service.fetchNotes();
    isLoading = false;
  }

  Future<void> add(String text) async {
    await _service.addNote(text);
    await loadNotes();
  }

  Future<void> update(int id, String text) async {
    await _service.updateNote(id, text);
    await loadNotes();
  }

  Future<void> delete(int id) async {
    await _service.deleteNote(id);
    await loadNotes();
  }
}
