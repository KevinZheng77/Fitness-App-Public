import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Signup_Page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  
  Future signIn() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email_controller.text.trim(), password: password_controller.text.trim()
    );
  }
  //disposes controllers which helps with memory management
  void dispose(){
    email_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( 
        child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .33,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'img/FitnessLogo.png'
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
                  'Welcome',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700)
                ),
                Text(
                  'Sign into your account',
                  style: TextStyle(fontSize: 20, color: Colors.grey[500], fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
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
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email_rounded, color: Colors.lightBlueAccent),
                      border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(30)
                      )
                    )
                  ),
                ),
                SizedBox(height: 20),
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
                    obscureText: true,
                    controller: password_controller,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock ,color: Colors.lightBlueAccent),
                      border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(30)
                      )
                    )
                  ),
                ),
                SizedBox(height:20),
                Text(
                  'Forgot your password?',
                  style: TextStyle(fontSize: 15, color: Colors.grey[500], fontWeight: FontWeight.bold),
                ),
              ]
            ),
          ),
          SizedBox(height: 20),
          GestureDetector( 
            onTap: signIn,
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
              'Sign In',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.white)
              )
            ),
          )
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .03,),
          InkWell(
            child: RichText(
              text: TextSpan(
                text: 'Create Account',
                style: TextStyle(color: Colors.grey[500], fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupPage()))
          )
        ]
      ),
      )
    );
  }
}