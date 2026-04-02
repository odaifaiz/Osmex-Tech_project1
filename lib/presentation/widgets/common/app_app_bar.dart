// lib/presentation/widgets/common/app_app_bar.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // The leading widget is the one on the far left of the AppBar.
      // We use it to conditionally show a back button.
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      // The title of the AppBar.
      title: Text(
        title,
        style: AppTypography.headline3.copyWith(fontSize: 18),
      ),
      // The actions are the widgets on the far right of the AppBar.
      actions: actions,
      // By default, AppBar tries to automatically add a leading widget.
      // We set this to false to have full control.
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
