import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_flutter_bloc/common/widgets/button_widget.dart';
import 'package:todo_app_flutter_bloc/common/widgets/textfield_widget.dart';
import 'package:todo_app_flutter_bloc/l10n/language_bloc.dart';
import 'package:todo_app_flutter_bloc/bloc/auth/register/register_bloc.dart';
import 'package:todo_app_flutter_bloc/bloc/auth/register/register_state.dart';
import 'package:todo_app_flutter_bloc/utils/dimens_util.dart';
import 'package:todo_app_flutter_bloc/gen/fonts.gen.dart';
import 'package:todo_app_flutter_bloc/theme/color_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimens.init(context);
    return BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(),
        child: Scaffold(
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
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(
                    Dimens.screenWidth > Dimens.screenHeight ? 35 : 8),
                child: BlocListener<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    if (state.registerStatus == RegisterStatus.error) {
                      switch (state.registerErrorMessage) {
                        case RegisterErrorMessage.errorSomething:
                          _showSnackbar(context,
                              AppLocalizations.of(context)!.errorSomething);
                          break;
                        case RegisterErrorMessage.errorRePassword:
                          _showSnackbar(context,
                              AppLocalizations.of(context)!.errorRePassword);
                          break;
                        case RegisterErrorMessage.emptyFieldError:
                          _showSnackbar(context,
                              AppLocalizations.of(context)!.emptyFieldError);
                          break;
                        default:
                          break;
                      }
                    } else if (state.registerStatus == RegisterStatus.success) {
                      _showSnackbar(context,
                          AppLocalizations.of(context)!.registerSuccess);
                      Navigator.pop(context);
                    }
                  },
                  child: _buildRegisterForm(context),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: MyAppColors.whiteColor,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildUsernameField(),
          const SizedBox(height: 20),
          _buildPasswordField(context),
          const SizedBox(height: 20),
          _buildConfirmPasswordField(context),
          const SizedBox(height: 20),
          _buildRegisterButton(context),
          const SizedBox(
            height: 30,
          ),
          _buildSignInLink(),
        ],
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFieldWidget(
      hint: AppLocalizations.of(context)!.username,
      controller: _usernameController,
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    debugPrint("rebuild _buildPasswordField");
    return BlocSelector<RegisterBloc, RegisterState, bool>(
      builder: (context, value) => TextFieldWidget(
        hint: AppLocalizations.of(context)!.password,
        controller: _passwordController,
        obscureText: value,
        suffixIcon: GestureDetector(
          onTap:
              BlocProvider.of<RegisterBloc>(context).changeStateObscurePassword,
          child: Icon(
            value ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
      selector: (value) => value.obscurePassword,
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    debugPrint("rebuild _buildConfirmPasswordField");
    return BlocSelector<RegisterBloc, RegisterState, bool>(
      builder: (context, value) => TextFieldWidget(
        hint: AppLocalizations.of(context)!.confirmPassword,
        controller: _rePasswordController,
        obscureText: value,
        suffixIcon: GestureDetector(
          onTap: BlocProvider.of<RegisterBloc>(context)
              .changeStateObscureRePassword,
          child: Icon(
            value ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
      selector: (value) => value.obscureRePassword,
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    debugPrint("rebuild _buildRegisterButton");
    return BlocSelector<RegisterBloc, RegisterState, RegisterStatus>(
        selector: (selector) => selector.registerStatus,
        builder: (context, selector) {
          if (selector == RegisterStatus.loading) {
            return const CircularProgressIndicator(
              color: MyAppColors.backgroundColor,
            );
          }
          return ButtonWidget(
            callback: () async {
              await _handleRegister(context);
            },
            title: AppLocalizations.of(context)!.signUpTitle,
          );
        });
  }

  Widget _buildSignInLink() {
    debugPrint("rebuild _buildSignInLink");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.alreadyHaveAccount),
        const SizedBox(width: 2),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            AppLocalizations.of(context)!.signInTitle,
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

  Future<void> _handleRegister(BuildContext context) async {
    await BlocProvider.of<RegisterBloc>(context).register(
      _usernameController.text,
      _passwordController.text,
      _rePasswordController.text,
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
