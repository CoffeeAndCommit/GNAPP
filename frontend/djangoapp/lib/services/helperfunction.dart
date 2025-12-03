
import 'dart:convert';
import 'package:http/http.dart' as http;

const publicUrl = 'https://gnapp.onrender.com/notes/';

Future<List<dynamic>> getNotes() async {
  final url = Uri.parse('https://gnapp.onrender.com/notes/');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to load notes");
  }
}
Future<Map<String, dynamic>> getNote(int id) async {
  final url = Uri.parse('https://gnapp.onrender.com/notes/$id/');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to load note");
  }
}


Future<bool> createNote(String body) async {
  final url = Uri.parse('https://gnapp.onrender.com/notes/create/');

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"body": body}),
  );

  return response.statusCode == 200 || response.statusCode == 201;
}
Future<bool> updateNote(int id, String body) async {
  final url = Uri.parse('https://gnapp.onrender.com/notes/$id/update/');

  final response = await http.put(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"body": body}),
  );

  return response.statusCode == 200;
}
Future<bool> deleteNote(int id) async {
  final url = Uri.parse('https://gnapp.onrender.com/notes/$id/delete/');

  final response = await http.delete(url);

  return response.statusCode == 200;
}
