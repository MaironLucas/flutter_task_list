abstract class TaskListExceptions implements Exception {}

class WrongCredentialsException extends TaskListExceptions {}

class EmailAlreadyUsedException extends TaskListExceptions {}
