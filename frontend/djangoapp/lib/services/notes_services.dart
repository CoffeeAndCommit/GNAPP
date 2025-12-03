import '../models/notes.dart';
import 'helperfunction.dart' as hf;


class NotesService {
  Future<List<Note>> fetchNotes() async {
    final data = await hf.getNotes();
    return data.map((json) => Note.fromJson(json)).toList();
  }

  Future<void> addNote(String text) async {
    await hf.createNote(text);
  }

  Future<void> updateNote(int id, String text) async {
    await hf.updateNote(id, text);
  }

  Future<void> deleteNote(int id) async {
    await hf.deleteNote(id);
  }
}
