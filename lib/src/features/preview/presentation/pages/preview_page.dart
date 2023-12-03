// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vmerge/components/components.dart';
import 'package:vmerge/src/features/navigation/navigation.dart';
import 'package:vmerge/src/features/preview/preview.dart';
import 'package:vmerge/utilities/utilities.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PreviewCubit>(
      create: (_) => PreviewCubit(const PreviewLoading()),
      child: const _PreviewView(),
    );
  }
}

class _PreviewView extends StatelessWidget {
  const _PreviewView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PreviewCubit, PreviewState>(
      listener: (context, state) async {
        switch (state) {
          case PreviewLoading():
            final assets = await AssetPicker.pickAssets(
              context,
              pickerConfig: AssetPickerConfig(
                maxAssets: 2,
                requestType: RequestType.video,
                pickerTheme: appTheme,
                textDelegate: const EnglishAssetPickerTextDelegate(),
              ),
            );

            if (!context.mounted) return;

            await context.read<PreviewCubit>().updateVideos(assets);
          case PreviewLoaded():
            if (!context.mounted) return;

            context.read<NavigationCubit>().updatePage(NavigationBarPage.edit);
          case PreviewError():
            break;
        }
      },
      child: const Scaffold(
        appBar: VMergeAppBar(),
      ),
    );
  }
}
