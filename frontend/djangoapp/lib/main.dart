import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'notes.dart';
import 'helperfunction.dart' as hf;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Client client = Client();
  List<Note> notes = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _retrieveNotes().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    // print(notes.length);
  }

  _retrieveNotes() async {
    // Logic to retrieve notes from the server
    notes = [];

    List<dynamic> data = await hf.getNotes();
    print('Type of data: ${data.runtimeType}');
    for (var note in data) {
      notes.add(Note.fromJson(note));
    }
    setState(() {});
  }

  void _addNote({required String noteText}) {
    // Logic to add a new note
    // String noteText = _noteController.text;
    if (noteText.isNotEmpty) {
      hf.createNote(noteText).then(
            (value) => _retrieveNotes(),
          );
    }
  }

  void _updateNote({required int id, required String noteText}) {
    // Logic to update an existing note
    hf.updateNote(id, noteText).then(
          (value) => _retrieveNotes(),
        );
  }

  void _deleteNote({required int id}) {
    // Logic to delete a note
    hf.deleteNote(id).then(
          (value) => _retrieveNotes(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.deepPurple,
          title: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        title: Text(
                          note.body,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'Last updated: ${note.updated}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(padding: EdgeInsets.only(right: 8.0)),
                            IconButton(
                              onPressed: () {
                                _deleteNote(id: note.id);
                                _retrieveNotes();
                              },
                              icon: const Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Padding(padding: EdgeInsets.only(right: 8.0)),
                            IconButton(
                              onPressed: () {
                                bottomSheet(
                                    context: context,
                                    isUpdate: true,
                                    id: note.id,
                                    existingText: note.body);
                              },
                              icon: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            bottomSheet(context: context);
          },
          child: const Icon(Icons.add),
        ));
  }

  Future<dynamic> bottomSheet(
      {required BuildContext context,
      bool isUpdate = false,
      int? id,
      String? existingText}) {
    final TextEditingController noteController = TextEditingController();

    if (isUpdate && existingText != null) {
      noteController.text = existingText;
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // for keyboard handling
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              TextField(
                controller: noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Write your note',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    if (isUpdate && id != null) {
                      _updateNote(
                        id: id,
                        noteText: noteController.text ?? "",
                      );
                    } else if (!isUpdate) {
                      _addNote(
                        noteText: noteController.text ?? "",
                      );
                    }
                    noteController.clear();

                    Navigator.pop(context);
                  },
                  child: Text(
                    isUpdate ? 'Update Note' : 'Add Note',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
