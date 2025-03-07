import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../pages/home.dart';
import '../pages/notifications.dart';
import '../pages/notifications_detail.dart';
import '../pages/order_detail.dart';
import '../pages/orders.dart';
import '../pages/personal_data.dart';

// Simple router implementation
class AppRouter {
  // Method to handle navigation
  void pushNamed(String route) {
    // Implementation will be added later
  }

  // Method for router delegate
  RouterDelegate<Object> delegate() {
    return _AppRouterDelegate();
  }

  // Method for route information parser
  RouteInformationParser<Object> defaultRouteParser() {
    return _AppRouteInformationParser();
  }
}

// Custom router delegate
class _AppRouterDelegate extends RouterDelegate<Object>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey('HomePage'),
          child: Home(),
        ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(Object configuration) async {
    // Implementation will be added later
  }
}

// Custom route information parser
class _AppRouteInformationParser extends RouteInformationParser<Object> {
  @override
  Future<Object> parseRouteInformation(
      RouteInformation routeInformation) async {
    return {};
  }

  @override
  RouteInformation? restoreRouteInformation(Object configuration) {
    return const RouteInformation(location: '/');
  }
}
