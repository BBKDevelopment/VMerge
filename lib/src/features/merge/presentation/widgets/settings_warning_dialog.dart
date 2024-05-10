part of '../pages/merge_page.dart';

class _SettingsWarningDialog extends StatelessWidget {
  const _SettingsWarningDialog({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(
        l10n.warning,
      ),
      content: Text(
        message,
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(true),
          child: Text(
            l10n.close,
          ),
        ),
      ],
    );
  }
}
