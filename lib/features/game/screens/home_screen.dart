import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brain Training Time Attack'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // TODO: ひとりで遊ぶ画面へ遷移
              },
              child: const Text('ひとりで遊ぶ'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: ふたりで遊ぶ画面へ遷移
              },
              child: const Text('ふたりで遊ぶ'),
            ),
          ],
        ),
      ),
    );
  }
}
