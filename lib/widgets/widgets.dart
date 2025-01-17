import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w300
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFFee7b64),
      width: 2,
    )
  ),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFee7b64),
        width: 2,
      )
  ),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFee7b64),
        width: 2,
      )
  ),
);

// we are using to navigate to next scrren but previous screen still remain so we can back

void nextScreen(context,page){
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

// we are also using this to navigate but it destroy the current screen
void nextScreenReplace(context,page){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}
void showSnackBar(context,color,message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,
  style: const TextStyle(fontSize: 14),),
    backgroundColor: color,
  duration: const Duration(seconds: 2),
  action: SnackBarAction(
    label: "OK",
    onPressed: (){},
    textColor: Colors.white,
  ),));
}
