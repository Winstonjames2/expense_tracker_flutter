import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomAppBar extends StatelessWidget {
  final PageController pageController;
  final int currentPage;

  const CustomBottomAppBar({
    super.key,
    required this.pageController,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: [
          if (!isDark)
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleIconButton(
            radius: 24,
            icon: Icons.home,
            isActive: currentPage == 0,
            activeColor: Colors.indigoAccent,
            inactiveColor: isDark ? Colors.white70 : Colors.grey,
            onTap: () => pageController.jumpToPage(0),
          ),
          CircleIconButton(
            radius: 24,
            icon: Icons.receipt_long,
            isActive: currentPage == 1,
            activeColor: Colors.indigoAccent,
            inactiveColor: isDark ? Colors.white70 : Colors.grey,
            onTap: () => pageController.jumpToPage(1),
          ),
          CircleIconButton(
            radius: 29,
            icon: Icons.add_rounded,
            iconSize: 35,
            isActive: false,
            activeColor: Colors.indigoAccent,
            inactiveColor: Colors.white,
            backgroundColor: const Color.fromARGB(106, 86, 67, 255),
            onTap: () => context.push('/transactionform'),
          ),
          CircleIconButton(
            radius: 24,
            icon: Icons.analytics_outlined,
            isActive: currentPage == 2,
            activeColor: Colors.indigoAccent,
            inactiveColor: isDark ? Colors.white70 : Colors.grey,
            onTap: () => pageController.jumpToPage(2),
          ),
          CircleIconButton(
            radius: 24,
            icon: Icons.person,
            isActive: currentPage == 3,
            activeColor: Colors.indigoAccent,
            inactiveColor: isDark ? Colors.white70 : Colors.grey,
            onTap: () => pageController.jumpToPage(3),
          ),
        ],
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  final Color? backgroundColor;
  final double? iconSize;
  final double radius;
  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const CircleIconButton({
    super.key,
    this.backgroundColor,
    this.iconSize = 25,
    required this.radius,
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        backgroundColor ??
        (isActive
            ? (isDark
                ? Colors.indigoAccent.withAlpha(90)
                : const Color.fromARGB(80, 83, 109, 254))
            : Colors.transparent);

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(50),
      elevation: backgroundColor != null ? 6.0 : 0.0,
      shadowColor:
          backgroundColor != null ? Colors.black54 : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox(
          width: radius * 2.3,
          height: radius * 1.8,
          child: Icon(
            icon,
            color: isActive ? activeColor : inactiveColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
