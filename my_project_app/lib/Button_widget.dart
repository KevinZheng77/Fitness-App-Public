import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final Color color; 
  final Color backgroundColor;
  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
    this.color = Colors.white,
    this.backgroundColor = Colors.black
  }) : super(key:key);

  Widget build(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: backgroundColor,
      padding: EdgeInsets.all(32)
    ),
    child: Text(text,style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
    onPressed: onClicked,
  );
}

