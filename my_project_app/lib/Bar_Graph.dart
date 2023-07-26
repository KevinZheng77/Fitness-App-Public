import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'bar_data.dart';
class MyBarGraph extends StatefulWidget {
  @override
  _MyBarGraphState createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {
  List<double> caloriesBurned = [947,350,1479,389,749,1076,847];
  @override
  Widget build(BuildContext context) {
    //initialized Bar data
    BarData myBarData = BarData(
      sunCal: caloriesBurned[0],
      monCal: caloriesBurned[1],
      tueCal: caloriesBurned[2],
      wedCal: caloriesBurned[3],
      thurCal: caloriesBurned[4],
      friCal: caloriesBurned[5],
      satCal: caloriesBurned[6],
    );
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: 1500,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getBottomTitles)),
        ),
        barGroups: myBarData.barData.map(
          (data) => BarChartGroupData(
            x: data.x,
            barRods: [
              BarChartRodData(
                toY: data.y,
                color: Colors.black,
                width: 20,

              )
            ]
          )
        ).toList()
      )
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta){
  const style = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.bold
  );

  Widget text;
  switch (value.toInt()){
    case 0: 
     text = const Text('S', style: style);
     break;
    case 1: 
     text = const Text('M', style: style);
     break;
    case 2: 
     text = const Text('T', style: style);
     break;
    case 3: 
     text = const Text('W', style: style);
     break;
    case 4: 
     text = const Text('Th', style: style);
     break;
    case 5: 
     text = const Text('F', style: style);
     break;
    case 6: 
     text = const Text('S', style: style);
     break;
    default: 
      text = const Text('', style: style);
      break;
  }
  return SideTitleWidget(axisSide: meta.axisSide,child: text);
}