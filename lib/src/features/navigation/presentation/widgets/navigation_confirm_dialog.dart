part of 'app_navigation_bar.dart';

class _NavigationConfirmDialog extends StatelessWidget {
  const _NavigationConfirmDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(
        l10n.discardChanges,
      ),
      content: Text(
        l10n.unsavedChangesMessage,
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => context.pop(true),
          child: Text(l10n.leave),
        ),
      ],
    );
  }
}
