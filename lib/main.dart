import 'package:flutter/material.dart';
import 'package:taskmaster/data/todo_provider.dart';
import 'package:taskmaster/screens/home_screen.dart';
import 'package:taskmaster/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
   runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: TaskMaster(),
    ),
  );
}

class TaskMaster extends StatelessWidget {
  const TaskMaster({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskMaster',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 229, 141, 159)),
        useMaterial3: true,
      ),
      routes: {
        'splash':(context) => SplashScreen(),
        '/':(context) => TodoListScreen(),
      },
      initialRoute: 'splash',
      
      
    );
  }
}

