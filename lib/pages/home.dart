import 'package:flutter/material.dart';

class Task {
  String title;
  bool done;

  Task(this.title, this.done);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [
    Task('Task 1', false),
    Task('Task 2', true),
    Task('Task 3', false),
  ];

  TextEditingController _newTaskController = TextEditingController();
  bool isAddingTask = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hi Sid,',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '12 January, 2024',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 10),
              ],
            ),
          ),
          for (Task task in tasks)
            Column(
              children: [
                ListTile(
                  onTap: () {
                    // Add your onPressed logic here!
                  },
                  leading: Transform.scale(
                    scale: 0.9,
                    child: Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      value: task.done,
                      onChanged: (value) {
                        setState(() {
                          task.done = value!;
                        });
                      },
                    ),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.done
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 20,
                ),
              ],
            ),
          // ListTile(
          //   onTap: () {},
          //   leading: Transform.scale(
          //     scale: 0.9,
          //     child: Checkbox(
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       value: false,
          //       onChanged: (value) {},
          //     ),
          //   ),
          // ),
          // const Divider(
          //   height: 1,
          //   thickness: 1,
          //   indent: 20,
          // ),
          if (!isAddingTask) ...[
            buildTaskTextField(),
            const Divider(
              height: 1,
              thickness: 1,
              indent: 20,
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          isAddingTask = !isAddingTask;
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget buildTaskTextField() {
    return TextField(
      autofocus: true,
      controller: _newTaskController,
      onSubmitted: _addTask,
      decoration: InputDecoration(
        hintText: 'What do you want to do?',
        hintStyle: TextStyle(
          fontSize: 16,
          color: Colors.grey[400],
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(bottom: 4),
      ),
    );
  }

  void _addTask(String value) {
    if (value != null && value.trim().isNotEmpty) {
      setState(() {
        tasks.add(Task(value, false));
        isAddingTask = false;
      });
    }
    _newTaskController.clear();
  }
}
  // void _startAddingTask(BuildContext context) {
  //   FocusScope.of(context).requestFocus(new FocusNode());
  //   showTextField(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return TextField(
  //             autofocus: true,
  //             controller: _newTaskController,
  //             onSubmitted: (value) {
  //               if(value != null && value.trim().isNotEmpty){
  //                 setState(() {
  //                   tasks.add(Task(value, false));
  //                 });
  //               }
  //               _newTaskController.clear();
  //             },
  //             decoration: InputDecoration(
  //               hintText: 'What do you want to do?',
  //               hintStyle: TextStyle(
  //                 fontSize: 16,
  //                 color: Colors.grey[400],
  //               ),
  //               border: InputBorder.none,
  //               contentPadding: EdgeInsets.only(bottom: 4),
  //             ),
  //           ),
  //     },
  //   );
  // }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'GetShitDone',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      backgroundColor: Colors.black,
      elevation: 0,
    );
  }

