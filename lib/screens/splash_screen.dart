import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taskmaster/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(period:Duration(seconds: 3),);

    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TodoListScreen()),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Task Master",
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    color: Color.fromARGB(255, 245, 165, 145),
                    blurRadius: 3.0,
                    offset: Offset.zero,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Icon(
                  Icons.date_range_sharp,
                  color: ColorTween(
                    begin: Colors.black,
                    end: Colors.white,
                  ).evaluate(_controller),
                  size: 100,
                  grade: 20,
                  shadows: [
                    Shadow(color: Color.fromARGB(255, 194, 108, 65),offset: Offset.zero,blurRadius: 10)
                ],
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
