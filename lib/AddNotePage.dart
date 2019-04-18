import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Note.dart';
import 'DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';



class AddNotePage extends StatefulWidget {
  final List<Note> notes;

  AddNotePage({Key key, @required this.notes}) : super(key: key);

  @override
  _AddNotePageState createState() => _AddNotePageState(notes: notes);
}

class _AddNotePageState extends State<AddNotePage> {
  // Class for adding new notes to the notepad
  //TODO: Save data, and transfer it between stages
  final List<Note> notes;
  _AddNotePageState({Key key, @required this.notes});

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add a new note"),
      ),
      body: Center(
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(children: [
                Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: TextField(
                        controller: titleController,
                        decoration: InputDecoration(hintText: "Title"),
                        maxLength: 72)),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      hintText: "Description", border: InputBorder.none),
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                )
              ]))),
      floatingActionButton: FlatButton(
        child: Text("Submit", style: TextStyle(color: Colors.pink)),
        onPressed: () {
          saveNote(descriptionController.text, titleController.text, notes);
          Navigator.popUntil(
              context, ModalRoute.withName('/')); //Return to HomePage
        },
      ),
    );
  }
}



saveNote(String description, String title, notes) async{
  // saving new note to database
  Database db = await DatabaseHelper.instance.database;
  Map<String, dynamic> row = {
    DatabaseHelper.columnDescription : description,
    DatabaseHelper.columnTitle : title,
    DatabaseHelper.columnDate : DateTime.now().toString()
  };

  int id = await db.insert(DatabaseHelper.table, row);

 notes.add(Note(description, title, id));
}