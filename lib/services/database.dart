import 'package:brew_crew/models/book.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection refrence
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String books, String name) async {
    return await brewCollection.doc(uid).set({
      'books': books,
      'name': name,
    });
  }

  // brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brew(books: doc.get('books') ?? '', name: doc.get('name') ?? '');
    }).toList();
  }

  // userData from snapshot
  UserData _UserDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(uid: uid, name: snapshot['name'], books: snapshot['books']);
  }

  // get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // get user stream
  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots().map(_UserDataFromSnapshot);
  }
}
