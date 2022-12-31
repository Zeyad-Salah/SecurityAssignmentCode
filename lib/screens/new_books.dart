import 'dart:io';
import 'dart:math';

import 'package:brew_crew/screens/View.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NewBooks extends StatefulWidget {
  const NewBooks({ Key key }) : super(key: key);

  @override
  _NewBooksState createState() => _NewBooksState();
}

class _NewBooksState extends State<NewBooks> {
  final AuthService _auth = AuthService();
  String url = "";
  int number;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("file").snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context,i){
              QueryDocumentSnapshot x = snapshot.data.docs[i];
              return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>View(url: x["fileUrl"])));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text(x["fileUrl"]),
              ),
            );
            });
          }
          return Center(child: CircularProgressIndicator(),);
        }
        ),
    );
  }
}