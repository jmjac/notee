import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:notee/SettingsPage.dart';
import 'package:notee/NoteDetailsPage.dart';
import 'package:notee/AddNotePage.dart';

import 'dart:async';
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
  static var x = Note("Todo: Finish this app", "TODO");
  static var y = Note(
      "Go for a walk with my friends. I'm not really sure what to do but I would like to try ou this new app!, Go for a walk with my friends. I'm not really sure what to do but I would like to try ou this new app!, Go for a walk with my friends. I'm not really sure what to do but I would like to try ou this new app!, Go for a walk with my friends. I'm not really sure what to do but I would like to try ou this new app!",
      "Plans for tomorrow"); //For development UI testing
  static List<Note> notes = [x, y];

  Widget _buildNotes() {
    return ListView.builder(
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(notes[index].id.toString()),
            confirmDismiss: (DismissDirection dismissDirection) {
              return _confirmDelete();
            },
            onDismissed: (DismissDirection dismissDirection) {
              setState(() {
                notes.removeAt(index);
              });
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("Note deleted")));
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
                        builder: (context) => NoteDetails(note: notes[index])),
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
            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));},
          )
        ],
      ),
      body: Center(child: _buildNotes()),
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


