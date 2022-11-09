class ValueWrapper<T> {
  ValueWrapper(this.value);

  final T value;
}

class TaskListUpdateStreamWrapper extends ValueWrapper<Stream<void>> {
  TaskListUpdateStreamWrapper(Stream<void> stream) : super(stream);
}

class TaskListUpdateSinkWrapper extends ValueWrapper<Sink<void>> {
  TaskListUpdateSinkWrapper(Sink<void> sink) : super(sink);
}
