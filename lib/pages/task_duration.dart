import 'dart:async';
import 'dart:math' as math;
// import 'dial_painter.dart';
import 'package:newapp/models/task.dart';
import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  final Task task;

  TimerPage({required this.task});

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
  late Timer _timer;

  double _angle = 0.0;
  static const double dialRadius = 100;
  bool _timerStarted = false;
  static const totalHours = 3;

  @override
  void initState() {
    super.initState();
    displayText = widget.task.title;
    _minutesRemaining = widget.task.timer;
    _secondsRemaining = 0;
    _isTimerRunning = false;
  }

  void _toggleTimer() {
    if (_isTimerRunning) {
      widget.task.timer = _minutesRemaining;
      _timer.cancel();
    } else {
      _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
      _timerStarted = true;
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

    return Scaffold(
      appBar: appbar(),
      body: Column(
        children: [
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
                ? TextField(
                    controller: textEditingController,
                    onSubmitted: (newText) {
                      setState(() {
                        displayText = newText;
                        isEditing = false;
                        widget.task.title = newText;
                      });
                    },
                  )
                : Text(
                    displayText,
                    style: TextStyle(fontSize: 20.0),
                  ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              // Container(
              //   height: 200,
              //   width: 200,
              //   child: CircularProgressIndicator(
              //     // value: _secondsRemaining / (widget.task.timer * 60),
              //     // value: widget.task.timer, 
              //     // value: widget.task.timer == 0 ? 0 : (_minutesRemaining * 60 + _secondsRemaining) / (widget.task.timer),
              //     value: _minutesRemaining/60,
              //     valueColor: AlwaysStoppedAnimation(Colors.black)
              //   ),
              // ),
              GestureDetector(
                onPanUpdate: (details) {
                  if(!_timerStarted){
                    setState(() {
                      _angle = math.atan2(
                        details.localPosition.dy - dialRadius,
                        details.localPosition.dx - dialRadius,
                      );
                      // _angle = _angle;
                      _angle = _angle < 0 ? _angle + (2 * math.pi) : _angle;
                      _minutesRemaining = (_angle / (2 * math.pi) * 60).floor();
                      _secondsRemaining = ((_angle / (2 * math.pi) * 60 * 60) % 60).floor();
                    });
                  }
                },
                child: CustomPaint(
                  size: Size(dialRadius * 2, dialRadius * 2),
                  painter: DialPainter(
                    angle: _angle,
                    timerStarted: _timerStarted,
                  ),
                ),
              ),
              Text(
                '${_minutesRemaining.toString().padLeft(2, '0')}:${_secondsRemaining.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 20),
              ),
            ]
          ),
          ElevatedButton(
            onPressed: (){
              _toggleTimer();
            },
            child: Text(_isTimerRunning ? 'Pause' : 'Start'),
          ),
        ],
      ),
    );
  }

  AppBar appbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.black,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.delete),
          color: Colors.black,
          onPressed: () {
            setState(() {
              widget.task.done = true;
            });
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}



class DialPainter extends CustomPainter {
  final double angle;
  final bool timerStarted;

  DialPainter({required this.angle, required this.timerStarted});

  @override
  void paint(Canvas canvas, Size size) 
  {
    Paint dialPainter = Paint()
      ..color = (timerStarted ? Colors.black : Colors.grey)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, _TimerPageState.dialRadius, dialPainter);

    if(!timerStarted){
      Paint progressPainter = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: _TimerPageState.dialRadius),
        -math.pi / 2,
        angle,
        false,
        progressPainter,
      );
      Paint knobPainter = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;

      Offset knobPosition = Offset(
        center.dx + _TimerPageState.dialRadius * math.cos(angle - math.pi / 2),
        center.dy + _TimerPageState.dialRadius * math.sin(angle - math.pi / 2),
      );

      canvas.drawCircle(knobPosition, 8, knobPainter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}