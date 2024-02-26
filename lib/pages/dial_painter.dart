import 'package:flutter/material.dart';
import 'task_duration.dart';


// class DialPainter extends CustomPainter {
//   final double angle;

//   DialPainter({required this.angle});

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint dialPainter = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 15;

//     Offset center = Offset(size.width / 2, size.height / 2);

//     canvas.drawCircle(center, _TimerPageState.dialRadius, dialPainter);

//     Paint knobPainter = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.fill;

//     Offset knobPosition = Offset(
//       center.dx + _TimerPageState.dialRadius * math.cos(angle),
//       center.dy + _TimerPageState.dialRadius * math.sin(angle),
//     );

//     canvas.drawCircle(knobPosition, 10, knobPainter);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }