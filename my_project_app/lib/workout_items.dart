import 'package:flutter/material.dart';

class Workoutitem extends StatelessWidget{
  final String excercise;
  Workoutitem(this.excercise);
  @override

  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(15),
      child: Text(excercise),
      color: Colors.purple,
      );
  }
}