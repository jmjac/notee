import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'package:notee/SettingsPage.dart';
import 'package:notee/NoteDetailsPage.dart';
import 'package:notee/AddNotePage.dart';
import 'package:notee/DatabaseHelper.dart';
import 'Note.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.pink,
          brightness: Brightness.dark),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];

  Widget _buildNotes() {
    return ListView.builder(
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(notes[index].id.toString()),
            confirmDismiss: (DismissDirection dismissDirection) {
              return _confirmDelete();
            },
            onDismissed: (DismissDirection dismissDirection) {
              deleteNote(notes[index].id);
              setState(() {
                notes.removeAt(index);
              });
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("Note deleted"),duration: Duration(seconds: 1)));
            },
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Column(children: [
                  Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        notes[index].title.toString(),
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.pink),
                      )),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(notes[index].description.toString(),
                          maxLines: 3)),
                  Divider(height: 0.0)
                ]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NoteDetailsPage(note: notes[index])),
                  );
                }),
            background: Container(
                alignment: AlignmentDirectional.centerEnd,
                color: Colors.red,
                child: Padding(
                    padding: EdgeInsets.all(8.0), child: Icon(Icons.delete))),
          );
        },
        itemCount: notes.length);
  }

  Future<bool> _confirmDelete() {
    // Confirm dialog used in _buildNotes confirmDismiss
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Delete?'),
              content: const Text('Do you want to delete this note?'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: const Text('ACCEPT'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text("Notee"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            //TODO: Add custom animation
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          )
        ],
      ),
      body: Center(
          child: FutureBuilder(
              future: getNotes(notes),
              builder: (context, snapshot) {
                if (notes.isEmpty) {
                  // Prevents UI changing to "Loading" when notes are already loaded.
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text("Loading");
                    case ConnectionState.active:
                      return Text("Loading");
                    default:
                      if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      } else {
                        return _buildNotes();
                      }
                  }
                } else {
                  return _buildNotes();
                }
              })),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 10,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNotePage(notes: notes)));
        },
      ),
    );
  }
}

getNotes(List<Note> notes) async {
  notes = [];
  Database db = await DatabaseHelper.instance.database;
  for (var row in await db.query(DatabaseHelper.table)) {
    notes.add(Note.fromDatabase(row));
  }
}

deleteNote(int id) async {
  Database db = await DatabaseHelper.instance.database;
  db.delete(DatabaseHelper.table,
      where: "${DatabaseHelper.columnId} = ?", whereArgs: [id]);
}
