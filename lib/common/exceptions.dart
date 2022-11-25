abstract class TaskListExceptions implements Exception {}

class WrongCredentialsException extends TaskListExceptions {}

class EmailAlreadyUsedException extends TaskListExceptions {}

class WeakPasswordException extends TaskListExceptions {}

class InternalException extends TaskListExceptions {}

class UnknownStateTypeException extends TaskListExceptions {}

class UserDoesntHaveTaskException extends TaskListExceptions {}

class UnauthenticatedUserException extends TaskListExceptions {}

class TaskDoesntHaveStepsException extends TaskListExceptions {}

class UserNeedsLoginException extends TaskListExceptions {}

class AlreadyHasTaskException extends TaskListExceptions {}
