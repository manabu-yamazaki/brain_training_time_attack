// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_training_time_attack/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Firebase設定ファイルを追加後に有効化
  // await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: BrainTrainingTimeAttackApp(),
    ),
  );
}
