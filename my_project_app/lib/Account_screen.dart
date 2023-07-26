import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreen_State createState() => _AccountScreen_State();
}

class _AccountScreen_State extends State<AccountScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () {
                 FirebaseAuth.instance.signOut();
                },
                color: Colors.black,
                child: Text('Sign Out', style: TextStyle(color: Colors.white),)
            )
            ],
          ),
        )
      );
  }
}