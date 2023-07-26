import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodayWorkout extends StatefulWidget {
  @override
  final String dayOfWeek;
  const TodayWorkout({super.key, required this.dayOfWeek});
  _TodayWorkoutState createState() => _TodayWorkoutState();
}

class _TodayWorkoutState extends State<TodayWorkout> {
  late final String dayWeek;
  List<String> listExercises = []; // list of exercises for that day
  Map<String, String> setsInfo = {};
  Map<String, String> repsInfo = {};
  //initializes state
   void initState() {
    super.initState();
    dayWeek = widget.dayOfWeek;
    fetchIds();
  }

  void fetchIds() async {
    listExercises = [];
    final DocumentReference workoutDocument = FirebaseFirestore.instance.collection('Pre-made Workouts').doc(dayWeek);
    final CollectionReference collectionRef = workoutDocument.collection('Exercises');
    QuerySnapshot snapshot = await collectionRef.get();
    snapshot.docs.forEach((document) {
      listExercises.add(document.id);
      setsInfo[document.id] = document['Sets'];
      repsInfo[document.id] = document['Reps'];
    });
    setState(() {});
  }

  // returns the number of workouts created so it can be displayed in Listview
  Future numberOfExercises() async{
    final DocumentReference workoutDocument = FirebaseFirestore.instance.collection('Pre-made Workouts').doc(dayWeek);
    final CollectionReference exercises = workoutDocument.collection('Exercises');
    QuerySnapshot querySnapshot = await exercises.get();
    int numberExercises = querySnapshot.size;
    return numberExercises;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today\'s Workout', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder( //future builder used so it can read database information
        future: numberOfExercises(),
        builder: (context, snapshot){
          if(snapshot.hasData){ 
            print(snapshot.data);
            print(listExercises);
            print(repsInfo);
            print(setsInfo);
            return Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
              child: ListView.builder(
              itemCount: snapshot.data,
              itemBuilder: (context, snapshot) => 
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height *.03),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff1c8eff),
                          Color(0xff87cefa),
                          //Color(0xff0071c5),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    borderRadius: BorderRadius.circular(20),
                    //color: Colors.white,
                    boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  ),
                  height: MediaQuery.of(context).size.height * .10, 
                  child: ListTile(
                  title: Text(listExercises[snapshot], style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20)),
                  subtitle: 
                    Row(
                      children: [
                       Text(
                            'Sets: '+ (setsInfo[listExercises[snapshot]]?? 'No sets'),
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                        ),
                        Text('   '),
                        Text(
                            'Reps: ' + (repsInfo[listExercises[snapshot]] ?? 'No reps'),
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                          ),
                        
                      ]
                    ),
                  )
                )
                ) 
              )
            );
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
        }
        )
      );
  }
}