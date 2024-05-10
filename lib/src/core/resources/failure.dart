// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:equatable/equatable.dart';

final class Failure extends Equatable {
  const Failure(
    this.message, {
    required this.name,
    required this.error,
    required this.stackTrace,
  });

  final String message;

  final String name;

  final Object error;

  final StackTrace stackTrace;

  @override
  List<Object?> get props => [message, name, error, stackTrace];
}
