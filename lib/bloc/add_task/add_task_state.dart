enum AddTaskStatus { init, loading, completed, error }

class AddTaskState {
  AddTaskState({
    required this.status,
    required this.selectedButton,
    required this.formattedTime,
  });
  final AddTaskStatus status;
  final int selectedButton;
  final String formattedTime;

  AddTaskState copyWith({
    AddTaskStatus? status,
    int? selectedButton,
    String? formattedTime,
  }) {
    return AddTaskState(
      status: status ?? this.status,
      selectedButton: selectedButton ?? this.selectedButton,
      formattedTime: formattedTime ?? this.formattedTime,
    );
  }
}
