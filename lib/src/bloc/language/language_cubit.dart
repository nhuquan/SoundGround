import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(Locale('en', '')) {
    changeStartLang();
  }

  void changeStartLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('lang');
    print(langCode);
    if (langCode != null) {
      emit(Locale(langCode, ''));
    }
  }

  void changeLang(String data) async {
    emit(Locale(data, ''));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', data);
  }
}
