import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<T?> showAdaptiveModalBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  Color? barrierColor,
  bool expand = false,
  AnimationController? secondAnimation,
  Curve? animationCurve,
  Curve? previousRouteAnimationCurve,
  bool useRootNavigator = false,
  bool bounce = true,
  bool? isDismissible,
  bool enableDrag = true,
  Duration? duration,
  RouteSettings? settings,
  Color? transitionBackgroundColor,
  BoxShadow? shadow,
  SystemUiOverlayStyle? overlayStyle,
  double? closeProgressThreshold,
}) {
  if (Platform.isIOS) {
    return showCupertinoModalBottomSheet<T>(
      context: context,
      builder: builder,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.7),
      expand: expand,
      secondAnimation: secondAnimation,
      animationCurve: animationCurve,
      previousRouteAnimationCurve: previousRouteAnimationCurve,
      useRootNavigator: useRootNavigator,
      bounce: bounce,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      duration: duration,
      settings: settings,
      transitionBackgroundColor: transitionBackgroundColor,
      shadow: shadow,
      overlayStyle: overlayStyle,
      closeProgressThreshold: closeProgressThreshold,
    );
  }
  return showMaterialModalBottomSheet<T>(
    context: context,
    builder: builder,
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape: shape,
    clipBehavior: clipBehavior,
    barrierColor: barrierColor ?? Colors.black.withOpacity(0.7),
    expand: expand,
    secondAnimation: secondAnimation,
    animationCurve: animationCurve,
    useRootNavigator: useRootNavigator,
    bounce: bounce,
    isDismissible: isDismissible ?? expand == false ? true : false,
    enableDrag: enableDrag,
    duration: duration,
    settings: settings,
    closeProgressThreshold: closeProgressThreshold,
  );
}
