import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'canvas.dart';


bool cdt = true;
bool tmt = false;
bool fullCDT = true;
bool partialCDT = false;
bool inccpCDT = false;
bool hint = false;

class Configs extends StatefulWidget {
  @override
  _ConfigsState createState() => _ConfigsState();
}

class _ConfigsState extends State<Configs> {
  @override
  Widget build(BuildContext context) {
    cdt = fullCDT || partialCDT || inccpCDT;
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 600,
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                          color: cdt ? Colors.indigo[500] : Colors.indigo[200],
                          height: 50,
                          minWidth: 300,
                          onPressed: () {
                            setState(() {
                              if (cdt == true) {
                                cdt = false;
                                fullCDT = false;
                                partialCDT = false;
                                inccpCDT = false;
                              } else {
                                cdt = true;
                                fullCDT = true;
                              }
                            });
                          },
                          child: Text("Clock Drawing Test")),
                      FlatButton(
                          color: tmt ? Colors.indigo[500] : Colors.indigo[200],
                          height: 50,
                          minWidth: 300,
                          onPressed: () {
                            setState(() {
                              tmt = !tmt;
                            });
                          },
                          child: Text("Trail Making Test")),
                    ],
                  ),
                ),
                Container(
                  width: 600,
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                          color:
                              fullCDT ? Colors.indigo[500] : Colors.indigo[200],
                          height: 50,
                          minWidth: 200,
                          onPressed: () {
                            setState(() {
                              fullCDT = !fullCDT;
                            });
                          },
                          child: Text("Full CDT")),
                      FlatButton(
                          color: partialCDT
                              ? Colors.indigo[500]
                              : Colors.indigo[200],
                          height: 50,
                          minWidth: 200,
                          onPressed: () {
                            setState(() {
                              partialCDT = !partialCDT;
                            });
                          },
                          child: Text("Partial CDT")),
                      FlatButton(
                          color: inccpCDT
                              ? Colors.indigo[500]
                              : Colors.indigo[200],
                          height: 50,
                          minWidth: 200,
                          onPressed: () {
                            setState(() {
                              inccpCDT = !inccpCDT;
                            });
                          },
                          child: Text("Incomplete Copy CDT")),
                    ],
                  ),
                ),
                Container(
                  width: 200,
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                          color:
                              penonly ? Colors.indigo[500] : Colors.indigo[200],
                          height: 50,
                          minWidth: 100,
                          onPressed: () {
                            setState(() {
                              penonly = !penonly;
                            });
                          },
                          child: Text("Pen Only")),
                      FlatButton(
                          color: hint ? Colors.indigo[500] : Colors.indigo[200],
                          height: 50,
                          minWidth: 100,
                          onPressed: () {
                            setState(() {
                              hint = !hint;
                            });
                          },
                          child: Text("Hint")),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(100.0),
                  child: FlatButton(
                      color: Colors.green,
                      height: 50,
                      minWidth: 200,
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CDTCanvas()),
                          );
                        });
                      },
                      child: Text("Start Drawing")),
                ),
              ],
            )));
  }
}
