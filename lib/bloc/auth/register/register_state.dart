
enum RegisterStatus { init, loading, success, error }

enum RegisterErrorMessage {
  init,
  errorSomething,
  errorRePassword,
  emptyFieldError
}

class RegisterState {
  RegisterState({
    this.registerStatus = RegisterStatus.init,
    this.registerErrorMessage = RegisterErrorMessage.init,
    this.obscurePassword = true,
    this.obscureRePassword = true,
  });
  final RegisterStatus registerStatus;
  final RegisterErrorMessage registerErrorMessage;
  final bool obscurePassword;
  final bool obscureRePassword;

  RegisterState copyWith(
          {RegisterStatus? registerStatus,
          RegisterErrorMessage? registerErrorMessage,
          bool? obscurePassword,
          bool? obscureRePassword}) =>
      RegisterState(
          registerStatus: registerStatus ?? this.registerStatus,
          registerErrorMessage:
              registerErrorMessage ?? this.registerErrorMessage,
          obscurePassword: obscurePassword ?? this.obscurePassword,
          obscureRePassword: obscureRePassword ?? this.obscureRePassword);
}
