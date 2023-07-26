
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_project_app/workouts_Display.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateWorkout_Page extends StatefulWidget {
  @override
  CreateWorkout_PageState createState() => CreateWorkout_PageState();
}

class CreateWorkout_PageState extends State<CreateWorkout_Page> {
  //for controlling what the user types in 
  final newWorkoutController = TextEditingController();
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  List<String> workoutIds = [];

  // function for adding workout IDs to the list to print out when building the page
  void fetchWorkoutIds() async {
    workoutIds = [];
    CollectionReference workouts = getWorkoutCollection();
    QuerySnapshot snapshot = await workouts.orderBy('createdAt', descending: false).get();
    snapshot.docs.forEach((document) {
      workoutIds.add(document.id);
    });
    setState(() {});
  }

  // initializes page by getting all the workouts from database 
  void initState() {
    super.initState();
    fetchWorkoutIds();
  }

  //Helper function to help users create a new workout and store it within the database
  void creatingNewWorkout(){
    showDialog(
      context: context, 
      builder: (context) => 
      AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Enter Workout Name', 
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white),
        ),
        content: TextField(
          controller: newWorkoutController,
          decoration: InputDecoration(
          hintText: 'E.g. Arm Day Workout',
          hintStyle: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
          ),
        ),
        actions: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          //save button
            MaterialButton(
              onPressed: save,
              child: Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
            ),
            //cancel button
            MaterialButton(
              onPressed: cancel,
             child: Text('Cancel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )  
          ],
          )
        ],
      )
    );
  }
  //adds workout to database
  Future addWorkoutDatabase() async {
    final DocumentReference workoutDocument = FirebaseFirestore.instance.collection('user').doc(uid);
    final CollectionReference workoutCollection = workoutDocument.collection('Workouts');
    if(uid != null){
      final newID = await workoutCollection.doc(newWorkoutController.text).set({
        'Workouts': newWorkoutController.text,
        'createdAt': FieldValue.serverTimestamp()});
    }
  }
  //saves workout inputted
  void save(){
    String newWorkoutName = newWorkoutController.text;
    //adds workout out to the workout data list 
    addWorkoutDatabase();
    fetchWorkoutIds(); //goes to database again and adds the workout to the screen 
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
    newWorkoutController.clear();
  }
  // goes to exercise page 
  void goToWorkout(String selectedWorkout) async{
    DocumentReference selectedDocument;
    CollectionReference workouts = getWorkoutCollection();
    QuerySnapshot snapshot = await workouts.orderBy('createdAt', descending: false).get();
    // checks to make sure that the selected document is correct
    snapshot.docs.forEach((document) async{
      if(document.id == selectedWorkout){
        selectedDocument = workouts.doc(document.id);
        final result = await Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => MyWorkoutsPage(currentWorkoutDoc: selectedDocument)) // goes to new page with document reference
        );
        // Update list of exercises when user returns from myWorkoutsPage
        if (result == true) {
          fetchWorkoutIds();
        }
      };
    });
  }
  //returns the amount of completed exercises
  Future<int> returnExerciseCompleted(String selectedWorkout) async{
    final CollectionReference workouts = getWorkoutCollection();
    QuerySnapshot snapshot = await workouts.orderBy('createdAt', descending: false).get();
    for (final document in snapshot.docs){
      if(document.id == selectedWorkout){
        return exercisesCompleted(workouts.doc(document.id));
      }
    }
    return 0;
  }
  // returns the number of exercises completed (Helper function)
  Future<int> exercisesCompleted(DocumentReference selectedWorkout) async{
    int exerciseCompleted = 0;
    final CollectionReference exerciseCollection = selectedWorkout.collection('Exercises');
    final QuerySnapshot querySnapshot = await exerciseCollection.get();
    final int exerciseCount = querySnapshot.size;
    for(final DocumentSnapshot documentSnapshot in querySnapshot.docs){
      final bool isCompleted = documentSnapshot.get('Completed');
      if(isCompleted == true){
        exerciseCompleted += 1;
      }
    }
    print(exerciseCompleted/exerciseCount);
    return exerciseCompleted;
  }
  //generates progressbar
  Future<int> returnExerciseNotCompleted(String selectedWorkout) async{
    final CollectionReference workouts = getWorkoutCollection();
    QuerySnapshot snapshot = await workouts.orderBy('createdAt', descending: false).get();
    for (final document in snapshot.docs){
      if(document.id == selectedWorkout){
        return exercisesNotCompleted(workouts.doc(document.id));
      }
    }
    return 0;
  }
  // returns the number of exercises NOT completed 
  Future<int> exercisesNotCompleted(DocumentReference selectedWorkout) async{
    int exerciseNotCompleted = 0;
    final CollectionReference exerciseCollection = selectedWorkout.collection('Exercises');
    final QuerySnapshot querySnapshot = await exerciseCollection.get();
    final int exerciseCount = querySnapshot.size;
    for(final DocumentSnapshot documentSnapshot in querySnapshot.docs){
      final bool isCompleted = documentSnapshot.get('Completed');
      if(isCompleted == false){
        exerciseNotCompleted += 1;
      }
    }
    return exerciseNotCompleted;
  }
  //loops through all the exercises and checks which ones are completed or not completed
  Future<double> exerciseRatio(DocumentReference selectedWorkout) async{
    int exerciseCompleted = 0;
    final CollectionReference exerciseCollection = selectedWorkout.collection('Exercises');
    final QuerySnapshot querySnapshot = await exerciseCollection.get();
    final int exerciseCount = querySnapshot.size;
    for(final DocumentSnapshot documentSnapshot in querySnapshot.docs){
      final bool isCompleted = documentSnapshot.get('Completed');
      if(isCompleted == true){
        exerciseCompleted += 1;
        print('Exercise Completed');
      }
    }
    print(exerciseCompleted/exerciseCount);
    return exerciseCompleted / exerciseCount;
  }
  //generates progressbar
  Future<double> generateProgressBar(String selectedWorkout) async{
    final CollectionReference workouts = getWorkoutCollection();
    QuerySnapshot snapshot = await workouts.orderBy('createdAt', descending: false).get();
    for (final document in snapshot.docs){
      if(document.id == selectedWorkout){
        return exerciseRatio(workouts.doc(document.id));
      }
    }
    return 0.0;
  }

  // returns the number of workouts created so it can be displayed in Listview
  Future<int> numberOfWorkouts() async{
    final CollectionReference workouts = FirebaseFirestore.instance.collection('user').doc(uid).collection('Workouts');
    QuerySnapshot querySnapshot = await workouts.get();
    int numberWorkouts = querySnapshot.size;
    return numberWorkouts;
  }
  // getting Workout Names 
  Stream<QuerySnapshot> getWorkoutName(){
    final CollectionReference workouts = FirebaseFirestore.instance.collection('user').doc(uid).collection('Workouts');
    return workouts.snapshots();
  }

  // gets the collection Workout (Helper function)
  CollectionReference getWorkoutCollection(){
    final CollectionReference workouts = FirebaseFirestore.instance.collection('user').doc(uid).collection('Workouts');
    return workouts;
  }
  //checks to see if collection exists
  Future<bool> collectionExist(CollectionReference collectionPath) async {
    final QuerySnapshot snapshot = await collectionPath.limit(1).get();
    return snapshot.size > 0;
  }

  // gets the number of exercises within the Collection
  Future<int> numberOfExercises(String workoutName) async{
    final CollectionReference numExercises = FirebaseFirestore.instance.collection('user').doc(uid).collection('Workouts').doc(workoutName).collection('Exercises');
    bool exists = await collectionExist(numExercises);
    if(exists == true){
      QuerySnapshot querySnapshot = await numExercises.get();
      int numOfDocuments = querySnapshot.size;
      return numOfDocuments;
    } 
    else{
      return 0;
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Workouts', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),)
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: creatingNewWorkout,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      body: FutureBuilder(
        future: numberOfWorkouts(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Container(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
            child: ListView.builder( //creates the list view
            itemCount: snapshot.data,
            itemBuilder: (context, snapshot) => 
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height *.03),
                child: InkWell(
                  onTap: ()=> goToWorkout(workoutIds[snapshot]),
                  child: Container( // decorations for each container
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0, 0.5, 1],
                      tileMode: TileMode.clamp,
                      colors: [
                        Color(0xFF6d91c7),
                        Color(0xFFc7a4ff),
                        Color(0xFF8ec5fc),
                      ],
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
                  height: MediaQuery.of(context).size.height * .20, 
                  child: ListTile( //the text within each container
                    title: Text(
                      workoutIds[snapshot],
                      style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white
                      ),
                    ),
                    trailing: IconButton(onPressed: (){}, icon: Icon(Icons.delete), color: Colors.white,),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<int>( //shows how many exercises are within the set
                          future: numberOfExercises(workoutIds[snapshot]),
                          builder: (BuildContext context, AsyncSnapshot<int> snapshots) {
                            if (snapshots.hasData) {
                              return Text(
                                '${snapshots.data} Exercises',
                                style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * .07),
                        FutureBuilder<List<dynamic>>(
                          future: Future.wait([returnExerciseCompleted(workoutIds[snapshot]), numberOfExercises(workoutIds[snapshot])]),
                          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasData) {
                                final data1 = snapshot.data![0];
                                final data2 = snapshot.data![1];
                                return Text(
                                  '$data1/$data2 Completed',
                                  style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold));
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Text('No data');
                              }
                            } else {
                              return CircularProgressIndicator();
                            }
                          }
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * .007),
                           Container( //container of the progress bar to help size the progress bar
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[300],),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FutureBuilder<double>(
                                future: generateProgressBar(workoutIds[snapshot]),
                                builder: (BuildContext context, documentSnapshot){
                                  if(documentSnapshot.hasData){
                                    return LinearProgressIndicator(
                                      value: documentSnapshot.data,
                                      backgroundColor: Colors.white,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                    );
                                  }
                                    else{
                                      return LinearProgressIndicator(
                                        value: 0,
                                        backgroundColor: Colors.grey[300],
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)
                                      );
                                    }
                                }
                              )
                            )
                          )
                      ],
                    ),
                  ),
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