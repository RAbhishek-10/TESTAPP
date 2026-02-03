import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Small stat pill/card: icon + value + label (e.g. "12 Courses", "45 Tests", "82h Learning").
class StatChip extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const StatChip({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTheme.titleStyle.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTheme.captionStyle,
        ),
      ],
    );
  }
}
