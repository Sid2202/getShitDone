class Category {
  String name;
  List<Task> tasks;

  Category(this.name, this.tasks);
}

class Task {
  String title;
  bool done;
  int timer;

  Task(this.title, this.done, {this.timer = 25});
}
