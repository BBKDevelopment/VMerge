import 'package:flutter/material.dart';
import 'package:vmerge/src/core/core.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  CustomDropdownButton({
    required this.items,
    this.value,
    this.tooltip,
    this.padding,
    this.onChanged,
    super.key,
  }) : assert(
          items.isEmpty ||
              value == null ||
              items.where((item) => item.value == value).length == 1,
          'There should be exactly one item with [CustomDropdownButton]s value:'
          ' $value. \n'
          'Either zero or 2 or more [DropdownMenuItem]s were detected with the '
          'same value',
        );

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String? tooltip;
  final EdgeInsetsGeometry? padding;
  final void Function(T?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      itemBuilder: (context) {
        return [
          for (final item in items)
            PopupMenuItem<T>(
              value: item.value,
              enabled: item.enabled,
              labelTextStyle: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.disabled)) {
                  return Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.38),
                      );
                }

                return Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    );
              }),
              child: item.child,
            ),
        ];
      },
      onSelected: (ratio) => onChanged?.call(ratio),
      tooltip: tooltip ?? '',
      padding: padding ?? const EdgeInsets.all(8),
      offset: Offset(
        0,
        -(items.length - 1) * kMinInteractiveDimension -
            (padding?.vertical ?? 8),
      ),
      child: SizedBox(
        height: kMinInteractiveDimension,
        child: Row(
          children: [
            DefaultTextStyle(
              style:
                  Theme.of(context).textTheme.titleMedium ?? const TextStyle(),
              child: items
                  .firstWhere(
                    (item) => item.value == value,
                    orElse: () => items.first,
                  )
                  .child,
            ),
            Icon(
              Icons.arrow_drop_down,
              color: context.colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
