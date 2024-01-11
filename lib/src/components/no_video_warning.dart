import 'package:flutter/material.dart';
import 'package:vmerge/src/core/core.dart';

class NoVideoWarning extends StatelessWidget {
  const NoVideoWarning({
    super.key,
    this.onOpenPicker,
  });

  final VoidCallback? onOpenPicker;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.horizontalMedium,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.error.svg(
            height: AppIconSize.large,
            colorFilter: ColorFilter.mode(
              context.colorScheme.error,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: AppPadding.xLarge),
          Text(
            context.l10n.selectTwoVideosMessage,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppPadding.large),
          OutlinedButton(
            onPressed: onOpenPicker,
            child: Text(context.l10n.openPicker),
          ),
        ],
      ),
    );
  }
}
