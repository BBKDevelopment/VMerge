import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/more/more.dart';

final class MoreCubit extends Cubit<MoreState> {
  MoreCubit(super.initialState);

  void toggleDarkMode({required bool isDarkModeEnabled}) {
    emit(state.copyWith(isDarkModeEnabled: isDarkModeEnabled));
  }

  void updateMainColor({required AppMainColor mainColor}) {
    emit(state.copyWith(mainColor: mainColor));
  }
}
