import 'package:flutter/material.dart';
import 'package:my_project_app/Analytics.dart';
import 'package:my_project_app/main.dart';
import 'package:my_project_app/workouts_Display.dart';
import 'package:provider/provider.dart';
import './Home_Screen.dart';
import './Account_screen.dart';
import './Create_Workout_Screen.dart';
class BottomMenu extends StatefulWidget{
  @override
  Bottom_menu_State createState() => Bottom_menu_State();
}

class Bottom_menu_State extends State<BottomMenu>{
  int page_index = 0;
  final List<Widget> pages = [
    HomePage(),
    CreateWorkout_Page(),
    AnalyticsScreen(),
    AccountScreen()
  ];
  
  void select_page(int index){
    setState((){page_index = index;});
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: null,
      body: pages[page_index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        currentIndex: page_index,
        onTap: select_page,
        selectedItemColor: Colors.lightBlue[100],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.house_rounded),
            label: 'Home',
            backgroundColor: Colors.black
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
            backgroundColor: Colors.black
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
            backgroundColor: Colors.black
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
            backgroundColor: Colors.black
          )
        ]
      ),
    );
  }
}