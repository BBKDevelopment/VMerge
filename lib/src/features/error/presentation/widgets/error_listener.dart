// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/error/error.dart';

part 'error_dialog.dart';

class ErrorListener extends StatelessWidget {
  const ErrorListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ErrorCubit(),
      child: _ErrorListener(child: child),
    );
  }
}

class _ErrorListener extends StatelessWidget {
  const _ErrorListener({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ErrorCubit, ErrorState>(
      listener: (context, state) {
        switch (state) {
          case ErrorIdle():
            break;
          case ErrorCaught():
            showDialog<void>(
              context: context,
              builder: (_) => _ErrorDialog(
                message: state.message,
                error: state.error,
                stackTrace: state.stackTrace,
              ),
            ).then((_) => context.read<ErrorCubit>().reset());
        }
      },
      child: child,
    );
  }
}
