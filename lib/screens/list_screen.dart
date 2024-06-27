import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/data/task_entry.dart';
import 'package:taskmaster/data/todo_provider.dart';

class ListScreen extends StatefulWidget {
  final String taskType;

  const ListScreen({super.key, required this.taskType});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.taskType.capitalize(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          List<TaskEntry> tasks;

          switch (widget.taskType) {
            case 'today':
              tasks = todoProvider.getTasksForToday();
              break;
            case 'scheduled':
              tasks = todoProvider.getScheduledTasks();
              break;
            case 'all':
            default:
              tasks = todoProvider.getAllTasks();
              break;
          }

          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks available',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),));
          }

          return ListView.separated(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white)),
                subtitle: Text(task.date,style: TextStyle(fontSize: 15,color: Colors.white)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete,color: Colors.white,),
                  onPressed: () {
                    todoProvider.deleteTodoItem(task.id);
                  },
                ),
                leading: Icon(Icons.blur_linear_outlined,color: Colors.red,),
                style: ListTileStyle.list,
                minVerticalPadding: 8,
                tileColor: const Color.fromARGB(255, 59, 61, 61),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(
              thickness: 5,
              indent: 5,
              endIndent: 5,
            ),
          );
        },
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
