import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class Question extends StatelessWidget {
  final String questionText;
  Question(this.questionText);
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:Container(
      width: 1000,
      margin: EdgeInsets.all(20),
      child:  Row(
      children: <Widget>[
        Container(
          width: 400,
          child: TextField(
        keyboardType: TextInputType.name,
        
        decoration: InputDecoration(
           labelText: "First Name",
          border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(10)
           )
         ),
       ),),
       Container(
         width: 400,
         child: TextField(
          keyboardType: TextInputType.name,
          
          decoration: InputDecoration(
            labelText: "Last Name",
           border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(10)
           )
         ),
       ),
       ),
      ],
      )
    )
    );
  }
}
