import 'package:flutter/material.dart';
import 'dart:async';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  String stringSeconds = '00';
  String stringMinutes = '00';
  String stringHours = '00';
  Timer? timer;
  bool started = false;
  List timeLapse = [];
  //stop function 
  void stopCount(){
    timer!.cancel();
    setState(() {
      started = false;
    });
  }
  //resets the timer
  void resetTimer(){
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;
      stringSeconds = '00';
      stringMinutes = '00';
      stringHours = '00';
      started = false;
    });
  }
  //time lapse
  void lapse(){
    String lap = '$stringHours:$stringSeconds:$stringMinutes';
    setState(() {
      timeLapse.add(lap);
    });
  }
  // starts timer
  void start(){
    started = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) { 
      int localsec = seconds +1;
      int localmin = minutes;
      int localhour = hours;
      //adds minutes and hours now 
      if(localsec > 59){
        if(localmin > 59){
          localhour++;
          localmin =0;
        }
        else{
          localmin++;
          localsec = 0;
        }
      }
      setState(() {
        seconds = localsec;
        minutes = localmin;
        hours = localhour;
        stringSeconds = (seconds >= 10) ? '$seconds' : "0$seconds";
        stringMinutes = (minutes >= 10) ? '$minutes' : '0$minutes';
        stringHours = (hours >= 10) ? '$hours' : '0$hours';
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2757),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2757),
        title: Text('Timer', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text('$stringHours:$stringMinutes:$stringSeconds', style: TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold),),
              ),
              Container( //contains the list of timems 
                height: MediaQuery.of(context).size.height * .45,
                decoration: BoxDecoration(
                  color: Color(0xFF323F68),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: ListView.builder(
                  itemCount: timeLapse.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Lap n${index +1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16
                            ),
                          ),
                          Text(
                            '${timeLapse[index]}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16
                            ),
                          ),
                        ]
                      ),
                    );
                  }
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        (!started) ? start() : stopCount();
                      },
                      shape: const StadiumBorder(side: BorderSide(color: Colors.blue),),
                      child: Text(
                        (!started) ? 'Start' : 'Pause', style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * .1),
                  IconButton(
                    onPressed: (){
                      lapse();
                    }, 
                    icon: Icon(Icons.flag),
                    color: Colors.white,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * .1),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        resetTimer();
                      },
                      shape: const StadiumBorder(side: BorderSide(color: Colors.blue),),
                      child: Text('Reset', style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )

                ],
              )
            ],
          )
        ),
      )
    );
  }
}