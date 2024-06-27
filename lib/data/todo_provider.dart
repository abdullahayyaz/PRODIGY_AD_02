import 'package:flutter/material.dart';
import 'package:taskmaster/data/task_entry.dart';
import 'package:intl/intl.dart';

class TodoProvider with ChangeNotifier {
  List<TaskEntry> _todoList = [];

  List<TaskEntry> get todoList => _todoList;

  void addTodoItem(TaskEntry task) {
    _todoList.add(task);
    notifyListeners();
  }

  void deleteTodoItem(String id) {
    _todoList.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  List<TaskEntry> getTasksForToday() {
    final today = DateTime.now();
    return _todoList.where((task) {
      final taskDate = _parseDate(task.date);
      return taskDate.year == today.year &&
          taskDate.month == today.month &&
          taskDate.day == today.day;
    }).toList();
  }

  List<TaskEntry> getScheduledTasks() {
    final today = DateTime.now();
    return _todoList.where((task) {
      final taskDate = _parseDate(task.date);
      return taskDate.isAfter(today);
    }).toList();
  }

  List<TaskEntry> getAllTasks() {
    return _todoList;
  }

  List<TaskEntry> searchTasks(String query) {
    return _todoList
        .where((task) =>
            task.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  DateTime _parseDate(String date) {
    try {
      return DateFormat('yyyy-MM-dd').parse(date);
    } catch (e) {
      // Handle invalid date format
      print('Error parsing date: $e');
      return DateTime.now(); // Default to current date if parsing fails
    }
  }
}
