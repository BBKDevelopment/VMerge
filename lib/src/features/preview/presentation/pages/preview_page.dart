// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vmerge/components/components.dart';
import 'package:vmerge/src/components/components.dart';
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/navigation/navigation.dart';
import 'package:vmerge/src/features/preview/preview.dart';
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

class _PreviewView extends StatefulWidget {
  const _PreviewView();

  @override
  State<_PreviewView> createState() => _PreviewViewState();
}

class _PreviewViewState extends State<_PreviewView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openAssetsPicker();
    });
  }

  Future<void> _openAssetsPicker() async {
    List<AssetEntity>? assets;
    try {
      assets = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: 4,
          requestType: RequestType.video,
          pickerTheme: context.theme,
          textDelegate: const EnglishAssetPickerTextDelegate(),
        ),
      );
    } catch (_) {
      assets = null;
    }

    if (!context.mounted) return;

    await context.read<PreviewCubit>().updateVideos(assets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.appName),
      body: BlocConsumer<PreviewCubit, PreviewState>(
        listener: (context, state) {
          switch (state) {
            case PreviewLoading():
              _openAssetsPicker();
            case PreviewLoaded():
              context
                  .read<NavigationCubit>()
                  .updatePage(NavigationBarPage.edit);
            case PreviewError():
              break;
          }
        },
        builder: (context, state) {
          switch (state) {
            case PreviewLoading():
              return Center(
                child: SizedBox.square(
                  dimension: context.screenWidth / 4 / 3,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.theme.iconTheme.color!,
                    ),
                  ),
                ),
              );
            case PreviewLoaded():
              return const SizedBox.shrink();
            case PreviewError():
              return NoVideoWarning(
                onOpenPicker: _openAssetsPicker,
              );
          }
        },
      ),
    );
  }
}
