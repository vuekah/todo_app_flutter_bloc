import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app_flutter_bloc/l10n/language_bloc.dart';
import 'package:todo_app_flutter_bloc/bloc/home/home_bloc.dart';
import 'package:todo_app_flutter_bloc/pages/splash_page.dart';
import 'package:todo_app_flutter_bloc/theme/color_style.dart';
import 'package:todo_app_flutter_bloc/theme/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String anonKey =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRxd2J0ZWppeHpuaG1veGl0Z2NrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA3MDgwOTMsImV4cCI6MjA0NjI4NDA5M30.uhOegJf5C6ojGpk3pi34hkFMLASW_TpK8hNDld7QpJo";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://tqwbtejixznhmoxitgck.supabase.co',
    anonKey: anonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageBloc()),
        BlocProvider(create: (_) => HomeBloc())
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return MaterialApp(
            locale: state.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate
            ],
            supportedLocales: LocaleSupport.localeSupport,
            theme: ThemeData(
                appBarTheme: const AppBarTheme(
                    backgroundColor: MyAppColors.backgroundColor,
                    titleTextStyle: MyAppStyles.titleAppbarTextStyle)),
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
