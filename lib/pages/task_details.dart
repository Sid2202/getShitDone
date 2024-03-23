import 'dart:async';
import 'package:TaskSpace/models/task.dart';
import 'package:flutter/material.dart';

class TaskDetails extends StatefulWidget {
  final Task task;

  TaskDetails({required this.task});

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State < TaskDetails > {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Transform.scale(
              scale: 0.9,
              child: Checkbox(
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(10),
                // ),
                value: widget.task.done,
                onChanged: (value) {
                  setState(() {
                    widget.task.done = value!;
                  });
                },
              ),
            ),
            title: Text(
              widget.task.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // subtitle: Text(
            //   // 'Duration: ${widget.task.timer} minutes',
            //   // style: TextStyle(
            //   //   fontSize: 16,
            //   // ),
            // ),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => TimerPage(task: widget.task),
          //       ),
          //     );
          //   },
          //   child: Text('Start Timer'),
          // ),
        ],
      ),
    );
  }
}

