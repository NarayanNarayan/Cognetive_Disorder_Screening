
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:http/http.dart' as http;
import 'package:studio_flutter_app/result.dart';
import 'canvas.dart';
import 'result.dart';
import 'demographic_form.dart';
//Map<String, List> dataLow;
String host = '192.168.1.32';
//String host = '127.0.0.1';
String port = '27017';
Future dbTest() async {
  //var db = Db('mongodb://$host:$port/test');
  print(dataLow);
  //print();
  var db = await Db.create(
      'mongodb+srv://root:loop@cluster0.nneih.mongodb.net/test/?retryWrites=true&w=majority');
  await db.open();
  await db.drop();
  var collection = db.collection('test');
  await collection.insertOne({'demodata':formDataLow,'drawingdata': dataLow});
  /* db.ensureIndex('authors',
      name: 'meta', keys: {'_id': 1, 'name': 1, 'age': 1});
  collection.find().forEach((v) {
    print(v);
    authors[v['name'].toString()] = v;
  }); */
  await db.close();
  return 'Success';
}

class Loading extends StatelessWidget {
  void init(BuildContext context) {
    dbTest().then((rv) {
      print(rv);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Result()));
    });
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return Scaffold(
        backgroundColor: Colors.blue[900],
        body: Center(
          //[SpinKitFadingCube],[SpinKitSpinningLines],[SpinKitDancingSquare],[SpinKitCubeGrid]
          child: SpinKitSpinningLines(
            //duration: Duration(milliseconds: 5000),
            color: Colors.white,
            size: 150.0,
          ),
        ));
  }
}
