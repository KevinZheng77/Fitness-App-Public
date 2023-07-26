import 'package:flutter/material.dart';
import 'Individual_Bar.dart';

class BarData{
  final double sunCal;
  final double monCal;
  final double tueCal;
  final double wedCal;
  final double thurCal;
  final double friCal;
  final double satCal;


  BarData({
    required this.sunCal,
    required this.monCal,
    required this.tueCal,
    required this.wedCal,
    required this.thurCal,
    required this.friCal,
    required this.satCal,
  });

  List<IndividualBar> barData = [];

  void initializeBarData(){
    barData = [
      IndividualBar(x: 0, y:sunCal),
      IndividualBar(x: 1, y:monCal),
      IndividualBar(x: 2, y:tueCal),
      IndividualBar(x: 3, y:wedCal),
      IndividualBar(x: 4, y:thurCal),
      IndividualBar(x: 5, y:friCal),
      IndividualBar(x: 6, y:satCal),
    ];
  }
}