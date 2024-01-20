import 'package:flutter/material.dart';
import 'package:vmerge/src/core/core.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  const CustomDropdownButton({
    required this.items,
    this.value,
    this.tooltip,
    this.onChanged,
    super.key,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String? tooltip;
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
      child: SizedBox(
        height: kMinInteractiveDimension,
        child: Row(
          children: [
            items
                .firstWhere(
                  (item) => item.value == value,
                  orElse: () => items.first,
                )
                .child,
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
