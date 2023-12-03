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
        if (!context.mounted) return;

        showLicensePage(
          context: context,
          applicationName: kAppName,
          applicationIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SvgPicture.asset(kAppLogoPath, height: kIconSize * 4),
          ),
          applicationVersion: '_packageInfo.version',
          applicationLegalese: kCopyrightText,
        );
    }
  }

  String get _getOptionAssetPath {
    switch (option) {
      case MorePageOption.rateUs:
        return kStarIconPath;
      case MorePageOption.contactUs:
        return kMailIconPath;
      case MorePageOption.termsAndConditions:
        return kTermsIconPath;
      case MorePageOption.privacyPolicy:
        return kPrivacyIconPath;
      case MorePageOption.licenses:
        return kLicenseIconPath;
    }
  }

  String get _getOptionTitle {
    switch (option) {
      case MorePageOption.rateUs:
        return kRateText;
      case MorePageOption.contactUs:
        return kContactsText;
      case MorePageOption.termsAndConditions:
        return kTermsText;
      case MorePageOption.privacyPolicy:
        return kPrivacyText;
      case MorePageOption.licenses:
        return kLicenseText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(1.2, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(
                option.index / MorePageOption.values.length / 2,
                (option.index + 1) / MorePageOption.values.length / 2,
                curve: Curves.easeInOutCubic,
              ),
            ),
          ),
          child: child,
        );
      },
      child: ListTile(
        leading: SvgPicture.asset(
          _getOptionAssetPath,
        ),
        title: Text(
          _getOptionTitle,
          style: kSemiBoldTextStyle,
        ),
        onTap: () => _onTapOption(context),
      ),
    );
  }
}
