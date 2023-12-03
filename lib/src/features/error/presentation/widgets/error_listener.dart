// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vmerge/src/features/error/error.dart';
import 'package:vmerge/utilities/utilities.dart';

part 'error_modal_bottom_sheet.dart';

class ErrorListener extends StatelessWidget {
  const ErrorListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ErrorCubit, ErrorState>(
      listener: (context, state) {
        switch (state) {
          case ErrorInitial():
            break;
          case ErrorCatched():
            showModalBottomSheet<void>(
              backgroundColor: Colors.transparent,
              context: context,
              useRootNavigator: true,
              elevation: 4,
              isDismissible: false,
              builder: (_) => _ErrorModalBottomSheet(
                message: state.message,
                error: state.error,
                stackTrace: state.stackTrace,
              ),
            ).then((_) => context.read<ErrorCubit>().reset());
        }
      },
      child: Container(),
    );
  }
}
