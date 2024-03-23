import 'dart:async';
import 'dart:math' as math;
import 'package:TaskSpace/models/task.dart';
import 'package:flutter/material.dart';
import 'package:pie_timer/pie_timer.dart';
import 'package:flutter/scheduler.dart';
import 'package:slider_button/slider_button.dart';

class TimerPage extends StatefulWidget {
  final Task task;
  final Function(int) onTimerSet;
  TimerPage({required this.task, required this.onTimerSet});

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  bool isEditing = false;
  TextEditingController textEditingController = TextEditingController();
  late String displayText;

  late int _minutesRemaining;
  late int _secondsRemaining;
  late bool _isTimerRunning;
  late int totalTime;
  late Timer _timer;

  double _angle = 0.0;
  static const double dialRadius = 100;
  bool _timerStarted = false;
  static const totalHours = 3;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
    _timer = Timer(Duration.zero, () {});
    displayText = widget.task.title;
    totalTime = widget.task.timer;
    _minutesRemaining = widget.task.timer;
    _secondsRemaining = 0;
    _isTimerRunning = false;
  }

  void _initializeTimer() {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      widget.onTimerSet(widget.task.timer);
    });
  }
  void _toggleTimer() {
    if (_isTimerRunning) {
      _timer.cancel();
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Text('Abort Timer'),
      //       content: Text('Are you sure you want to abort the timer?'),
      //       actions: <Widget>[
      //         TextButton(
      //           onPressed: () {
      //             Navigator.of(context).pop(); // Close the dialog
      //           },
      //           child: Text('Cancel'),
      //         ),
      //         TextButton(
      //           onPressed: () {
      //             // Call the function to pause the timer
      //             _timer.cancel();
      //             Navigator.of(context).pop(); // Close the dialog
      //           },
      //           child: Text('Abort'),
      //         ),
      //       ],
      //     );
      //   },
      // );
    } else {
      _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
      // _timerStarted = true;
    }
    setState(() {
      _isTimerRunning = !_isTimerRunning;
    });
  }

  void _updateTimer(Timer timer) {
    if (_minutesRemaining == 0 && _secondsRemaining == 0) {
      timer.cancel();
      _toggleTimer();
    } else{
      if (_secondsRemaining == 0) {
        setState(() {
          _minutesRemaining--;
          _secondsRemaining = 59;
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.onTimerSet(_minutesRemaining);
        return true;
      },
      child: _buildPage(),
    );
  }

  Widget _buildPage() {
    return Scaffold(
      appBar: appbar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 100),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            GestureDetector(
                              onPanUpdate: (details) {
                                if(!_timerStarted){
                                  setState(() {
                                    _angle = math.atan2(
                                      details.localPosition.dy - dialRadius,
                                      details.localPosition.dx - dialRadius,
                                    );
                                    _angle = _angle < 0 ? _angle + (2 * math.pi)  : _angle;
                                    _minutesRemaining = (_angle / (2 * math.pi) * 60).floor();
                                    _secondsRemaining = ((_angle / (2 * math.pi)  * 60 * 60) % 60).floor();
                                  });
                                }
                              },
                              child: CustomPaint(
                                painter: DialPainter(
                                  progress: _minutesRemaining / totalTime,
                                ),
                                child: Text(
                                  '${_minutesRemaining.toString().padLeft(2, '0')}:${_secondsRemaining.toString().padLeft(2, '0')}',
                                  style: TextStyle(fontSize: 32),
                                ),
                              ),
                            ),
                          ]
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isEditing = true;
                        textEditingController.text = displayText;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: isEditing
                        ? TextFormField(
                            controller: textEditingController,
                            autofocus: true,
                            cursorColor: Colors.black,
                            onFieldSubmitted: (newText) {
                              setState(() {
                                displayText = newText;
                                isEditing = false;
                                widget.task.title = newText;
                              });
                            },
                            onEditingComplete: () {
                            setState(() {
                              displayText = textEditingController.text;
                              isEditing = false;
                              // You can pass the updated text to the parent widget or perform any necessary actions here
                            });
                          },
                          textInputAction: TextInputAction.done,
                                    )
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: EdgeInsets.only(left: 16.0, top: 16.0),
                              child: Text(
                                displayText,
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ),
                    
                    
                    ),
                  ),
                  if(!_isTimerRunning)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(                
                          onPressed: () {
                            setState(() {
                              widget.task.timer = 35;
                              _minutesRemaining = widget.task.timer;
                              totalTime = widget.task.timer;
                            });
                            print('widget.task.timer: ${widget.task.timer}');
                            print('minutes: $_minutesRemaining');
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                          child: Text('35 mins'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.task.timer = 60;
                              _minutesRemaining = widget.task.timer;
                              totalTime = widget.task.timer;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                          child: Text('60 mins'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.task.timer = 60;
                              _minutesRemaining = widget.task.timer;
                              totalTime = widget.task.timer;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                          child: Text('Custom'),
                        ),
                      ]
                    ),
                ],
              ),
            )
          ),

          SizedBox(
            child: Center(
              child: Visibility(
                visible: !_isTimerRunning,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: SliderButton(
                    action: () async {
                      _toggleTimer();
                      return false;
                    },
                    label: Text(
                      "Slide to Start Timer",
                      style: TextStyle(
                        color: Color(0xff4a4a4a),
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                    icon: Icon(Icons.arrow_forward_ios),
                  ),
                )
              ),
            ),
          ),
          SizedBox(
            child: Center(
              child: Visibility(
                visible: _isTimerRunning,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: SliderButton(
                      action: () async {
                        _timer.cancel();
                        Navigator.of(context).pop();
                        return false;
                      },
                      label: Text(
                        "Slide to Cancel Timer",
                        style: TextStyle(
                          color: Color(0xff4a4a4a),
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
              )
            ),
          ),
        ],
      ),
    );
  }  

  AppBar appbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.black,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        Container(
          child: TextButton(
            onPressed: () {
             setState(() {
              widget.task.done = true;
              Navigator.pop(context);
            });
            },
            child: Text('delete?', style: TextStyle(color: Colors.black)),
          ),
        ),
        // IconButton(
        //   icon: Icon(Icons.delete),
        //   color: Colors.black,
        //   onPressed: () {
        //     setState(() {
        //       widget.task.done = true;
        //     });
        //     Navigator.pop(context);
        //   },
        // ),
      ],
    );
  }
}

class DialPainter extends CustomPainter {
  final double progress;

  DialPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) 
  {
    if(progress > 0){
      Paint paint = Paint()
        ..color = Colors.orange
        ..style = PaintingStyle.fill;

      double angle = -(2 * math.pi * progress);

      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: _TimerPageState.dialRadius),
        -math.pi / 2,
        angle,
        true,
        paint,
      );
    } else {
      Paint paint = Paint()
        ..color = Colors.grey
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(size.width / 2, size.height / 2), _TimerPageState.dialRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}