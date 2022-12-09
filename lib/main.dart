import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_list/common/tls_general_provider.dart';
import 'package:flutter_task_list/config.dart';
import 'package:flutter_task_list/data/cache/model/character.dart';
import 'package:flutter_task_list/main_container_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Hive
    ..init((await path_provider.getApplicationDocumentsDirectory()).path)
    ..registerAdapter(CharacterCMAdapter());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TslGeneralProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task List',
        theme: light,
        darkTheme: dark,
        themeMode: currentTheme.currentTheme(),
        home: const MainContainerScreen(),
      ),
    );
  }
}
