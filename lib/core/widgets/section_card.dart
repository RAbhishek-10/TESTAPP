import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// White (surface) card for sections like "Continue Learning", "Top Educators", "Live".
/// Consistent padding, radius 24, soft shadow, optional light border.
class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool withBorder;

  const SectionCard({
    super.key,
    required this.child,
    this.padding,
    this.withBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: AppTheme.sectionCardDecoration(withBorder: withBorder),
      child: child,
    );
  }
}
