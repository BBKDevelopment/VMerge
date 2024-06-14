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
    final l10n = context.l10n;

    switch (option) {
      case MorePageOption.theme:
        // `showModalBottomSheet` is not used here since it does not support
        // `Hero` animations. Please see: https://github.com/flutter/flutter/issues/48467
        showCupertinoModalBottomSheet<void>(
          context: context,
          useRootNavigator: true,
          topRadius: const Radius.circular(AppBorderRadius.xxxLarge),
          builder: (_) {
            return BlocProvider.value(
              value: BlocProvider.of<AppCubit>(context),
              // Default `showModalBottomSheet` and dialogs use
              // `dialogBackgroundColor` and `surfaceTintColor`, so `Card` is
              // used here to match the design because it uses the same colors.
              child: const Card(
                margin: EdgeInsets.zero,
                shape: ContinuousRectangleBorder(),
                child: _ThemeBottomSheet(),
              ),
            );
          },
        );
      case MorePageOption.faq:
        // `showModalBottomSheet` is not used here since it does not support
        // `Hero` animations. Please see: https://github.com/flutter/flutter/issues/48467
        showCupertinoModalBottomSheet<void>(
          context: context,
          useRootNavigator: true,
          topRadius: const Radius.circular(AppBorderRadius.xxxLarge),
          builder: (_) {
            return BlocProvider.value(
              value: BlocProvider.of<AppCubit>(context),
              // Default `showModalBottomSheet` and dialogs use
              // `dialogBackgroundColor` and `surfaceTintColor`, so `Card` is
              // used here to match the design because it uses the same colors.
              child: const Card(
                margin: EdgeInsets.zero,
                shape: ContinuousRectangleBorder(),
                child: _FaqBottomSheet(),
              ),
            );
          },
        );
      case MorePageOption.rateUs:
        getIt<LaunchReviewService>()
            .launch()
            .onError<LaunchReviewException>((error, stackTrace) {
          context.read<ErrorCubit>().caught(
                message: l10n.couldNotLaunchReviewServiceMessage,
                error: error,
                stackTrace: stackTrace,
              );
        });
      case MorePageOption.contactUs:
        getIt<UrlLauncherService>()
            .sendEmail(
          emailUri: Uri(
            scheme: 'mailto',
            path: AppConfig.contactEmail,
            queryParameters: {'subject': AppConfig.appName},
          ),
        )
            .onError<SendEmailException>((error, stackTrace) {
          context.read<ErrorCubit>().caught(
                message: l10n.couldNotLaunchEmailServiceMessage,
                error: error,
                stackTrace: stackTrace,
              );
        });
      case MorePageOption.termsAndConditions:
        getIt<UrlLauncherService>()
            .launch(url: Uri.parse(AppConfig.termsAndConditions))
            .onError<UrlLaunchException>((error, stackTrace) {
          context.read<ErrorCubit>().caught(
                message: l10n.couldNotOpenTermsAndConditionsMessage,
                error: error,
                stackTrace: stackTrace,
              );
        });
      case MorePageOption.privacyPolicy:
        getIt<UrlLauncherService>()
            .launch(url: Uri.parse(AppConfig.privacyPolicy))
            .onError<UrlLaunchException>((error, stackTrace) {
          context.read<ErrorCubit>().caught(
                message: l10n.couldNotOpenPrivacyPolicyMessage,
                error: error,
                stackTrace: stackTrace,
              );
        });
      case MorePageOption.licenses:
        showLicensePage(
          context: context,
          applicationName: context.l10n.appName,
          applicationIcon: Padding(
            padding: AppPadding.verticalMedium,
            child: Assets.images.vmerge.image(
              width: AppIconSize.xxLarge,
            ),
          ),
          applicationVersion: getIt<PackageInfo>().version,
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
