// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:bloc/bloc.dart';
import 'package:vmerge/src/features/error/error.dart';

final class ErrorCubit extends Cubit<ErrorState> {
  ErrorCubit() : super(const ErrorIdle());

  void caught({
    required String message,
    required Object error,
    required StackTrace stackTrace,
  }) {
    emit(ErrorCaught(message: message, error: error, stackTrace: stackTrace));
  }

  void reset() {
    emit(const ErrorIdle());
  }
}
