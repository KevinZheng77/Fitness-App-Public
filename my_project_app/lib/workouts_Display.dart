import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:my_project_app/main.dart';
import 'package:provider/provider.dart';
import './workout_items.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyWorkoutsPage extends StatefulWidget {
  @override
  final DocumentReference currentWorkoutDoc;
  const MyWorkoutsPage({super.key, required this.currentWorkoutDoc});
  _MyWorkoutsPageState createState() => _MyWorkoutsPageState();
}

class _MyWorkoutsPageState extends State<MyWorkoutsPage> {
  late final DocumentReference currWorkoutDoc;
  final newExerciseController = TextEditingController();
  final exerciseSetsController = TextEditingController();
  final exerciseRepsController = TextEditingController();
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  List<String> listExercises = [];
  Map<String, String> setsInfo = {};
  Map<String, String> repsInfo = {};

  //gets the list of exercises to print out
  void fetchExerciseIds() async {
    listExercises = [];
    CollectionReference workouts = getExerciseCollection();
    QuerySnapshot snapshot = await workouts.orderBy('createdAt', descending: false).get();
    snapshot.docs.forEach((document) {
      listExercises.add(document.id);
      setsInfo[document.id] = document['Sets'];
      repsInfo[document.id] = document['Reps'];
    });
    setState(() {});
  }
  // function for creating a new exercise
  void creatingNewExercise(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Enter Exercise',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30),
        ),
        content: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height *.2,
            child: Column(
            children: [
              TextField(
                controller: newExerciseController,
                decoration: InputDecoration(
                  hintText: 'Exercise',
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
              TextField(
                controller: exerciseSetsController,
                decoration: InputDecoration(
                  hintText: 'Sets',
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
              TextField(
                controller: exerciseRepsController,
                decoration: InputDecoration(
                  hintText: 'Reps',
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              )
            ]
          ),
        )
        ),
        actions: [
          //save button
          MaterialButton(
            onPressed: save,
            child: Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
          ),
          //cancel button
          MaterialButton(
            onPressed: cancel,
            child: Text('Cancel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          )  
        ],
      )
    );
  }

  //saves workout inputted
  void save(){
    String newWorkoutName = newExerciseController.text;
    //adds workout out to the workout data list 
    addExerciseDatabase();
    fetchExerciseIds(); //goes to database again and adds the workout to the screen 
    Navigator.pop(context); 
    clear();
  }

  // cancel button
  void cancel(){
    Navigator.pop(context);
    clear();
  }

  //clears text box 
  void clear(){
    newExerciseController.clear();
    exerciseRepsController.clear();
    exerciseSetsController.clear();
  }

  //adds workout to database
  Future addExerciseDatabase() async {
    final DocumentReference workoutDocument = FirebaseFirestore.instance.collection('user').doc(uid).collection('Workouts').doc(currWorkoutDoc.id);
    final CollectionReference exerciseCollection = workoutDocument.collection('Exercises');
    if(uid != null){
      final newID = await exerciseCollection.doc(newExerciseController.text).set({
        'Exercise': newExerciseController.text,
        'Sets': exerciseSetsController.text,
        'Reps': exerciseRepsController.text,
        'Completed': false,
        'createdAt': FieldValue.serverTimestamp()});
    }
    else{
      return "did not add exercise";
    }
  }

  // returns the number of workouts created so it can be displayed in Listview
  Future numberOfExercises() async{
    final CollectionReference exercises = currWorkoutDoc.collection('Exercises');
    QuerySnapshot querySnapshot = await exercises.get();
    int numberExercises = querySnapshot.size;
    return numberExercises;
  }

  // gets the collection Workout (Helper function)
  CollectionReference getExerciseCollection(){
    final CollectionReference exercises = FirebaseFirestore.instance.collection('user').doc(uid).collection('Workouts').doc(currWorkoutDoc.id).collection('Exercises');
    return exercises;
  }
  // returns the current value of completed
  Future<bool> isCompleted(String docName) async {
    final CollectionReference exerciseCollection = getExerciseCollection();
    final DocumentReference exerciseDoc = exerciseCollection.doc(docName);
    final bool completed;
    DocumentSnapshot snapshot = await exerciseDoc.get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data.containsKey('Completed')) {
      completed = data['Completed'];
      return completed;
    }
    else{
      return false; //always false 
    }
  }
  // Completed Exercise toggles boolean
  void completeExercise(String docName, bool? newValue) async{
    final CollectionReference exerciseCollection = getExerciseCollection();
    final DocumentReference exerciseDoc = exerciseCollection.doc(docName);
    bool isCompleted;
    DocumentSnapshot snapshot = await exerciseDoc.get();
    //gets the data from the document
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data.containsKey('Completed')) {
      isCompleted = data['Completed'];
      await exerciseDoc.update({'Completed': !isCompleted});
      newValue = isCompleted;
    }
  }
  @override
  void initState() {
    super.initState();
    currWorkoutDoc = widget.currentWorkoutDoc;
    fetchExerciseIds();
  }
  // builds page 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),),
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context,true);
        },
  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: creatingNewExercise,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      body: FutureBuilder( //future builder used so it can read database information
        future: numberOfExercises(),
        builder: (context, snapshot){
          if(snapshot.hasData){ 
            return Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
              child: ListView.builder(
              itemCount: snapshot.data,
              itemBuilder: (context, snapshot) => 
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height *.03),
                  child: Container(// makes the containers
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
                  height: MediaQuery.of(context).size.height * .12, 
                  child: ListTile(
                  title: Text(
                    listExercises[snapshot], 
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20)),
                    subtitle: 
                    Column(
                      children: [
                        SizedBox(height: 1),
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
                          SizedBox(width: MediaQuery.of(context).size.width *.1),
                          FutureBuilder<bool>(
                          future: isCompleted(listExercises[snapshot]),
                          builder: (BuildContext context, AsyncSnapshot<bool> completionBool){
                            if(completionBool.hasData){
                              return Transform.scale(
                                scale: .9,
                                child: CheckboxTheme( 
                                data: CheckboxThemeData(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                side: BorderSide(
                                  color: Colors.lightBlueAccent,
                                  width: 2.0,
                                ),
                                checkColor: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                  return Colors.white;
                                  },
                                ),
                                fillColor: MaterialStateProperty.all<Color>(Colors.white),
                              ),
                                child:Checkbox(
                                value: completionBool.data, 
                                onChanged: (newValue){setState((){completeExercise(listExercises[snapshot], newValue);});}, 
                                )
                              )
                              );
                            }else{
                              return CircularProgressIndicator();
                            }
                          }
                        )
                        ]
                      ),
                    ]
                  ),
                      trailing: IconButton(onPressed: (){}, icon: Icon(Icons.delete), color: Colors.white,),
                    )
                  )
                )
              )
            );
      }else{
        return Center(child: CircularProgressIndicator());
      }
      throw UnimplementedError('There are no workouts Currently');
      }
      )
      );
  }
}