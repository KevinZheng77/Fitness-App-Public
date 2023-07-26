import 'package:flutter/material.dart';
import 'Button_widget.dart';
import 'dart:async';

class StopWatch extends StatefulWidget {
  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  Timer? timer;

   Widget buildButtons() {
      final isRunning = timer == null? false: timer!.isActive;
      final isCompleted = seconds == maxSeconds || seconds == 0;
      
      return isRunning? 
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonWidget(
            text: isRunning? 'Pause': 'Resume', 
            onClicked: (){
              if(isRunning){
                stopTimer(reset: false);
              }
              else{
                startTimer(reset:false);
              }
            }
          ),
          SizedBox(width: 12),
          ButtonWidget(
            text: 'Cancel', 
            onClicked: (){stopTimer();}
          )
        ]
      ):
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonWidget(
          text: 'Start Timer!',
          onClicked: () {startTimer();},
          )
        ]
      );
    }
  Widget buildTimer() => SizedBox(
    width: 200,
    height: 200,
    child: Stack(
      fit: StackFit.expand,
      children: [
        CircularProgressIndicator(
          value: 1 - seconds/maxSeconds,
          strokeWidth: 13,
          valueColor: AlwaysStoppedAnimation(Colors.white),
          backgroundColor: Color(0xFF6d91c7),
        ),
        Center(child: buildTime(),),
      ],
    )
  );
  Widget buildTime(){
    return Text(
      '$seconds',
      style: TextStyle(
        color: Colors.white,
        fontSize: 80,
        fontWeight: FontWeight.bold),
    );
  }

  //stops timer
  void stopTimer({bool reset = true}){
    if(reset){
      resetTimer();
    }
    setState(() => timer?.cancel());
  }
  
  void resetTimer() => setState(() => seconds = maxSeconds);
  
  //starts timer
  void startTimer({bool reset = true}){
    if(reset){
      resetTimer();
    }
    timer = Timer.periodic(Duration(seconds: 1),(_) {
      if(seconds>0){
        setState(() => seconds--);
      }else{
        stopTimer(reset: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6d91c7),
        title: Text('Stop Watch', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF6d91c7),
                Color(0xFFc7a4ff),
                Color(0xFF8ec5fc),
                Colors.white,
              ],
              stops: [0.0, 0.4, 0.99, 1.0],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .2),
              buildTimer(),
              SizedBox(height: MediaQuery.of(context).size.height * .1),
              buildButtons(), 
            ]
          )
        )
    );

  }
}