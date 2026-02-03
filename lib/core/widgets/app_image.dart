import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';

/// Placeholder shown while image loads or when URL is invalid.
Widget imagePlaceholder(BuildContext context, {double? width, double? height}) {
  return Container(
    width: width,
    height: height,
    color: AppTheme.bgLight,
    child: Center(
      child: Icon(
        Icons.image_outlined,
        size: width != null && height != null ? (width < height ? width * 0.4 : height * 0.4) : 48,
        color: AppTheme.textGrey.withOpacity(0.4),
      ),
    ),
  );
}

/// Error widget when image fails to load (replaces default broken/cross icon).
Widget imageErrorWidget(BuildContext context, Object error, StackTrace? stackTrace, {double? width, double? height}) {
  return Container(
    width: width,
    height: height,
    color: AppTheme.bgLight,
    child: Center(
      child: Icon(
        Icons.photo_library_outlined,
        size: width != null && height != null ? (width < height ? width * 0.35 : height * 0.35) : 40,
        color: AppTheme.textGrey.withOpacity(0.35),
      ),
    ),
  );
}

/// Wraps CachedNetworkImage with consistent placeholder and error (no cross marks).
Widget appCachedImage({
  required String imageUrl,
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  BorderRadius? borderRadius,
}) {
  return ClipRRect(
    borderRadius: borderRadius ?? BorderRadius.zero,
    child: CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => imagePlaceholder(context, width: width, height: height),
      errorWidget: (context, url, error) => imageErrorWidget(context, error, null, width: width, height: height),
    ),
  );
}
