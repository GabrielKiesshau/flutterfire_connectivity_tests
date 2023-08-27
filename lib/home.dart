import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  final db = FirebaseFirestore.instance;
  final _connectivity = Connectivity();

  void _incrementCounter() async {
    log('Trying to send data...');

    final data = <String, dynamic>{
      "text": "Hello World",
      "number": 42,
    };
    db.collection("my_collection").add(data)
      .then(
        (DocumentReference doc) => log('DocumentSnapshot added with ID: ${doc.id}'),
      )
      .catchError((error) => log('Failed: $error'));

    final dataB = <String, dynamic>{
      "text": "Hello World, I'm back again!",
      "number": 200,
    };
    db.collection("my_collection").doc('Fy4Zkt0PNPgnH6YuFZyO').update(dataB)
      .then((_) => log('DocumentSnapshot updated'))
      .catchError((error) => log('Failed: $error'));
    
    log('Sent...');

    setState(() {
      _counter++;
    });
  }

  void _enableFirebaseConnection() async {
    log('connection ok');
    await db.enableNetwork()
      .then((_) => log('enabled firebase network'));
  }
  void _disableFirebaseConnection() async {
    log('no connection');
    await db.disableNetwork()
      .then((_) => log('disabled firebase network'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: _connectivity.onConnectivityChanged,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final connectivityResult = snapshot.data;

        if (connectivityResult == ConnectivityResult.none) {
          _disableFirebaseConnection();
        }
        else {
          _enableFirebaseConnection();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        );
      }
    );
  }
}
