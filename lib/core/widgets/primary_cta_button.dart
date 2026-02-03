import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Primary CTA: gradient or solid primary, height 52-56, theme radius.
class PrimaryCTAButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool useGradient;
  final IconData? icon;

  const PrimaryCTAButton({
    super.key,
    required this.label,
    this.onPressed,
    this.useGradient = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 22, color: Colors.white),
          const SizedBox(width: 10),
        ],
        Text(
          label,
          style: AppTheme.bodyStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ],
    );
    if (useGradient) {
      return Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
            child: Center(child: child),
          ),
        ),
      );
    }
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
