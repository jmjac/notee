import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notee/NoteDetailsPage.dart';
import 'package:notee/Note.dart';


void main(){
  testWidgets("NoteDetailsPage test", (WidgetTester tester) async{
    await tester.pumpWidget(MaterialApp(home: NoteDetailsPage(note: Note("Description Test", "TitleTest", 1))));
    final titleFinder = find.text("TitleTest");
    final descriptionFinder = find.text("Description Test");
    final idFinder = find.text("1");

    expect(titleFinder, findsOneWidget);
    expect(descriptionFinder, findsOneWidget);
    expect(idFinder, findsNothing);
  });

  //TODO: Add test to AddNotePage and integration tests
}