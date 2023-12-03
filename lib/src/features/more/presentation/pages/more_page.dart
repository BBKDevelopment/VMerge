// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:launch_review_service/launch_review_service.dart';
import 'package:url_launcher_service/url_launcher_service.dart';
import 'package:vmerge/bootstrap.dart';
import 'package:vmerge/components/components.dart';
import 'package:vmerge/src/features/error/error.dart';
import 'package:vmerge/utilities/utilities.dart';

part '../widgets/copyright_text.dart';
part '../widgets/more_page_options.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: kMorePageInAnimationDuration,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VMergeAppBar(),
      body: Container(
        color: kPrimaryColorDark,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        width: double.infinity,
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
                  return const Divider(
                    color: kPrimaryColor,
                    thickness: 1,
                    height: 4,
                  );
                },
              ),
            ),
            _CopyrightText(animation: _animation),
          ],
        ),
      ),
    );
  }
}

enum MorePageOption {
  rateUs,
  contactUs,
  termsAndConditions,
  privacyPolicy,
  licenses,
}
