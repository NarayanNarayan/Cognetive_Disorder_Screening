import 'package:flutter/material.dart';
import 'canvas.dart';
import 'result.dart';
import 'demographic_form.dart';
import 'loading.dart';
import 'settings.dart';


void main() =>
  runApp(new MaterialApp(
    initialRoute: '/form',
    routes: {
      '/form':(context)=>DForm(),
      '/settings':(context)=>Configs(),
      '/canvas':(context)=>CDTCanvas(),
      //'/loading':(context)=>Loading(),
      //'/form':(context)=>Question("What??"),
      '/result':(context)=>Result()
    },
    debugShowCheckedModeBanner: false,
  ));