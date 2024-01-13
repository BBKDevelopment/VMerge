part of '../pages/merge_page.dart';

class _SelectedVideoList extends StatelessWidget {
  const _SelectedVideoList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: BlocBuilder<MergeCubit, MergeState>(
        builder: (context, state) {
          switch (state) {
            case MergeInitial():
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (_, __) {
                  return const VideoThumbnail();
                },
                separatorBuilder: (_, __) {
                  return const SizedBox(width: AppPadding.medium);
                },
              );
            case MergeLoading():
              return const Center(
                child: CircularProgressIndicator(),
              );
            case MergeLoaded():
              return ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final metadata in state.metadatas)
                    VideoThumbnail(metadata: metadata),
                ],
              );
            case MergeError():
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
