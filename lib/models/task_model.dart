class TaskModel {
  String title;
  String description;
  bool isComplete;

  TaskModel({
    required this.title,
    required this.description,
    this.isComplete = false,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'isComplete': isComplete,
      };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        title: json['title'],
        description: json['description'],
        isComplete: json['isComplete'] ?? false,
      );
}
