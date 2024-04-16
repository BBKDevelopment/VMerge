part of 'app_navigation_bar.dart';

class _NavigationConfirmDialog extends StatelessWidget {
  const _NavigationConfirmDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // icon: Icon(Icons.warning_amber),
      title: const Text(
        'Discard changes',
      ),
      content: const Text(
        'You have unsaved changes. Are you sure you want to leave this page?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop(false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context.pop(true);
          },
          child: const Text('Leave'),
        ),
      ],
    );
  }
}
