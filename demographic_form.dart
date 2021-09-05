import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studio_flutter_app/settings.dart';
import 'canvas.dart';
import 'settings.dart';
import 'main.dart';

void main() {
  runApp(DForm());
}

class FormDataClass {
  String firstName;
  String lastName;
  String gender;
  DateTime dob;
  String email;
  String address;
  String education;
  String medHis;
  String medication;
}

FormDataClass formData = new FormDataClass();
Map<String, dynamic> formDataLow = {};

class DForm extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demographic Form',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FormPage(title: 'Form'),
      debugShowCheckedModeBanner: false,
    );
  }
}

Widget buildName() {
  return Container(
      width: 1000,
      margin: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Container(
            width: 490,
            child: TextField(
              keyboardType: TextInputType.name,
              onChanged: (value) {
                formData.firstName = value;
              },
              decoration: InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          SizedBox(width: 20),
          Container(
            width: 490,
            child: TextField(
              keyboardType: TextInputType.name,
              onChanged: (value) {
                formData.lastName = value;
              },
              decoration: InputDecoration(
                  labelText: "Last Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ],
      ));
}

Widget buildAddr() {
  return Container(
      width: 1000,
      margin: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Container(
            width: 490,
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                formData.email = value;
              },
              decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          SizedBox(width: 20),
          Container(
            width: 490,
            child: TextField(
              keyboardType: TextInputType.name,
              onChanged: (value) {
                formData.address = value;
              },
              decoration: InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              maxLines: 4,
            ),
          ),
        ],
      ));
}

Widget buildEducation() {
  return Container(
    width: 1000,
    margin: EdgeInsets.all(8),
    child: TextField(
      keyboardType: TextInputType.multiline,
      onChanged: (value) {
        formData.education = value;
      },
      decoration: InputDecoration(
          labelText: "Education",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      maxLines: 10,
    ),
  );
}

Widget buildMedHis() {
  return Container(
    width: 1000,
    margin: EdgeInsets.all(8),
    child: TextField(
      keyboardType: TextInputType.multiline,
      onChanged: (value) {
        formData.medHis = value;
      },
      decoration: InputDecoration(
          labelText: "Medical History",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      maxLines: 10,
    ),
  );
}

Widget buildMedicaton() {
  return Container(
    width: 1000,
    margin: EdgeInsets.all(8),
    child: TextField(
      keyboardType: TextInputType.multiline,
      onChanged: (value) {
        formData.medication = value;
      },
      decoration: InputDecoration(
          labelText: "Ongoing Medication",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      maxLines: 10,
    ),
  );
}

class FormPage extends StatefulWidget {
  FormPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        //physics: ClampingScrollPhysics(),
        //scrollDirection: ,
        child: Container(
          height: 1250,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                  child: Stack(children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffffffff),
                          Color(0xffffffff),
                          Color(0xffffffff),
                          Color(0xffffffff)
                        ]),
                  ),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 8),
                      Text(
                        'Form',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      SizedBox(height: 10),
                      buildName(),
                      SizedBox(height: 10),
                      Container(
                          width: 1000,
                          margin: EdgeInsets.all(8),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 490,
                                child: TextField(
                                  keyboardType: TextInputType.name,
                                  onChanged: (value) {
                                    formData.gender = value;
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Gender",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                  height: 50,
                                  width: 490,
                                  child: FlatButton(
                                      color: Colors.blue[200],
                                      onPressed: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime(2000),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2200))
                                            .then((date) {
                                          setState(() {
                                            formData.dob = date;
                                          });
                                        });
                                      },
                                      child: Text(formData.dob == null
                                          ? "Choose DOB"
                                          : "DOB=${formData.dob.toString().split(' ')[0]}"))),
                            ],
                          )),
                      SizedBox(height: 10),
                      buildAddr(),
                      SizedBox(height: 10),
                      buildEducation(),
                      SizedBox(height: 10),
                      buildMedHis(),
                      SizedBox(height: 10),
                      buildMedicaton(),
                      SizedBox(height: 10),
                      FlatButton(
                          color: Colors.indigo[200],
                          height: 50,
                          minWidth: 100,
                          onPressed: () {
                            formDataLow['firstName'] = formData.firstName;
                            formDataLow['lastName'] = formData.lastName;
                            formDataLow['gender'] = formData.gender;
                            formDataLow['dob'] = formData.dob.toString().split(' ')[0];
                            formDataLow['email'] = formData.email;
                            formDataLow['address'] = formData.address;
                            formDataLow['education'] = formData.education;
                            formDataLow['medHis'] = formData.medHis;
                            formDataLow['medication'] = formData.medication;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Configs()),
                            );
                          },
                          child: Text("Submit"))
                    ],
                  ),
                )
              ]))),
        ),
      ),
      /* floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.subject),
      ), */
    );
  }
}
