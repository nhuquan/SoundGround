import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sound_ground/src/bloc/language/language_cubit.dart';
import 'package:sound_ground/src/bloc/theme/theme_bloc.dart';
import 'package:sound_ground/src/core/router/app_router.dart';
import 'package:sound_ground/src/core/theme/app_theme_data.dart';
import 'package:sound_ground/src/l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LanguageCubit, Locale>(
          builder: (context, lang) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'SoundGround',
              theme: AppThemeData.getTheme(),
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                Locale('en'), // English
                Locale('vi'), // Vietnamese
              ],
              locale: lang,
              onGenerateRoute: (settings) => AppRouter.generateRoute(settings),
            );
          },
        );
      },
    );
  }
}
