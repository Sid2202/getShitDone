import 'package:flutter/material.dart';
import 'package:TaskSpace/models/task.dart';
import 'task_details.dart';
import 'task_duration.dart';
import 'dart:async';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> categories = [
    Category('#today', [
      Task('Task 1', false),
      Task('Task 2', true),
    ]),
    Category('#tomorrow', [
      Task('Task 3', false),
      Task('Task 4', true),
    ]),
    Category('#week', [
      Task('Task 5', false),
      Task('Task 6', true),
    ]),
    Category('#month', [
      Task('Task 7', false),
      Task('Task 8', true),
    ]),
  ];

  Category? selectedCategory;
  @override
  void initState() {
    super.initState();
    selectedCategory = categories[0]; // Set default selectedCategory to today
  }
  

  TextEditingController _newTaskController = TextEditingController();
  bool isAddingTask = false;

  @override
  Widget build(BuildContext context) {

    int totalTasks = selectedCategory?.tasks.length ?? 0;
    int completedTasks = selectedCategory?.tasks.where((task) => task.done).length ?? 0;
    double progress = totalTasks > 0 ? completedTasks / totalTasks : 0;

    return Scaffold(
      appBar: appBar(),
      resizeToAvoidBottomInset: true,
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 16),
            child: Divider(
              height: 1,
              thickness: 2,
              color: Colors.black,
            )
          ),
          header(),
          // subheader(),
          Container(
            // padding: EdgeInsets.only(left: 10, right: 10, bottom: 16),
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 16),
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                Category category = categories[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Card(
                    margin: EdgeInsets.all(5),
                    color: selectedCategory == category ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: Colors.grey, // Set the border color
                        width: 1, // Set the border width
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 16,
                          color: selectedCategory == category ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // LinearProgressIndicator(
          //   value: progress,
          //   backgroundColor: Colors.grey,
          //   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          // ),

          if (selectedCategory != null)
            for (Task task in selectedCategory!.tasks)
              Column(
                children: [
                  Dismissible(
                    key: Key(task.title),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        selectedCategory!.tasks.remove(task);
                      });
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TimerPage(
                                  task: task,
                                  onTimerSet: (int timer) {
                                    setState(() {
                                      task.timer = timer;
                                    });
                                  }
                                ),
                              ),
                            );
                          },
                          leading: Transform.scale(
                            scale: 0.9,
                            child: Checkbox(
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(10),
                              // ),
                              value: task.done,
                              onChanged: (value) {
                                setState(() {
                                  task.done = value!;
                                });
                              },
                              activeColor: Colors.black,
                            ),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.done
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20, bottom: 16),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
                            //   onTap: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => TimerPage(task: task),
                            //       ),
                            //     );
                            //   },
                            //   leading: Transform.scale(
                            //     scale: 0.9,
                            //     child: Checkbox(
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(10),
                            //       ),
                            //       value: task.done,
                            //       onChanged: (value) {
                            //         setState(() {
                            //           task.done = value!;
                            //         });
                            //       },
                            //     ),
                            //   ),
                            //   title: Text(
                            //     task.title,
                            //     style: TextStyle(
                            //       decoration: task.done
                            //           ? TextDecoration.lineThrough
                            //           : TextDecoration.none,
                            //       fontSize: 16,
                            //       color: Colors.black,
                            //     ),
                            //   ),
                            // ),
                          //   const Divider(
                          //     height: 1,
                          //     thickness: 1,
                          //     indent: 20,
                          //   ),
                          // ],
                  //       ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    _showAddTaskBottomSheet(context);
                  },
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.black,
                ),
              );
            }

            void _showAddTaskBottomSheet(BuildContext context) {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'What do you want to do?',
                            contentPadding: EdgeInsets.all(20),
                          ),
                          onSubmitted: (value) {
                            // Handle the submitted value (new task)
                            if (value != null && value.trim().isNotEmpty) {
                              setState(() {
                                selectedCategory!.tasks.add(Task(value, false));
                              });
                              Navigator.pop(context); // Close the bottom sheet
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }


AppBar appBar() {
  return AppBar(
    centerTitle: false,
    title: const Text(
      'TaskSpace',
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
      textAlign: TextAlign.left,
    ),
    actions: [
      IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    ],
    backgroundColor: Colors.white,
    elevation: 0,
  );
}

header() {
  return Container(
    // padding: EdgeInsets.all(20),
    padding: EdgeInsets.only(left: 20, right: 20, bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'your tasks',
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    // decoration: const BoxDecoration(
    //   color: Colors.black,
    //   borderRadius: BorderRadius.only(
    //     bottomLeft: Radius.circular(50),
    //     bottomRight: Radius.circular(50),
    //   ),
    // ),
  );
}

subheader() {
  return Container(
    padding: EdgeInsets.all(12),
    margin: EdgeInsets.only(left: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tasks',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}