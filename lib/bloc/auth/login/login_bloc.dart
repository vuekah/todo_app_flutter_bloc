import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_flutter_bloc/bloc/auth/login/login_state.dart';
import 'package:todo_app_flutter_bloc/service/auth_service.dart';

class LoginBloc extends Cubit<LoginState> {
  LoginBloc() : super(const LoginState());

  void changeStateObscurePassword() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  Future<void> login(String usr, String pwd) async {
    try {
      if (usr.isNotEmpty && pwd.isNotEmpty) {
        emit(state.copyWith(loginStatus: LoginStatus.loading));
        final username = "$usr@gmail.com";
        final response = await AuthService().login(username, pwd);

        if (response.user != null) {
          emit(state.copyWith(loginStatus: LoginStatus.success));
        } else {
          emit(state.copyWith(
            loginStatus: LoginStatus.error,
            errorLogin: LoginError.error,
          ));
        }
      } else {
        emit(state.copyWith(
          loginStatus: LoginStatus.error,
          errorLogin: LoginError.emptyField,
        ));
      }
    } catch (e) {
      debugPrint("error login ${e.toString()}");
      // emit(state.copyWith(
      //   loginStatus: LoginStatus.error,
      //   errorLogin: LoginError.invalidCredential,
      // ));
    }
  }
}
