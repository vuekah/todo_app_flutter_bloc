import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_flutter_bloc/common/widgets/button_widget.dart';
import 'package:todo_app_flutter_bloc/common/widgets/textfield_widget.dart';
import 'package:todo_app_flutter_bloc/l10n/language_bloc.dart';
import 'package:todo_app_flutter_bloc/bloc/auth/login/login_bloc.dart';
import 'package:todo_app_flutter_bloc/bloc/auth/login/login_state.dart';
import 'package:todo_app_flutter_bloc/pages/auth/register/register_page.dart';
import 'package:todo_app_flutter_bloc/pages/home/home_page.dart';
import 'package:todo_app_flutter_bloc/utils/dimens_util.dart';
import 'package:todo_app_flutter_bloc/gen/fonts.gen.dart';
import 'package:todo_app_flutter_bloc/theme/color_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimens.init(context);
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                BlocProvider.of<LanguageBloc>(context).changeLanguage();
              },
              icon: const Icon(
                Icons.language,
                size: 30,
                color: MyAppColors.whiteColor,
              ),
            ),
          ),
          backgroundColor: MyAppColors.backgroundColor,
          body: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.loginStatus == LoginStatus.error) {
                switch (state.errorLogin) {
                  case LoginError.error:
                    _showSnackbar(
                        context, AppLocalizations.of(context)!.errorSomething);
                    break;
                  case LoginError.emptyField:
                    _showSnackbar(
                        context, AppLocalizations.of(context)!.emptyFieldError);
                    break;
                  case LoginError.invalidCredential:
                    _showSnackbar(context,
                        AppLocalizations.of(context)!.loginInvalidCredentials);
                    break;
                  default:
                    break;
                }
              }
              if (state.loginStatus == LoginStatus.success) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomePage()));
              }
            },
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: MyAppColors.whiteColor,
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFieldWidget(
                      hint: AppLocalizations.of(context)!.username,
                      controller: _usernameController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildPasswordField(context),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildLoginButton(context),
                    const SizedBox(
                      height: 30,
                    ),
                    _buildSignUpLink(),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.dontHaveAccount),
        const SizedBox(width: 2),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterPage()),
            );
          },
          child: Text(
            AppLocalizations.of(context)!.signUpTitle,
            style: const TextStyle(
              color: MyAppColors.backgroundColor,
              fontFamily: FontFamily.inter,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocSelector<LoginBloc, LoginState, LoginStatus>(
        selector: (selector) => selector.loginStatus,
        builder: (context, selector) {
          if (selector == LoginStatus.loading) {
            return const CircularProgressIndicator(
              color: MyAppColors.backgroundColor,
            );
          }
          return ButtonWidget(
            callback: () async {
              await _handleLogin(context);
            },
            title: AppLocalizations.of(context)!.signInTitle,
          );
        });
  }

  Future<void> _handleLogin(BuildContext context) async {
    await BlocProvider.of<LoginBloc>(context)
        .login(_usernameController.text, _passwordController.text);
  }

  Widget _buildPasswordField(BuildContext context) {
    return BlocSelector<LoginBloc, LoginState, bool>(
        selector: (state) => state.obscurePassword,
        builder: (context, state) {
          return TextFieldWidget(
            controller: _passwordController,
            hint: AppLocalizations.of(context)!.password,
            suffixIcon: GestureDetector(
              child: Icon(state ? Icons.visibility : Icons.visibility_off),
              onTap: () {
                BlocProvider.of<LoginBloc>(context)
                    .changeStateObscurePassword();
              },
            ),
            obscureText: state,
          );
        });
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
