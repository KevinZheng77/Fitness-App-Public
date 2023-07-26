import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:my_project_app/Bar_Graph.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreen_State createState() => _AnalyticsScreen_State();
}

class _AnalyticsScreen_State extends State<AnalyticsScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calories Burned', 
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black),
        ),
        backgroundColor: Color(0xFF6d91c7),
      ),
      body: 
        Container(
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
              stops: [0.0, 0.4, 0.95, 1.0],
            ),
          ),
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .65,
              child: MyBarGraph()
            )
          )
        )
    );
  }
}



