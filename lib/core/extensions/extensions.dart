import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/router/navigation_services.dart';

extension Navigation on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments, required RoutePredicate predicate}) {
    return Navigator.of(this)
        .pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pop() => Navigator.of(this).pop();
}

extension SizeExtension on BuildContext {
  BuildContext get appContext =>
      NavigationService.navigationKey.currentContext!;
  MediaQueryData get mediaQuery => MediaQuery.of(appContext);
  double get appWidth => mediaQuery.size.width;
  double get appHeight => mediaQuery.size.height;
}

extension View on num {
  SizedBox get height => SizedBox(height: toDouble().h);
  SizedBox get width => SizedBox(width: toDouble().w);
  SizedBox get phShrink => const SizedBox.shrink();
}

extension PaddingExtension on num {
  EdgeInsetsDirectional get paddingAll =>
      EdgeInsetsDirectional.all(toDouble().h);

  EdgeInsetsDirectional get paddingVert =>
      EdgeInsetsDirectional.symmetric(vertical: toDouble().h);

  EdgeInsetsDirectional get paddingHorizontal =>
      EdgeInsetsDirectional.symmetric(horizontal: toDouble().w);

  EdgeInsetsDirectional get paddingStart =>
      EdgeInsetsDirectional.only(start: toDouble().w);

  EdgeInsetsDirectional get paddingEnd =>
      EdgeInsetsDirectional.only(end: toDouble().w);

  EdgeInsetsDirectional get paddingTop =>
      EdgeInsetsDirectional.only(top: toDouble().h);

  EdgeInsetsDirectional get paddingBottom =>
      EdgeInsetsDirectional.only(bottom: toDouble().h);
}
