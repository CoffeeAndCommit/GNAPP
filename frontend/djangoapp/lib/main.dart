import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controller/notes_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
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
  final NotesController controller = NotesController();

  @override
  void initState() {
    super.initState();
    controller.loadNotes().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNoteBottomSheet(
            context: context,
            onSubmit: (text) async {
              await controller.add(text);
              setState(() {});
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: controller.notes.length,
                itemBuilder: (context, index) {
                  final note = controller.notes[index];

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
                      title: Text(
                        note.body,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.4, // better line spacing
                          letterSpacing: 0.3, // modern feel
                          color: Colors.black87,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () {
                                showNoteBottomSheet(
                                  context: context,
                                  initialText: note.body,
                                  onSubmit: (text) async {
                                    await controller.update(
                                      note.id,
                                      text,
                                    );
                                    setState(() {});
                                  },
                                );
                              }),
                          IconButton(
                              icon: Icon(Icons.delete, color: Colors.red[900]),
                              onPressed: () async {
                                await controller.delete(note.id);
                                setState(() {});
                              }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

void showNoteBottomSheet({
  required BuildContext context,
  String? initialText,
  required Function(String) onSubmit,
}) {
  final TextEditingController controller =
      TextEditingController(text: initialText);

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                maxLines: null, // allows unlimited lines
                minLines: 3, // starts as a paragraph box
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Note',
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Colors.grey.shade100,

                  // Inner padding
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),

                  // Outline border
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  // When not focused
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.0,
                    ),
                  ),

                  // When focused
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                      width: 2.0,
                    ),
                  ),

                  // Shadow around the field
                  // Use decoration on a container wrapper if more shadow is needed
                ),
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4, // line height for paragraph feel
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                onSubmit(controller.text);
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      );
    },
  );
}
