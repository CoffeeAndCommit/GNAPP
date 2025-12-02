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
  List<Notes> notes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _retrieveNotes();
  }

  void _addNote() {
    // Logic to add a new note
  }
  _retrieveNotes() async {
    // Logic to retrieve notes from the server

    List<dynamic> data = await hf.getNotes();
    for (var note in data) {
      notes.add(Notes(id: note['id'], note: note['note']));
    }
  }

  void _updateNote() {
    // Logic to update an existing note
  }

  void _deleteNote() {
    // Logic to delete a note
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text(
            'Notes 1',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
