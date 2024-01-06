import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vmerge/src/app/app.dart';

final class AppCubit extends Cubit<AppState> {
  AppCubit(super.initialState);

  void toggleThemeMode({required ThemeMode themeMode}) {
    emit(state.copyWith(themeMode: themeMode));
  }

  void updateMainColor({required Color mainColor}) {
    emit(state.copyWith(mainColor: mainColor));
  }
}
