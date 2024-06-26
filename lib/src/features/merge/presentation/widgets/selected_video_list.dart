// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/merge_page.dart';

class _SelectedVideoList extends StatelessWidget {
  const _SelectedVideoList({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenWidth / 4,
      child: BlocBuilder<MergePageCubit, MergePageState>(
        buildWhen: (previous, current) {
          if (previous is MergePageLoaded && current is MergePageLoaded) {
            return false;
          }

          return true;
        },
        builder: (context, state) {
          switch (state) {
            case MergePageInitial():
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (_, index) {
                  return _VideoThumbnail(
                    animation: animation,
                    index: index,
                  );
                },
                separatorBuilder: (_, __) {
                  return const SizedBox(width: AppPadding.medium);
                },
              );
            case MergePageLoading():
              return const Center(
                child: CircularProgressIndicator(),
              );
            case MergePageLoaded():
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: state.videoMetadatas.length,
                itemBuilder: (_, index) {
                  return _VideoThumbnail(
                    animation: animation,
                    index: index,
                    metadata: state.videoMetadatas[index],
                  );
                },
                separatorBuilder: (_, __) {
                  return const SizedBox(width: AppPadding.medium);
                },
              );
            case MergePageError():
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
