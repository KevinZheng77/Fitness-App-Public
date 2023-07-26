import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Login_Screen.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'importlogininfo.dart';
class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  final first_name_controller = TextEditingController();
  final last_name_controller = TextEditingController();
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  
  // disposes of memory 
  void dispose(){
    email_controller.dispose();
    password_controller.dispose();
    first_name_controller.dispose();
    last_name_controller.dispose();
    super.dispose();
  }
  // signs up the user 
  Future signUp() async{
    try{
      UserCredential new_user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email_controller.text.trim(), 
      password: password_controller.text.trim()
      );
      User? current_user = new_user.user;
      addUserDetails(first_name_controller.text.trim(), last_name_controller.text.trim(), email_controller.text.trim(), current_user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
    // adds user name and last name and email
  }

  // adds the user details
  Future addUserDetails(String firstName, String lastName, String email, User? user) async {
    await ImportLoginInfo(uid: user?.uid).setInfo(firstName, lastName, email);
    /*final CollectionReference workoutCollection = FirebaseFirestore.instance.collection('user');
    await workoutCollection.doc(uid).set({
      'firstName' : firstName,
      'lastName' : lastName,
      'email' : email,
    });*/
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .33,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'img/CreateAccount.png'
                ),
                fit: BoxFit.cover
              )
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * .9,
            child: Column(
              children: [
                Text(
                  'Create an Account',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .04),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(1,1),
                        color: Colors.grey.withOpacity(.5)
                      )
                    ]
                  ),
                  child: TextField(
                    controller: first_name_controller,
                    decoration: InputDecoration(
                      hintText: 'First Name.',
                      prefixIcon: Icon(Icons.face_retouching_natural_outlined, color: Colors.lightBlueAccent,),
                      border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(30)
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * .02, 
                        horizontal: MediaQuery.of(context).size.height * .02
                      )
                    )
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .02),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(1,1),
                        color: Colors.grey.withOpacity(.5)
                      )
                    ]
                  ),
                  child: TextField(
                    controller: last_name_controller,
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                      prefixIcon: Icon(Icons.face, color: Colors.lightBlueAccent,),
                      border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(30)
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * .02, 
                        horizontal: MediaQuery.of(context).size.height * .02
                      )
                    )
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .02),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(1,1),
                        color: Colors.grey.withOpacity(.5)
                      )
                    ]
                  ),
                  child: TextField(
                    controller: email_controller,
                    decoration: InputDecoration(
                      hintText: 'Valid Email',
                      prefixIcon: Icon(Icons.email, color: Colors.lightBlueAccent,),
                      border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(30)
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * .02, 
                        horizontal: MediaQuery.of(context).size.height * .02
                      )
                    )
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .02),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(1,1),
                        color: Colors.grey.withOpacity(.5)
                      )
                    ]
                  ),
                  child: TextField(
                    controller: password_controller,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.lightBlueAccent,),
                      border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(30)
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * .02, 
                        horizontal: MediaQuery.of(context).size.height * .02
                      )
                    )
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .02),
              ]
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .02),
          GestureDetector(
            onTap: signUp,
            child: Container(
            width: MediaQuery.of(context).size.width *.6,
            height: MediaQuery.of(context).size.height *.07,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: [
                  Color(0xff1c8eff),
                  Color(0xff87cefa),
                  //Color(0xff0071c5),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Text(
              'Sign Up',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.white)
              )
            ),
          ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .02),
          InkWell(
            child: RichText(
              text: TextSpan(
                text: 'Have an Account?',
                style: TextStyle(fontSize: 20, color: Colors.grey[500]),
            ),
            ),
            onTap: () => Navigator.of(context).pop()
          )
        ]
      ),
    );
  }
}