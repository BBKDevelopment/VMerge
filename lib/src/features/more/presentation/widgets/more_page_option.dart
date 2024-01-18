// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/more_page.dart';

class _MorePageOption extends StatelessWidget {
  const _MorePageOption({
    required this.option,
    required this.animation,
  });

  final MorePageOption option;
  final Animation<double> animation;

  void _onTapOption(BuildContext context) {
    switch (option) {
      case MorePageOption.theme:
        showCupertinoModalBottomSheet<void>(
          context: context,
          useRootNavigator: true,
          topRadius: Radius.zero,
          builder: (_) => BlocProvider.value(
            value: BlocProvider.of<MoreCubit>(context),
            child: const Material(child: _ThemeBottomSheet()),
          ),
        );
      case MorePageOption.rateUs:
        getIt<LaunchReviewService>()
            .launch()
            .onError<LaunchReviewException>((error, stackTrace) {
          context.read<ErrorCubit>().catched(
                message:
                    'Could not launch review service! Please check your internet connection and try again.',
                error: '$error',
                stackTrace: '$stackTrace',
              );
        });
      case MorePageOption.contactUs:
        getIt<UrlLauncherService>()
            .sendEmail(
          emailUri: Uri(
            scheme: 'mailto',
            path: 'info@bbkdevelopment.com',
            queryParameters: {'subject': 'VMerge'},
          ),
        )
            .onError<SendEmailException>((error, stackTrace) {
          context.read<ErrorCubit>().catched(
                message:
                    'Could not launch email service! Please check your internet connection and try again.',
                error: '$error',
                stackTrace: '$stackTrace',
              );
        });
      case MorePageOption.termsAndConditions:
        getIt<UrlLauncherService>()
            .launch(url: Uri(path: kTermsAndConditions))
            .onError<UrlLaunchException>((error, stackTrace) {
          context.read<ErrorCubit>().catched(
                message:
                    'Could not launch url! Please check your internet connection and try again.',
                error: '$error',
                stackTrace: '$stackTrace',
              );
        });
      case MorePageOption.privacyPolicy:
        getIt<UrlLauncherService>()
            .launch(url: Uri(path: kPrivacyPolicy))
            .onError<UrlLaunchException>((error, stackTrace) {
          context.read<ErrorCubit>().catched(
                message:
                    'Could not launch url! Please check your internet connection and try again.',
                error: '$error',
                stackTrace: '$stackTrace',
              );
        });
      case MorePageOption.licenses:
        showLicensePage(
          context: context,
          applicationName: context.l10n.appName,
          applicationIcon: Padding(
            padding: AppPadding.verticalLarge,
            child: Assets.images.vmerge.svg(
              width: AppIconSize.xxLarge,
              colorFilter: ColorFilter.mode(
                context.theme.iconTheme.color!,
                BlendMode.srcIn,
              ),
            ),
          ),
          applicationVersion: '_packageInfo.version',
          applicationLegalese: context.l10n.copyrightMessage,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Interval(
              0,
              (option.index + 1) / MorePageOption.values.length,
              curve: Curves.easeOut,
            ),
          ),
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, -0.2),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Interval(
                  0,
                  (option.index + 1) / MorePageOption.values.length,
                  curve: Curves.easeOut,
                ),
              ),
            ),
            child: child,
          ),
        );
      },
      child: ListTile(
        contentPadding: AppPadding.verticalXSmall,
        leading: Hero(
          tag: option.name,
          child: SvgPicture.asset(
            option.assetPath,
            width: AppIconSize.small,
            fit: BoxFit.fitWidth,
            colorFilter: ColorFilter.mode(
              context.theme.iconTheme.color!,
              BlendMode.srcIn,
            ),
          ),
        ),
        title: Text(
          option.title(context),
        ),
        onTap: () => _onTapOption(context),
      ),
    );
  }
}