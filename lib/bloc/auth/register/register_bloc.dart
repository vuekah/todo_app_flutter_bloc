import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_flutter_bloc/bloc/auth/register/register_state.dart';
import 'package:todo_app_flutter_bloc/service/auth_service.dart';

class RegisterBloc extends Cubit<RegisterState> {
  RegisterBloc() : super(RegisterState());

  void changeStateObscurePassword() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void changeStateObscureRePassword() {
    emit(state.copyWith(obscureRePassword: !state.obscureRePassword));
  }

  Future register(String usr, String pwd, String rePwd) async {
    try {
      if (usr.isNotEmpty && pwd.isNotEmpty && rePwd.isNotEmpty) {
        if (pwd == rePwd) {
          emit(state.copyWith(registerStatus: RegisterStatus.loading));
          final username = "$usr@gmail.com";
          final response = await AuthService().register(username, pwd);
          if (response.user != null) {
            emit(state.copyWith(registerStatus: RegisterStatus.success));
          } else {
            emit(state.copyWith(
                registerStatus: RegisterStatus.error,
                registerErrorMessage: RegisterErrorMessage.errorSomething));
          }
        } else {
          emit(state.copyWith(
              registerStatus: RegisterStatus.error,
              registerErrorMessage: RegisterErrorMessage.errorRePassword));

          //showing not match
        }
      } else {
        emit(state.copyWith(
            registerStatus: RegisterStatus.error,
            registerErrorMessage: RegisterErrorMessage.emptyFieldError));
      }
    } catch (e) {
      emit(state.copyWith(
          registerStatus: RegisterStatus.error,
          registerErrorMessage: RegisterErrorMessage.errorSomething));
    }
  }
}
