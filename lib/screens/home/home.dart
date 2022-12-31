// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, duplicate_import, deprecated_member_use, prefer_collection_literals

import 'dart:math';
import 'dart:io';
import 'package:brew_crew/screens/authenticate/sign_in.dart';
import 'package:brew_crew/screens/home/setting_form.dart';
import 'package:brew_crew/screens/new_books.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/services/database.dart';
import 'package:provider/provider.dart';
import 'package:brew_crew/models/book.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:brew_crew/models/books.dart';
import 'package:brew_crew/consttants.dart';
import 'package:brew_crew/widgets/book_rating.dart';
import 'package:brew_crew/widgets/reading_card_list.dart';
import 'package:brew_crew/widgets/two_side_rounded_button.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  String url = "";
  int number;

  uploadDataToFirebase() async{
    // generate random number
    number = Random().nextInt(10);
    // pick a pdf file
    FilePickerResult result = await FilePicker.platform.pickFiles();
    File pick = File(result.files.single.path.toString());
    var file = pick.readAsBytesSync();
    String name = DateTime.now().millisecondsSinceEpoch.toString();
    // uploading file to firebase
    var pdfFile = FirebaseStorage.instance.ref().child(name).child("/.pdf");
    UploadTask task = pdfFile.putData(file);
    TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();
    // upload url to cloud firebase
    await FirebaseFirestore.instance.collection("file").doc().set({
      'fileUrl': url,
      'num': "Book#"+number.toString()
    });
  }
  Books book = new Books();
  final AuthService _auth = AuthService();
  List<Book> books;
  Book searchBook;
  bool found = false;
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }

    books = book.books;
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Heyy Readers!'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                  (route) => false);
            },
          ),
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("Uploaded Books"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> NewBooks()),  
              );
            },
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/front.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: size.height * .1),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 280,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: TextField(
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.left,
                              controller: myController,
                              // onChanged: (value){
                              //   setState(() {
                              //     myController.text = value;
                              //   });

                              // },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Search Books',
                                hintText: 'Enter Book Name',
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                found = false;
                              });
                              books.forEach((element) {
                                if (element.title == myController.text) {
                                  setState(() {
                                    searchBook = element;
                                    found = true;
                                  });
                                }
                              });
                            },
                            // ignore: sized_box_for_whitespace
                            child: Container(
                              width: 50,
                              height: 50,
                              child: Icon(Icons.search),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headline4,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          TextSpan(text: "What are you \nreading "),
                          TextSpan(
                              text: "today?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: found
                          ? [
                              ReadingListCard(
                                book: searchBook,
                              )
                            ]
                          : books
                              .map((element) => ReadingListCard(
                                    book: element,
                                  ))
                              .toList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.headline4,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              TextSpan(text: "Best of the "),
                              TextSpan(
                                text: "day",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        bestOfTheDayCard(size, context),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 24),
                  //   child:StreamBuilder(
                  //     stream: FirebaseFirestore.instance.collection("file").snapshots(),
                  //     builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                  //       if(snapshot.hasData) {
                  //         return ListView.builder(
                  //           itemCount: snapshot.data.docs.length,
                  //           itemBuilder: (context,i){
                  //           QueryDocumentSnapshot x = snapshot.data.docs[i];
                  //           return InkWell(
                  //             onTap: (){
                  //               Navigator.push(context, MaterialPageRoute(builder: (context)=>View(url: x["fileUrl"])));
                  //             },
                  //             child: Container(
                  //               margin: EdgeInsets.symmetric(vertical: 10),
                  //               child: Text(x["fileurl"]),
                  //             ),
                  //           );
                  //         });
                  //       }
                  //       return Center(child: CircularProgressIndicator(),);
                  //     }
                  //     )
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: uploadDataToFirebase, child:Icon(Icons.add)),
    ));
  }
  // Container NewBooks(Size size, BuildContext context) {
  //   return Container(child:
  //     StreamBuilder(
  //       stream: FirebaseFirestore.instance.collection("file").snapshots(),
  //       builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
  //         if(snapshot.hasData) {
  //           return ListView.builder(
  //             itemCount: snapshot.data.docs.length,
  //             itemBuilder: (context,i){
  //             QueryDocumentSnapshot x = snapshot.data.docs[i];
  //             return InkWell(
  //             onTap: (){
  //               Navigator.push(context, MaterialPageRoute(builder: (context)=>View(url: x["fileUrl"])));
  //             },
  //             child: Container(
  //               margin: EdgeInsets.symmetric(vertical: 10),
  //               child: Text(x["fileurl"]),
  //             ),
  //           );
  //           });
  //         }
  //         return Center(child: CircularProgressIndicator(),);
  //       }
  //       )
  //   );
  // }

  Container bestOfTheDayCard(Size size, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      height: 245,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 24,
                top: 24,
                right: size.width * .35,
              ),
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFEAEAEA).withOpacity(.45),
                borderRadius: BorderRadius.circular(29),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      "New York Time Best seller",
                      style: TextStyle(
                        fontSize: 11,
                        color: kLightBlackColor,
                      ),
                    ),
                  ),
                  Text(
                    "One Of Us Is Next",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    "Karen McManus",
                    style: TextStyle(color: kLightBlackColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10.0),
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: BookRating(score: 3.5),
                        ),
                        Expanded(
                          child: Text(
                            "It is the sequel to the international bestseller One of Us is lying ",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: kLightBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Image.asset(
              "assets/images/book-3.jpg",
              width: size.width * .37,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              height: 40,
              width: size.width * .3,
              child: TwoSideRoundedButton(
                text: "Buy",
                radious: 24,
                press: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

