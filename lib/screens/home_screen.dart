import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/data/build_box.dart';
import 'package:taskmaster/data/task_entry.dart';
import 'package:taskmaster/data/todo_provider.dart';
import 'package:taskmaster/screens/list_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    List<TaskEntry> searchResults = todoProvider.searchTasks(_searchController.text);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Task Master',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 59, 61, 61),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color.fromARGB(255, 158, 170, 170),
                  style: BorderStyle.solid,
                  width: 3,
                ),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.white,
                  ),
                  isDense: true,
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  fillColor: Color.fromARGB(255, 59, 61, 61),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  filled: true,
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_searchController.text.isNotEmpty)
              _buildSearchResults(searchResults)
            else
              _buildTaskOverview(context),
            const SizedBox(height: 200),
          ],
        ),
      ),
      floatingActionButton: Row(children: [
        const Expanded(
            flex: 1,
            child: Text(
              'New Task',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
        Expanded(
          flex: 1,
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 163, 91, 91),
            elevation: 10,
            tooltip: "New Task",
            onPressed: () => _showAddTaskDialog(context),
            child: const Text(
              '+',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildSearchResults(List<TaskEntry> searchResults) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final task = searchResults[index];
        return ListTile(
          title: Text(task.title, style: const TextStyle(color: Colors.white)),
          subtitle: Text(task.date, style: const TextStyle(color: Colors.white70)),
          tileColor: const Color.fromARGB(255, 59, 61, 61),
        );
      },
    );
  }

  Widget _buildTaskOverview(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListScreen(taskType: 'today')),
                    );
                  },
                  child: buildBox(
                    name: 'Today',
                    iconColor: Colors.blue,
                    count: Provider.of<TodoProvider>(context)
                        .getTasksForToday()
                        .length,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListScreen(taskType: 'scheduled')),
                    );
                  },
                  child: buildBox(
                    name: 'Scheduled',
                    iconColor: Colors.green,
                    count: Provider.of<TodoProvider>(context)
                        .getScheduledTasks()
                        .length,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 150,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ListScreen(taskType: 'all')),
              );
            },
            child: buildBox(
              name: 'All',
              iconColor: Colors.red,
              count: Provider.of<TodoProvider>(context).getAllTasks().length,
            ),
          ),
        ),
      ],
    );
  }

 void _showAddTaskDialog(BuildContext context) {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final uuid = Uuid();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(hintText: 'Task Title'),
            ),
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(hintText: 'Task Date'),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final task = TaskEntry(
                id: uuid.v4(), // Generate a unique id
                title: _taskController.text,
                date: _dateController.text,
              );
              Provider.of<TodoProvider>(context, listen: false)
                  .addTodoItem(task);
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}
}