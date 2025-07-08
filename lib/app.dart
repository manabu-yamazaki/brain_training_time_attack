import 'package:flutter/material.dart';
import 'package:brain_training_time_attack/config/theme.dart';
import 'package:brain_training_time_attack/features/game/screens/home_screen.dart';

class BrainTrainingTimeAttackApp extends StatelessWidget {
  const BrainTrainingTimeAttackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brain Training Time Attack',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
