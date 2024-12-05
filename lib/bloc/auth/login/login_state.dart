
enum LoginStatus { init, loading, success, error }

enum LoginError { init, error, invalidCredential, emptyField }

class LoginState {
  const LoginState({
    this.loginStatus = LoginStatus.init,
    this.errorLogin = LoginError.init,
    this.obscurePassword = true,
  });
  final LoginStatus loginStatus;
  final LoginError errorLogin;
  final bool obscurePassword;

  LoginState copyWith({
    LoginStatus? loginStatus,
    LoginError? errorLogin,
    bool? obscurePassword,
  }) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      errorLogin: errorLogin ?? this.errorLogin,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}
