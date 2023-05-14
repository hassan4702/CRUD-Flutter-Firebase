import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_13/del_data.dart';
import 'package:flutter_application_13/update_data.dart';

class display_data extends StatefulWidget {
  const display_data({super.key});

  @override
  State<display_data> createState() => _display_dataState();
}

class _display_dataState extends State<display_data> {
  late Stream<QuerySnapshot> dataStream;

  @override
  void initState() {
    super.initState();
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    dataStream = usersCollection.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Press to update'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: dataStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Text('No data found in Firestore');
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              List<DocumentSnapshot> reversedDocs =
                  List.from(snapshot.data!.docs.reversed);
              DocumentSnapshot document = reversedDocs[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String name = data['name'];
              String email = data['email'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdatePage(documentId: document.id),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(name),
                  subtitle: Text(email),
                  trailing: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                delete_data(documentId: document.id),
                          ),
                        );
                      },
                      child: Icon(Icons.highlight_remove_rounded)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
