import 'package:flutter/material.dart';
import 'package:my_project_app/Create_Workout_Screen.dart';
import 'package:my_project_app/StopWatch.dart';
import 'package:my_project_app/Timer.dart';
import 'package:my_project_app/WorkoutOfDay.dart';
import 'package:quoter/quoter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class  HomePage extends StatefulWidget {
  @override
  HomePage_State createState() => HomePage_State();
}

class HomePage_State extends State<HomePage> {
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  final CollectionReference workoutDocument = FirebaseFirestore.instance.collection('Pre-made Workouts');
  String dayOfWeekString = DateFormat('EEEE').format(DateTime.now());

  // gets the User name back for displaying
  Future<String> getUserName()async{
    final DocumentReference userDoc = FirebaseFirestore.instance.collection('user').doc(uid);
    final DocumentSnapshot userSnapshot = await userDoc.get();
    final String firstName = userSnapshot.get('First Name');
    return firstName;
  }

  @override
  Widget build(BuildContext context) {
    Quoter quoter = Quoter();
    Quote randomQuote = quoter.getRandomQuote();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(top: 60, left: 25,right: 25),
        child: Column(  //one column
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Icon(Icons.align_horizontal_left_rounded)
                ),
                Container(
                  child: Icon(Icons.add_alert, size:20)
                )
              ],),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FutureBuilder(
                  future: getUserName(),
                  builder: (BuildContext context, snapshot){
                    if(snapshot.hasData){
                      return Text(
                        'Welcome, ${snapshot.data}!',
                        style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center
                      );
                    }else{
                      return Text('Welcome Back!',style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),textAlign: TextAlign.center);
                    }
                  }
                )
              ]
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Today's Workout",
                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)
                )
              ],
            ),
            SizedBox(height: 25),
            InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TodayWorkout(dayOfWeek: dayOfWeekString,)),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage("img/WorkoutOfDay.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: const EdgeInsets.only(left:10,top:10,right:20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${dayOfWeekString}',
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)
                      ),
                      Row(
                        children: [
                          Icon(Icons.timer, color: Colors.white,),
                          Text(
                            '60 min',
                            style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)
                            ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ],
                  ),
                )
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height * .12,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: 
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)), 
                      color: Colors.white,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFA9B9FE),
                          Color(0xFFD8C3FF),
                          Color(0xFFE4D6F1),
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      child:
                      Text(randomQuote.quotation + '\n - ' + randomQuote.quotee,
                        style: GoogleFonts.josefinSans(
                          fontStyle: FontStyle.italic, fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center),
                      )
                  )
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .03),
            Row(
              children: [
                InkWell(
                  onTap: () async {Navigator.push(context, MaterialPageRoute(builder: (context) => TimerScreen()));},
                  child: Container(
                    height: MediaQuery.of(context).size.height * .15,
                    width: MediaQuery.of(context).size.width * .4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFB4A7D6), 
                          Color(0xFFE8D7FF),
                          Color(0xFFCCE5FF),
                        ],
                        stops: [0.1, 0.5, 0.9],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 35),
                          Text('Timer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                          Icon(Icons.access_time, color: Colors.white,)
                        ],
                      )
                    )
                  )
                ),
                SizedBox(width: MediaQuery.of(context).size.width * .06),
                InkWell(
                  onTap: () async {Navigator.push(context, MaterialPageRoute(builder: (context) => StopWatch()));},
                  child: Container(
                    height: MediaQuery.of(context).size.height * .15,
                    width: MediaQuery.of(context).size.width * .4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFB4A7D6),
                          Color(0xFFE8D7FF), // light purple
                          Color(0xFFCCE5FF), // light blue
                        ],
                        stops: [0.1, 0.5, 0.9],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: 
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 35),
                          Text('Stop Watch', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                          Icon(Icons.av_timer_outlined, color: Colors.white,)
                        ]
                      )
                    )
                  )
                )
              ],
            )
          ]
        ),
      ),
    );
  }
}