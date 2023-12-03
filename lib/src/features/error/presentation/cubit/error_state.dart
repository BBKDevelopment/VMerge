// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:equatable/equatable.dart';

sealed class ErrorState extends Equatable {
  const ErrorState();
}

final class ErrorInitial extends ErrorState {
  const ErrorInitial();

  @override
  List<Object> get props => [];
}

final class ErrorCatched extends ErrorState {
  const ErrorCatched({
    required this.error,
    required this.stackTrace,
    required this.message,
  });

  final String message;
  final String error;
  final String stackTrace;

  @override
  List<Object> get props => [
        message,
        error,
        stackTrace,
      ];
}
