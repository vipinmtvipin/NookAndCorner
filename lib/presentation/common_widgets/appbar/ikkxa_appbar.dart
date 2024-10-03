import 'package:flutter/material.dart';

enum customerappAppBarType {
  home,
  settings,
  defaultAppBar,
}

class customerappAppBar extends StatelessWidget implements PreferredSizeWidget {
  final customerappAppBarType appBarType;
  final double leadingWidth;
  final Widget? leading;
  final String? title;
  final bool centerTitle;
  final List<Widget>? actions;
  final double appBarHeight;
  final PreferredSizeWidget? bottom;

  const customerappAppBar({
    super.key,
    this.title,
    this.leadingWidth = 70,
    this.appBarHeight = 56,
    this.leading,
    this.centerTitle = true,
    this.actions,
    this.appBarType = customerappAppBarType.defaultAppBar,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    switch (appBarType) {
      case customerappAppBarType.home:
        return HomeAppBar(
          leadingWidth: leadingWidth,
          actions: actions,
        );

      case customerappAppBarType.settings:
        return SettingsAppBar(
          title: title ?? '',
          leadingWidth: leadingWidth,
          actions: actions,
        );

      default:
        return AppBar(
          automaticallyImplyLeading: leading == null,
          leadingWidth: leadingWidth,
          leading: leading,
          title: Text(title ?? ''),
          centerTitle: centerTitle,
          actions: actions,
          bottom: bottom,
        );
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}

class SettingsAppBar extends StatelessWidget {
  final String title;
  final double leadingWidth;
  final List<Widget>? actions;

  const SettingsAppBar({
    super.key,
    required this.title,
    required this.leadingWidth,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: leadingWidth,
      leading: const SizedBox.shrink(),
      title: Text(title),
      centerTitle: true,
      actions: actions,
    );
  }
}

class HomeAppBar extends StatelessWidget {
  final double leadingWidth;
  final List<Widget>? actions;

  const HomeAppBar({
    super.key,
    required this.leadingWidth,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: leadingWidth,
      title: const Text("Home" ?? ''),
      centerTitle: true,
      actions: actions,
    );
  }
}
