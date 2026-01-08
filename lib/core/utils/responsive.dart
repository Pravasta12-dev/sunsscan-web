import 'package:flutter/widgets.dart';

class Responsive {
  static const double tabletBreakpoint = 600.0;

  static bool isMobile(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < tabletBreakpoint;
  }

  static bool isTabletUp(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tabletBreakpoint;
  }
}
