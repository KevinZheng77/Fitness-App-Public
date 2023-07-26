import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImportLoginInfo{
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  ImportLoginInfo({this.uid});
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('user');
  Future setInfo(String firstName, String lastName, String email) async{
    return await userCollection.doc(uid).set({'First Name': firstName, 'Last Name': lastName, 'Email': email});
  }
}