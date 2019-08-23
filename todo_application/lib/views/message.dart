abstract class IMessage {
  String get createNewTask;

  String totalTask(int count);

  String get labelTask;

  String get labelDescription;

  String get addTask;

  String get errorMessageTask;

  String get updateTask;
  String get taskLoaded;
  String get taskCreated;
  String get taskUpdated;
  String get taskDeleted;
  String get processingError;
}

class Message implements IMessage {
  @override
  String get createNewTask => "Create new task";

  @override
  String totalTask(int count) {
    return "You have $count task";
  }

  @override
  String get labelTask => "Task";

  @override
  String get labelDescription => "Description";

  @override
  String get addTask => "Add task";

  @override
  String get errorMessageTask => "Task should not empty";

  @override
  String get updateTask => "Update task";

  @override
  String get taskLoaded => "Task loaded successfully";

  @override
  String get taskCreated => "Task created successfully";

  @override
  String get taskUpdated => "Task updated successfully";

  @override
  String get taskDeleted => "Task deleted successfully";

  @override
  String get processingError => "Something went wrong. Try again";
}
