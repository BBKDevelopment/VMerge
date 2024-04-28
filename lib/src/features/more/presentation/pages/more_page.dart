// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:launch_review_service/launch_review_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher_service/url_launcher_service.dart';
import 'package:vmerge/bootstrap.dart';
import 'package:vmerge/src/app/app.dart';
import 'package:vmerge/src/components/components.dart';
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/error/error.dart';

part '../widgets/copyright_text.dart';
part '../widgets/more_page_option.dart';
part '../widgets/theme_bottom_sheet.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MoreView();
  }
}

class _MoreView extends StatefulWidget {
  const _MoreView();

  @override
  State<_MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends State<_MoreView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppAnimationDuration.long,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.appName),
      body: Padding(
        padding: AppPadding.general,
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: MorePageOption.values.length + 1,
                itemBuilder: (context, index) {
                  return index == MorePageOption.values.length
                      ? const SizedBox.shrink()
                      : _MorePageOption(
                          option: MorePageOption.values[index],
                          animation: _animation,
                        );
                },
                separatorBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _animation,
                    builder: (_, child) {
                      return FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _animation,
                          curve: Interval(
                            1 / MorePageOption.values.length,
                            (index + 1) / MorePageOption.values.length,
                            curve: Curves.easeOut,
                          ),
                        ),
                        child: child,
                      );
                    },
                    child: const Divider(
                      thickness: 1,
                      height: 0,
                    ),
                  );
                },
              ),
            ),
            _CopyrightText(
              animation: _animation,
            ),
          ],
        ),
      ),
    );
  }
}

enum MorePageOption {
  theme,
  rateUs,
  contactUs,
  termsAndConditions,
  privacyPolicy,
  licenses;

  String get assetPath {
    switch (this) {
      case MorePageOption.theme:
        return Assets.images.palette.path;
      case MorePageOption.rateUs:
        return Assets.images.star.path;
      case MorePageOption.contactUs:
        return Assets.images.mail.path;
      case MorePageOption.termsAndConditions:
        return Assets.images.description.path;
      case MorePageOption.privacyPolicy:
        return Assets.images.privacy.path;
      case MorePageOption.licenses:
        return Assets.images.license.path;
    }
  }

  String title(BuildContext context) {
    final l10n = context.l10n;

    switch (this) {
      case MorePageOption.theme:
        return l10n.theme;
      case MorePageOption.rateUs:
        return l10n.rateUs;
      case MorePageOption.contactUs:
        return l10n.contactUs;
      case MorePageOption.termsAndConditions:
        return l10n.termsAndConditions;
      case MorePageOption.privacyPolicy:
        return l10n.privacyPolicy;
      case MorePageOption.licenses:
        return l10n.licenses;
    }
  }
}
