
class TaskEntry {
  final String id; // Changed to String to use UUID
  final String title;
  final String date;

  TaskEntry({required this.id, required this.title, required this.date});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
    };
  }

  factory TaskEntry.fromJson(Map<String, dynamic> json) {
    return TaskEntry(
      id: json['id'],
      title: json['title'],
      date: json['date'],
    );
  }
}
