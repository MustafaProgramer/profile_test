import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';



class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      var contents = await file.readAsString();

      
     // contents.replaceFirst("[", "");
      print(contents);
      return contents;
    } catch (e) {
     print("file Not found");
      return " ";
    }
  }

  Future<File> writeCounter(counter) async {
    final file = await _localFile;

    // Write the file
    print(counter.length);
    file.openWrite();
    for(int i=0; i < counter.length; i++)
    {
      file.writeAsString(counter[i].toString());
    }
    
    return file;
  }
}

class FlutterDemo extends StatefulWidget {
  final CounterStorage storage;

  FlutterDemo({Key key, @required this.storage}) : super(key: key);

  @override
  _FlutterDemoState createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  var _counter;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((value) {
      setState(() {
        
        _counter =value.split(" ").toList();
        print(_counter.length);
        print(_counter[0]);
      });
    });
  }

  Future<File> _incrementCounter() async {
    setState(() {
        _counter.add("Sitra");
       
       
      print(_counter);
    });

    // write the variable as a string to the file
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reading and Writing Files')),
      body: Center(
        child: Text(
          'Button tapped $_counter time${_counter == 1 ? '' : 's'}.',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}