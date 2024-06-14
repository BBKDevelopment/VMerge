// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/more_page.dart';

class _FaqBottomSheet extends StatelessWidget {
  const _FaqBottomSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final faqQuestions = [
      l10n.faqQuestion1,
      l10n.faqQuestion2,
      l10n.faqQuestion3,
      l10n.faqQuestion4,
      l10n.faqQuestion5,
      l10n.faqQuestion6,
      l10n.faqQuestion7,
      l10n.faqQuestion8,
      l10n.faqQuestion9,
      l10n.faqQuestion10,
      l10n.faqQuestion11,
      l10n.faqQuestion12,
      l10n.faqQuestion13,
      l10n.faqQuestion14,
      l10n.faqQuestion15,
      l10n.faqQuestion16,
      l10n.faqQuestion17,
      l10n.faqQuestion18,
      l10n.faqQuestion19,
      l10n.faqQuestion20,
      l10n.faqQuestion21,
      l10n.faqQuestion22,
      l10n.faqQuestion23,
      l10n.faqQuestion24,
      l10n.faqQuestion25,
      l10n.faqQuestion26,
      l10n.faqQuestion27,
      l10n.faqQuestion28,
      l10n.faqQuestion29,
      l10n.faqQuestion30,
      l10n.faqQuestion31,
    ];
    final faqAnswers = [
      l10n.faqAnswer1,
      l10n.faqAnswer2,
      l10n.faqAnswer3,
      l10n.faqAnswer4,
      l10n.faqAnswer5,
      l10n.faqAnswer6,
      l10n.faqAnswer7,
      l10n.faqAnswer8,
      l10n.faqAnswer9,
      l10n.faqAnswer10,
      l10n.faqAnswer11,
      l10n.faqAnswer12,
      l10n.faqAnswer13,
      l10n.faqAnswer14,
      l10n.faqAnswer15,
      l10n.faqAnswer16,
      l10n.faqAnswer17,
      l10n.faqAnswer18,
      l10n.faqAnswer19,
      l10n.faqAnswer20,
      l10n.faqAnswer21,
      l10n.faqAnswer22,
      l10n.faqAnswer23,
      l10n.faqAnswer24,
      l10n.faqAnswer25,
      l10n.faqAnswer26,
      l10n.faqAnswer27,
      l10n.faqAnswer28,
      l10n.faqAnswer29,
      l10n.faqAnswer30,
      l10n.faqAnswer31,
    ];

    return Padding(
      padding: AppPadding.allLarge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: AppButtonSize.small),
              Hero(
                tag: MorePageOption.faq.name,
                child: Assets.images.faq.svg(
                  height: AppIconSize.xLarge,
                  colorFilter: ColorFilter.mode(
                    context.theme.iconTheme.color!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox.square(
                dimension: AppButtonSize.small,
                child: IconButton.filledTonal(
                  onPressed: context.pop,
                  icon: Assets.images.close.svg(
                    height: AppIconSize.xxSmall,
                    colorFilter: ColorFilter.mode(
                      context.colorScheme.onSecondaryContainer,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: AppPadding.medium,
          ),
          Text(
            context.l10n.faq,
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(
            height: AppPadding.xLarge,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: faqQuestions.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  tilePadding: AppPadding.verticalSmall,
                  childrenPadding: AppPadding.bottomMedium,
                  title: Text(
                    '${index + 1}. ${faqQuestions[index]}',
                  ),
                  children: [
                    Text(faqAnswers[index]),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
