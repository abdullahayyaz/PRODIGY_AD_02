import 'package:flutter/material.dart';

class buildBox extends StatelessWidget {
  const buildBox({
    super.key,
    required this.name,
    required this.iconColor,
    required this.count,
  });

  final String name;
  final Color iconColor;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 59, 61, 61),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(255, 158, 170, 170),
            style: BorderStyle.solid,
            width: 3,
          ),
        ),
        child: Column(
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Color.fromARGB(255, 207, 197, 197),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: CircleAvatar(
                    backgroundColor: iconColor,
                    radius: 25,
                    child: const Icon(
                      Icons.date_range,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
