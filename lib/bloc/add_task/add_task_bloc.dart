import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app_flutter_bloc/bloc/add_task/add_task_state.dart';
import 'package:todo_app_flutter_bloc/model/task_model.dart';
import 'package:todo_app_flutter_bloc/service/task_service.dart';
import 'package:todo_app_flutter_bloc/utils/date_util.dart';

class AddTaskBloc extends Cubit<AddTaskState> {
  AddTaskBloc()
      : super(AddTaskState(
            status: AddTaskStatus.init,
            selectedButton: 1,
            formattedTime: DateFormat('H:mm a').format(DateTime.now())));

  void setSelected(int index) {
    emit(state.copyWith(selectedButton: index));
  }

  void setTimeSelected(TimeOfDay? time) {
    if (time != null) {
      emit(state.copyWith(formattedTime: timeFormatted(time)));
    }
  }

  Future<TaskModel?> addTask(String title, String notes, String date) async {
    try {
      if (title.isEmpty || notes.isEmpty) {
        emit(state.copyWith(status: AddTaskStatus.error));
      } else {
        emit(state.copyWith(status: AddTaskStatus.loading));

        final task = TaskModel(
          category: state.selectedButton,
          taskTitle: title,
          date: date.toReverseFormattedDateString()!,
          time: state.formattedTime.convertTo24HourFormat(),
          notes: notes,
          uid: Supabase.instance.client.auth.currentUser?.id ?? "",
          isCompleted: false,
        );
        final taskModel = await TaskService().addTask(task);
        emit(state.copyWith(status: AddTaskStatus.completed));
        return taskModel;
      }
    } catch (e) {
      emit(state.copyWith(status: AddTaskStatus.error));

      debugPrint("errror" + e.toString());
    }
    return null;
  }

  String timeFormatted(TimeOfDay time) {
    final now = DateTime.now();
    return DateFormat('H:mm a').format(
      DateTime(now.year, now.month, now.day, time.hour, time.minute),
    );
  }
}
