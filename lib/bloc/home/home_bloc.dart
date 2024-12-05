import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_flutter_bloc/bloc/home/home_state.dart';
import 'package:todo_app_flutter_bloc/model/task_model.dart';
import 'package:todo_app_flutter_bloc/service/auth_service.dart';
import 'package:todo_app_flutter_bloc/service/task_service.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(HomeState());

  void fetchTodos() async {
    emit(state.copyWith(todoStatus: Status.loading));
    try {
      final res = await TaskService().fetchTodos();
      final listTask = res.map((e) => TaskModel.fromJson(e)).toList();
      emit(state.copyWith(listTask: listTask, todoStatus: Status.completed));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(todoStatus: Status.error));
    }
  }

  void fetchCompletedTodos() async {
    emit(state.copyWith(completedStatus: Status.loading));
    try {
      final res = await TaskService().fetchCompleted();
      final listTaskCompleted = res.map((e) => TaskModel.fromJson(e)).toList();
      emit(state.copyWith(
          listTaskCompleted: listTaskCompleted,
          completedStatus: Status.completed));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(completedStatus: Status.error));
    }
  }

  Future<void> updateTask(int id) async {
    try {
      await TaskService().updateTask(id);
      final task = state.listTask?.firstWhere((TaskModel e) => e.id == id);

      if (task != null) {
        final updatedListTodo = List<TaskModel>.from(state.listTask!);
        updatedListTodo.removeWhere((e) => e.id == id);

        final updatedListCompleted =
            List<TaskModel>.from(state.listTaskCompleted!);
        updatedListCompleted.add(task.copyWith(isCompleted: true));

        emit(HomeState(
          listTask: updatedListTodo,
          listTaskCompleted: updatedListCompleted,
        ));
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void addNewTask(TaskModel task) {
    final listTask = state.listTask;
    listTask?.add(task);
    emit(state.copyWith(listTask: listTask));
  }

  void resetAllState() {
    emit(HomeState());
  }

  Future logout() async {
    try {
      debugPrint("================LOGOUT================");
      resetAllState();
      return await AuthService().logout();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
