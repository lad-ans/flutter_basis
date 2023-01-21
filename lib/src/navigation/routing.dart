import 'package:flutter/material.dart';

import 'basis_route.dart';
import 'transition.dart';

abstract class Routing {
  String get initialRoute => '/';
  Map<String, BasisRoute> get basisRoutes;

  Widget _transitionBuilder(
    BuildContext context,
    Animation<double> anim,
    Animation<double> secondAnim,
    child, {
    TransitionType? transitionType,
  }) {
    switch (transitionType) {
      case TransitionType.upToDown:
        return upToDown(anim, child);
      case TransitionType.downToUp:
        return downToUp(anim, child);
      case TransitionType.leftToRight:
        return leftToRight(anim, child);
      case TransitionType.rightToLeft:
        return rightToLeft(anim, child);
      case TransitionType.leftToRightFaded:
        return leftToRightFaded(anim, child);
      case TransitionType.rightToLeftFaded:
        return rightToLeftFaded(anim, child);
      case TransitionType.rotate:
        return rotate(anim, child);
      case TransitionType.scale:
        return scale(anim, child);
      case TransitionType.scaleElasticIn:
        return scaleElasticIn(anim, child);
      case TransitionType.scaleElasticInOut:
        return scaleElasticInOut(anim, child);
      case TransitionType.size:
        return size(anim, child);
      case TransitionType.fadeIn:
        return fadeIn(anim, child);
      case TransitionType.noTransition:
        return child;
      default:
        return rightToLeft(anim, child);
    }	
  }

  Route? onGenerateRoute(RouteSettings routerSettings) {
    var routerName = routerSettings.name;
    var routerArgs = routerSettings.arguments;

    var navigateTo = basisRoutes[routerName]?.widgetBuilderArgs;

    var transitionType = basisRoutes[routerName]?.transitionType;
    var transitionDuration = basisRoutes[routerName]?.transitionDuration;
    var reverseTransitionDuration = basisRoutes[routerName]?.reverseTransitionDuration;

    if (navigateTo == null) return null;

    return PageRouteBuilder(
      pageBuilder: (context, anim, secondAnim) {
        return navigateTo(context, routerArgs);
      },
      transitionDuration: transitionDuration ??= const Duration(milliseconds: 300),
      reverseTransitionDuration: reverseTransitionDuration ??= const Duration(milliseconds: 300),
      transitionsBuilder: (context, anim, secondAnim, child) {
        return _transitionBuilder(
          context,
          anim,
          secondAnim,
          child,
          transitionType: transitionType ?? TransitionType.rightToLeft,
        );
      },
    );
  }
}
