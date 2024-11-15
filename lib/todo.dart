class Todo {
  final int? id;
  final String title;
  final String description;
  final int isCompleted;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
      };

  static Todo fromJson(Map<String, dynamic> json) => Todo(
        id: json['id'] as int?,
        title: json['title'] as String,
        description: json['description'] as String,
        isCompleted: json['isCompleted'] as int,
      );
}
