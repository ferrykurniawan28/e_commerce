import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool showGradient;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.showGradient = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Container(
      decoration: showGradient
          ? BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF1A1F2E),
                        const Color(0xFF242938),
                        const Color(0xFF1A1F2E),
                      ]
                    : [
                        Colors.white,
                        const Color(0xFFF8F9FA),
                        Colors.white,
                      ],
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            )
          : BoxDecoration(
              color: backgroundColor ?? theme.appBarTheme.backgroundColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
      child: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: foregroundColor ??
                (isDark ? const Color(0xFFE8EAED) : const Color(0xFF1A1C1E)),
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: centerTitle,
        backgroundColor: Colors.transparent,
        foregroundColor: foregroundColor ??
            (isDark ? const Color(0xFFE8EAED) : const Color(0xFF1A1C1E)),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: leading ??
            (showBackButton && Navigator.canPop(context)
                ? IconButton(
                    onPressed: onBackPressed ?? () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: isDark
                          ? const Color(0xFF60A5FA)
                          : theme.colorScheme.primary,
                      size: 24,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: (isDark
                              ? const Color(0xFF60A5FA)
                              : theme.colorScheme.primary)
                          .withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                : null),
        actions: actions?.map((action) {
          if (action is IconButton) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: action.onPressed,
                icon: action.icon,
                style: IconButton.styleFrom(
                  backgroundColor: (isDark
                          ? const Color(0xFF60A5FA)
                          : theme.colorScheme.primary)
                      .withOpacity(0.1),
                  foregroundColor: isDark
                      ? const Color(0xFF60A5FA)
                      : theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            );
          }
          return action;
        }).toList(),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness:
              isDark ? Brightness.light : Brightness.dark,
        ),
      ),
    );
  }
}

class SliverCustomAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool pinned;
  final bool floating;
  final double expandedHeight;
  final Widget? flexibleSpace;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const SliverCustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.pinned = true,
    this.floating = false,
    this.expandedHeight = 120,
    this.flexibleSpace,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return SliverAppBar(
      title: Text(
        title,
        style: TextStyle(
          color: foregroundColor ??
              (isDark ? const Color(0xFFE8EAED) : const Color(0xFF1A1C1E)),
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
      centerTitle: centerTitle,
      pinned: pinned,
      floating: floating,
      expandedHeight: expandedHeight,
      backgroundColor:
          backgroundColor ?? (isDark ? const Color(0xFF1A1F2E) : Colors.white),
      foregroundColor: foregroundColor ??
          (isDark ? const Color(0xFFE8EAED) : const Color(0xFF1A1C1E)),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: leading ??
          (Navigator.canPop(context)
              ? IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: isDark
                        ? const Color(0xFF60A5FA)
                        : theme.colorScheme.primary,
                    size: 24,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: (isDark
                            ? const Color(0xFF60A5FA)
                            : theme.colorScheme.primary)
                        .withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
              : null),
      actions: actions?.map((action) {
        if (action is IconButton) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: action.onPressed,
              icon: action.icon,
              style: IconButton.styleFrom(
                backgroundColor: (isDark
                        ? const Color(0xFF60A5FA)
                        : theme.colorScheme.primary)
                    .withOpacity(0.1),
                foregroundColor: isDark
                    ? const Color(0xFF60A5FA)
                    : theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          );
        }
        return action;
      }).toList(),
      flexibleSpace: flexibleSpace ??
          FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF1A1F2E),
                          const Color(0xFF242938),
                          const Color(0xFF1A1F2E),
                        ]
                      : [
                          Colors.white,
                          const Color(0xFFF8F9FA),
                          Colors.white,
                        ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }
}
