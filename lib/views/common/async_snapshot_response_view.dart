import 'package:flutter/material.dart';
import 'package:flutter_task_list/common/exceptions.dart';

class AsyncSnapshotResponseView<Loading, Error, Success>
    extends StatelessWidget {
  const AsyncSnapshotResponseView({
    required this.snapshot,
    required this.successWidgetBuilder,
    this.onTryAgainTap,
    this.loadingWidgetBuilder,
    this.errorWidgetBuilder,
    Key? key,
  }) : super(key: key);

  final AsyncSnapshot snapshot;
  final Function? onTryAgainTap;
  final Widget Function(BuildContext context, Success success)
      successWidgetBuilder;
  final Widget Function(BuildContext context, Loading? loading)?
      loadingWidgetBuilder;
  final Widget Function(BuildContext context, Error error)? errorWidgetBuilder;

  @override
  Widget build(BuildContext context) {
    final data = snapshot.data;
    if (data == null || data is Loading) {
      if (loadingWidgetBuilder != null) {
        return loadingWidgetBuilder!(context, data);
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (data is Error) {
      if (errorWidgetBuilder != null) {
        return errorWidgetBuilder!(context, data);
      }
      return Center(
        child: TextButton(
          onPressed: onTryAgainTap as void Function()?,
          child: const Text('Tentar novamente'),
        ),
      );
    }

    if (data is Success) {
      return successWidgetBuilder(context, data);
    }
    throw UnknownStateTypeException();
  }
}
