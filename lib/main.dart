import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_13/disp_data.dart';
import 'package:flutter_application_13/update_data.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();

  void AddData(String name, String email) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    DocumentReference docRef = await usersCollection.add({
      'name': name,
      'email': email,
    });
    if (docRef.id != null) {
      // Data added successfully
      print('Data submitted to Firestore with document ID: ${docRef.id}');
    } else {
      // Failed to add data
      print('Failed to submit data to Firestore');
    }
  }

  void fetchData() async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    QuerySnapshot querySnapshot = await usersCollection.get();

    if (querySnapshot.docs.isNotEmpty) {
      // Data retrieved successfully
      List<DocumentSnapshot> documents = querySnapshot.docs;
      for (var document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        // Access the fields of the document
        String name = data['name'];
        String email = data['email'];
      }
    } else {
      // No data found
      print('No data found in Firestore');
    }
  }

  void getDocumentId() async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    DocumentSnapshot documentSnapshot =
        await usersCollection.doc('your_document_id').get();

    if (documentSnapshot.exists) {
      String documentId = documentSnapshot.id;
      print('Document ID: $documentId');
    } else {
      print('Document not found');
    }
  }

  void getDocumentId1() async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    QuerySnapshot querySnapshot =
        await usersCollection.where('name', isEqualTo: 'A').limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      String documentId = querySnapshot.docs[0].id;
      print('Document ID: $documentId');
    } else {
      print('Document not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Add data in firebase")),
        body: Form(
            child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: namecontroller,
                decoration: InputDecoration(
                    labelText: "name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: emailcontroller,
                decoration: InputDecoration(
                    labelText: "email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 1, 8, 0),
              child: ElevatedButton(
                  onPressed: () {
                    AddData(namecontroller.text, emailcontroller.text);
                    namecontroller.clear();
                    emailcontroller.clear();
                    fetchData();
                  },
                  child: Text("Submit")),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 1, 8, 0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => display_data()),
                    );
                  },
                  child: Text("Get data")),
            ),
          ],
        )));
  }
}
