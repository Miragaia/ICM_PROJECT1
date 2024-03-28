import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'map_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firestore Test'),
        ),
        body: FirestoreTest(),
      ),
    );
  }
}

class FirestoreTest extends StatefulWidget {
  @override
  _FirestoreTestState createState() => _FirestoreTestState();
}

class _FirestoreTestState extends State<FirestoreTest> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              _addUser();
            },
            child: Text('Add User'),
          ),
          ElevatedButton(
            onPressed: () {
              _getUser();
            },
            child: Text('Get User'),
          ),
        ],
      ),
    );
  }

  Future<void> _addUser() async {
    try {
      await usersCollection.add({
        'name': 'John Doe',
        'age': 30,
      });
      print('User added successfully!');
    } catch (e) {
      print('Failed to add user: $e');
    }
  }

  Future<void> _getUser() async {
    try {
      QuerySnapshot querySnapshot = await usersCollection.get();
      querySnapshot.docs.forEach((doc) {
        print('User: ${doc.id}, ${doc['name']}, ${doc['age']}');
      });
    } catch (e) {
      print('Failed to get user: $e');
    }
  }
}
