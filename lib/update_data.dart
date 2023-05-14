import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
  final String documentId;

  UpdatePage({required this.documentId});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  String newName = '';
  String newEmail = '';

  // Add methods for updating the data and handling form submission
  void updateData(String documentId) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    await usersCollection.doc(documentId).update({
      'name': newName, // Replace with the new name value
      'email': newEmail, // Replace with the new email value
    });

    print('Data updated successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Page'),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                newName = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                newEmail = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Call a method to update the data in Firestore
              updateData(widget.documentId);
              Navigator.pop(context);
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}
