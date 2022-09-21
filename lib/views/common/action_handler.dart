import 'package:flutter/widgets.dart';
import 'package:flutter_task_list/common/subscription_holder.dart';
import 'package:rxdart/rxdart.dart';

class ActionHandler<T> extends StatefulWidget {
  const ActionHandler({
    required this.child,
    required this.actionStream,
    required this.onReceived,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Stream<T> actionStream;
  final ValueChanged<T> onReceived;

  @override
  // ignore: library_private_types_in_public_api
  _ActionHandlerState<T> createState() => _ActionHandlerState<T>();
}

class _ActionHandlerState<T> extends State<ActionHandler<T>>
    with SubscriptionHolder {
  @override
  void initState() {
    super.initState();
    widget.actionStream
        .listen(
          widget.onReceived,
        )
        .addTo(subscriptions);
  }

  @override
  void dispose() {
    super.dispose();
    disposeAll();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
