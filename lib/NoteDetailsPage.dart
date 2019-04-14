import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Note.dart';


class NoteDetails extends StatelessWidget {
  // Details of each note. Appears after onTap from ListView.builder from _buildNotes()

  final Note note;

  NoteDetails({Key key, @required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          note.title,
          style: TextStyle(color: Colors.pink),
        ),
      ),
      body: SingleChildScrollView(child: Text(note.description)),
    );
  }
}
