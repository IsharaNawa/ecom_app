import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Hello World",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Hello World"),
            ),
          ],
        ),
      ),
    );
  }
}
