import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:studio_flutter_app/loading.dart';
import 'package:studio_flutter_app/result.dart';

/////Structs/////
class Timedinp {
  Offset point;
  DateTime time;
  int state;
  Timedinp(this.point, this.time, this.state);
  //point==null for touchup
}

DrawingDataClass data = new DrawingDataClass(
    <List<Offset>>[[]], <List<Offset>>[], <List<Offset>>[], <List<Offset>>[]);
Map<String, List> dataLow={'drawings':[],'circles':[]};
PointerDeviceKind touchtype = PointerDeviceKind.stylus;
bool penonly = true;
String timeToDraw = "Draw a Clock with time 10 to 12";
DateTime startTime = DateTime.now();

class Modes {
  static int draw = 0;
  static int addCircle = 1;
  static int erase = 2;
  static int moveSelect = 5;
  static int moveMove = 6;
  static int moveCanvas = 10;
}

class DrawingDataClass {
  List<Timedinp> points = [];

  List<List<Offset>> drawing;
  List<List<Offset>> futuredrawing;
  List<List<Offset>> circles;
  List<List<Offset>> futurecircles;
  Set<int> moveset = {};
  Set<int> movesetcir = {};

  List<Offset> movevec;
  int last = 0;
  int canvasstate = 0;
  int index = -1;
  Offset transform = new Offset(0, 0);
  bool restore = false;
  DrawingDataClass(this.drawing, this.futuredrawing, this.circles, this.futurecircles);
}

/////Structs/////
///
/////Canvas/////
class Signature extends CustomPainter {
  DrawingDataClass data;
  int pos;

  Signature({this.data, this.pos});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    if (data.index > -1) {
      //canvas = data.canvs[data.index];
    }
    for (int i = 0; i < data.drawing.length; i++) {
      for (int j = 0; j < data.drawing[i].length - 1; j++) {
        canvas.drawLine(data.drawing[i][j], data.drawing[i][j + 1], paint);
      }
    }
    for (int i = 0; i < data.circles.length; i++) {
      if (data.circles[i] != null && data.circles[i].length == 2)
        canvas.drawCircle(data.circles[i][0],
            (data.circles[i][1] - data.circles[i][0]).distance, paint);
    }
    print("CanvasState=" + data.canvasstate.toString());
  }

  @override
  bool shouldRepaint(Signature oldDelegate) {
    return true;
  }
}
/////Canvas/////

class CDTCanvas extends StatefulWidget {
  @override
  _CDTCanvasState createState() => _CDTCanvasState();
}

class _CDTCanvasState extends State<CDTCanvas> {
  List<IconData> icon = [
    Feather.wind,
    Feather.folder,
    Feather.monitor,
    Feather.lock,
    Feather.mail,
  ];
  DateTime currTime = DateTime.now();
  Timer _timer;
  void startTimer() {
    if (_timer == null)
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          currTime = DateTime.now();
        });
      });
  }

  @override
  void initState() {
    startTime = DateTime.now();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  int _pos = 0;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Container(
              child: new GestureDetector(
                onPanStart: (DragStartDetails details) {
                  if (penonly == true) {
                    setState(() {
                      touchtype = details.kind;
                    });
                  }
                  setState(() {
                    data.movevec = [];
                  });
                },
                onPanUpdate: (DragUpdateDetails details) {
                  if (!penonly ||
                      touchtype == PointerDeviceKind.stylus ||
                      data.canvasstate == 10)
                    setState(() {
                      RenderBox object = context.findRenderObject();
                      Offset _localPosition =
                          object.globalToLocal(details.globalPosition);
                      if (_localPosition.dx < 90) return;

                      data.points.add(Timedinp(
                          _localPosition, DateTime.now(), data.canvasstate));

                      if (data.canvasstate == 0) {
                        data.drawing.last.add(_localPosition);
                      } else if (data.canvasstate == 2) {
                        for (int i = 0; i < data.drawing.length; i++) {
                          for (int j = 0; j < data.drawing[i].length; j++) {
                            if ((data.drawing[i][j] - _localPosition).distance <
                                5) {
                              data.futuredrawing.add(data.drawing[i]);
                              data.drawing.removeAt(i);
                              i--;
                              break;
                            }
                          }
                        }
                        for (int i = 0; i < data.circles.length; i++) {
                          if (data.circles[i] == null) continue;
                          double d =
                              (data.circles[i][0] - _localPosition).distance -
                                  (data.circles[i][1] - data.circles[i][0])
                                      .distance;
                          if (d < 5 && d > -5) {
                            data.futurecircles.add(data.circles[i]);
                            data.circles.removeAt(i);
                            i--;
                          }
                        }
                      } else if (data.canvasstate == 1) {
                        if (data.circles.isEmpty || data.circles.last == null) {
                          data.circles.add([]..add(_localPosition));
                        } else if (data.circles.last.length == 1) {
                          data.circles.last.add(_localPosition);
                        } else if (data.circles.last.length == 2) {
                          data.circles.last[1] = _localPosition;
                        }
                      } else if (data.canvasstate == 5) {
                        for (int i = 0; i < data.drawing.length; i++) {
                          for (int j = 0; j < data.drawing[i].length; j++) {
                            if ((data.drawing[i][j] - _localPosition).distance <
                                10) {
                              data.moveset.add(i);

                              break;
                            }
                          }
                        }
                        for (int i = 0; i < data.circles.length; i++) {
                          if (data.circles[i] == null) continue;
                          double d =
                              (data.circles[i][0] - _localPosition).distance -
                                  (data.circles[i][1] - data.circles[i][0])
                                      .distance;
                          if (d < 5 && d > -5) {
                            data.movesetcir.add(i);
                          }
                        }
                      } else if (data.canvasstate == 6) {
                        if (data.movevec.length < 1)
                          data.movevec.add(_localPosition);
                        else if (data.movevec.length > 0) {
                          for (int i = 0; i < data.moveset.length; i++) {
                            for (int j = 0;
                                j <
                                    data.drawing[data.moveset.elementAt(i)]
                                        .length;
                                j++)
                              data.drawing[data.moveset.elementAt(i)][j] +=
                                  _localPosition - data.movevec[0];
                          }
                          for (int i = 0; i < data.movesetcir.length; i++) {
                            data.circles[data.movesetcir.elementAt(i)][0] +=
                                _localPosition - data.movevec[0];
                            data.circles[data.movesetcir.elementAt(i)][1] +=
                                _localPosition - data.movevec[0];
                          }
                          data.movevec[0] = _localPosition;
                        }
                      } else if (data.canvasstate == 10) {
                        if (data.movevec == null) data.movevec = [];
                        if (data.movevec.length < 1)
                          data.movevec.add(_localPosition);
                        else if (data.movevec.length > 0 &&
                            (_localPosition - data.movevec[0]).distance * 3 <
                                100.0) {
                          Offset temp = (_localPosition - data.movevec[0]) * 3;
                          for (int i = 0; i < data.drawing.length; i++) {
                            for (int j = 0; j < data.drawing[i].length; j++)
                              data.drawing[i][j] += temp;
                          }
                          for (int i = 0; i < data.circles.length; i++) {
                            if (data.circles[i] != null) {
                              data.circles[i][0] += temp;
                              data.circles[i][1] += temp;
                            }
                          }
                          data.movevec[0] = _localPosition;
                        }
                      }
                    });
                },
                onPanEnd: (DragEndDetails details) {
                  if (data.canvasstate == 0) {
                    data.drawing.add(<Offset>[]);
                  } else if (data.canvasstate == 1) {
                    if (data.circles.last != null) data.circles.add(null);
                  } else if (data.canvasstate == 5) {
                    setState(() {
                      data.canvasstate = 6;
                    });

                    data.movevec = [];
                  } else if (data.canvasstate == 6 || data.canvasstate == 10) {
                    if (data.canvasstate == 6)
                      setState(() {
                        data.canvasstate = 5;
                      });
                    data.moveset = {};
                    data.movesetcir = {};
                  }
                },
                child: new CustomPaint(
                  painter: new Signature(data: data, pos: _pos),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(5.0, 30.0, 5, 5),
            height: MediaQuery.of(context).size.height,
            width: 80.0,
            decoration: BoxDecoration(
              color: Color(0xff332A7C),
              //borderRadius: BorderRadius.circular(5.0),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 5,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        child: IconButton(
                          onPressed: () {
                            int k = 0;
                            List<Offset> temp = [];
                            if (data.canvasstate == 0 &&
                                data.drawing.length > 1) {
                              temp = data.drawing[data.drawing.length - 2];
                              data.futuredrawing.add(temp);
                              data.drawing.removeAt(data.drawing.length - 2);
                            } else if (data.canvasstate == 1 &&
                                data.circles.length > 0) {
                              temp = data.circles.last;
                              data.circles.removeLast();
                              while (temp == null && data.circles.length != 0) {
                                temp = data.circles.last;
                                data.circles.removeLast();
                              }
                              //assert temp=null
                              //data.futurecircles.insert(0, temp);
                              if (temp != null) {
                                data.futurecircles.add(temp);
                              }
                            } else if (data.canvasstate == 2 &&
                                data.futuredrawing.length > 0) {
                              data.drawing.last = data.futuredrawing.last;
                              data.drawing.add([]);
                              data.futuredrawing.removeLast();
                            }

                            print("Back");
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.lightBlue,
                            size: 60,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: IconButton(
                            onPressed: () {
                              if (data.canvasstate == 0 &&
                                  data.futuredrawing.length > 0) {
                                data.drawing.last = data.futuredrawing.last;
                                data.drawing.add([]);
                                data.futuredrawing.removeLast();
                              } else if (data.canvasstate == 1 &&
                                  data.futurecircles.length > 0) {
                                data.circles.add(data.futurecircles.last);
                                data.circles.add(null);
                                data.futurecircles.removeLast();
                              }
                            },
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Colors.lightBlue,
                              size: 60,
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                data.canvasstate = 0;
                              });
                              print("Draw");
                            },
                            icon: Icon(
                              Icons.brush_outlined,
                              color: data.canvasstate == 0
                                  ? Colors.red
                                  : Colors.lightBlue,
                              size: 60,
                            )),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                data.canvasstate = 2;
                              });
                              print("Eraser");
                            },
                            icon: Icon(
                              Icons.microwave_outlined,
                              color: data.canvasstate == 2
                                  ? Colors.red
                                  : Colors.lightBlue,
                              size: 60,
                            )),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                data.canvasstate = 1;
                              });
                              print("Circle");
                            },
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: data.canvasstate == 1
                                  ? Colors.red
                                  : Colors.lightBlue,
                              size: 60,
                            )),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                data.canvasstate = 5;
                              });

                              print("Move");
                            },
                            icon: Icon(
                              icon[0],
                              color: data.canvasstate == 5
                                  ? Colors.red
                                  : (data.canvasstate == 6
                                      ? Colors.green
                                      : Colors.lightBlue),
                              size: 60,
                            )),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                data.canvasstate = 10;
                              });

                              print("Move");
                            },
                            icon: Icon(
                              icon[3],
                              color: data.canvasstate == 10
                                  ? Colors.lightGreen
                                  : Colors.black,
                              size: 60,
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(90, 30, 0, 0),
            alignment: Alignment.topLeft,
            child: Text(
              timeToDraw,
              textScaleFactor: 2.5,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
            alignment: Alignment.topRight,
            child: Text(
              "Timer: " +
                  (currTime.difference(startTime)).toString().split('.')[0],
              textScaleFactor: 2,
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayOpacity: 0.2,
        children: [
          SpeedDialChild(
              child: Icon(Icons.replay_rounded),
              label: "Clear Screen",
              onTap: () {
                data.drawing = [[]];
                data.futuredrawing.clear();
                data.circles.clear();
                setState(() {
                  data.canvasstate = 0;
                });
              }),
          SpeedDialChild(
            child: Icon(Icons.skip_next),
            label: "Submit and Move to Next Test",
          ),
          SpeedDialChild(
              child: Icon(Icons.exit_to_app_sharp),
              label: "Submit and Exit to Results",
              onTap: () {
                for (int i = 0; i < data.drawing.length; i++) {
                  List temp = [];
                  if (data.drawing[i] != null && data.drawing[i].length>0) {
                    for (int j = 0; j < data.drawing[i].length; j++) {
                      temp.add([data.drawing[i][j].dx, data.drawing[i][j].dy]);
                    }
                    dataLow['drawings'].add(temp);
                  }
                }
                for (int i = 0; i < data.circles.length; i++) {
                  List temp = [];
                  if (data.circles[i] != null && data.circles[i].length>0) {
                    for (int j = 0; j < data.circles[i].length; j++) {
                      temp.add([data.circles[i][j].dx, data.circles[i][j].dy]);
                    }
                    dataLow['circles'].add(temp);
                  }
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Loading()),
                );
              }),
        ],
      ),
    );
  }
}

void main() {
  runApp(new MaterialApp(
    home: CDTCanvas(),
    debugShowCheckedModeBanner: false,
  ));
}
