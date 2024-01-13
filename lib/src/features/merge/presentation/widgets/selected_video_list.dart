part of '../pages/merge_page.dart';

class _SelectedVideoList extends StatelessWidget {
  const _SelectedVideoList({required this.animation});

  final Animation<double> animation;

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
            case MergeLoading():
              return const Center(
                child: CircularProgressIndicator(),
              );
            case MergeLoaded():
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  return _VideoThumbnail(
                    animation: animation,
                    index: index,
                    metadata: state.metadatas[index],
                  );
                },
              );
            case MergeError():
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
