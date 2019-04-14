import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//TODO: Settings for day/night mode and accent color

class SettingsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
    );
  }
}