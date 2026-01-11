import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:sun_scan/core/utils/responsive.dart';

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.web,
    this.tabletUp,
  });

  final Widget mobile;
  final Widget? web;
  final Widget? tabletUp;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb && web != null) {
      return web!;
    }

    if (tabletUp != null && Responsive.isTabletUp(context)) {
      return tabletUp!;
    }

    return mobile;
  }

  static T getGenericValue<T>({
    required BuildContext context,
    required T mobile,
    T? web,
    T? tabletUp,
  }) {
    if (kIsWeb && web != null) {
      return web;
    }

    if (tabletUp != null && Responsive.isTabletUp(context)) {
      return tabletUp;
    }

    return mobile;
  }
}
