class Todo {
  bool completed = false;
  String title = "";

  Todo();
  Todo.of(this.title, this.completed);

  Todo.fromMap(Map<String, Object?> map) {
    title = map['name'] as String;
    completed = map['completed'] == 1;
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'name': title,
      'completed': completed == true ? 1 : 0
    };
    return map;
  }
}
