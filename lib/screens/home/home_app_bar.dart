import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.indigoAccent.withAlpha(100),
      automaticallyImplyLeading: false,
      toolbarHeight: 8,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(3);
}
