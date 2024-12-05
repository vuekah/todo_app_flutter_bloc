import 'package:todo_app_flutter_bloc/model/task_model.dart';
enum Status { init, loading, completed, error }

class HomeState {
  HomeState({
    this.listTask = const [],
    this.listTaskCompleted = const [],
    this.todoStatus = Status.init,
    this.completedStatus = Status.init,
  });
  final List<TaskModel>? listTask;
  final List<TaskModel>? listTaskCompleted;
  final Status? todoStatus;
  final Status? completedStatus;

  HomeState copyWith(
          {List<TaskModel>? listTask,
          List<TaskModel>? listTaskCompleted,
          Status? todoStatus,
          Status? completedStatus}) =>
      HomeState(
        listTask: listTask ?? this.listTask,
        listTaskCompleted: listTaskCompleted ?? this.listTaskCompleted,
        todoStatus: todoStatus ?? this.todoStatus,
        completedStatus: completedStatus ?? this.completedStatus,
      );
}
