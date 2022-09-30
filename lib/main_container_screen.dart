import 'package:flutter/material.dart';
import 'package:flutter_task_list/data/dummy_state_handler.dart';
import 'package:provider/provider.dart';

class MainContainerScreen extends StatelessWidget {
  const MainContainerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => DummyStateHandler(),
        child: null,
      );
}
