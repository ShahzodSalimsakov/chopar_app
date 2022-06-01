// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i2;
import 'package:flutter/material.dart' as _i7;

import '../message_handler.dart' as _i1;
import '../pages/notifications.dart' as _i3;
import '../pages/notifications_detail.dart' as _i4;
import '../pages/order_detail.dart' as _i6;
import '../pages/orders.dart' as _i5;

class AppRouter extends _i2.RootStackRouter {
  AppRouter([_i7.GlobalKey<_i7.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i2.PageFactory> pagesMap = {
    HomePage.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.MessageHandler());
    },
    NotificationsPage.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    OrdersPage.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    NotificationsRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.NotificationsPage());
    },
    NotificationDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<NotificationDetailRouteArgs>(
          orElse: () =>
              NotificationDetailRouteArgs(id: pathParams.getString('id')));
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i4.NotificationDetailPage(
              key: args.key, id: args.id, notification: args.notification));
    },
    OrdersList.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i5.Orders());
    },
    OrderDetailPage.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<OrderDetailPageArgs>(
          orElse: () =>
              OrderDetailPageArgs(orderId: pathParams.getString('orderId')));
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i6.OrderDetail(key: args.key, orderId: args.orderId));
    }
  };

  @override
  List<_i2.RouteConfig> get routes => [
        _i2.RouteConfig(HomePage.name, path: '/'),
        _i2.RouteConfig(NotificationsPage.name,
            path: 'notifications',
            children: [
              _i2.RouteConfig(NotificationsRoute.name,
                  path: '', parent: NotificationsPage.name),
              _i2.RouteConfig(NotificationDetailRoute.name,
                  path: ':id', parent: NotificationsPage.name)
            ]),
        _i2.RouteConfig(OrdersPage.name, path: 'order', children: [
          _i2.RouteConfig(OrdersList.name, path: '', parent: OrdersPage.name),
          _i2.RouteConfig(OrderDetailPage.name,
              path: ':orderId', parent: OrdersPage.name)
        ])
      ];
}

/// generated route for
/// [_i1.MessageHandler]
class HomePage extends _i2.PageRouteInfo<void> {
  const HomePage() : super(HomePage.name, path: '/');

  static const String name = 'HomePage';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class NotificationsPage extends _i2.PageRouteInfo<void> {
  const NotificationsPage({List<_i2.PageRouteInfo>? children})
      : super(NotificationsPage.name,
            path: 'notifications', initialChildren: children);

  static const String name = 'NotificationsPage';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class OrdersPage extends _i2.PageRouteInfo<void> {
  const OrdersPage({List<_i2.PageRouteInfo>? children})
      : super(OrdersPage.name, path: 'order', initialChildren: children);

  static const String name = 'OrdersPage';
}

/// generated route for
/// [_i3.NotificationsPage]
class NotificationsRoute extends _i2.PageRouteInfo<void> {
  const NotificationsRoute() : super(NotificationsRoute.name, path: '');

  static const String name = 'NotificationsRoute';
}

/// generated route for
/// [_i4.NotificationDetailPage]
class NotificationDetailRoute
    extends _i2.PageRouteInfo<NotificationDetailRouteArgs> {
  NotificationDetailRoute(
      {_i7.Key? key, required String id, Map<String, dynamic>? notification})
      : super(NotificationDetailRoute.name,
            path: ':id',
            args: NotificationDetailRouteArgs(
                key: key, id: id, notification: notification),
            rawPathParams: {'id': id});

  static const String name = 'NotificationDetailRoute';
}

class NotificationDetailRouteArgs {
  const NotificationDetailRouteArgs(
      {this.key, required this.id, this.notification});

  final _i7.Key? key;

  final String id;

  final Map<String, dynamic>? notification;

  @override
  String toString() {
    return 'NotificationDetailRouteArgs{key: $key, id: $id, notification: $notification}';
  }
}

/// generated route for
/// [_i5.Orders]
class OrdersList extends _i2.PageRouteInfo<void> {
  const OrdersList() : super(OrdersList.name, path: '');

  static const String name = 'OrdersList';
}

/// generated route for
/// [_i6.OrderDetail]
class OrderDetailPage extends _i2.PageRouteInfo<OrderDetailPageArgs> {
  OrderDetailPage({_i7.Key? key, required String orderId})
      : super(OrderDetailPage.name,
            path: ':orderId',
            args: OrderDetailPageArgs(key: key, orderId: orderId),
            rawPathParams: {'orderId': orderId});

  static const String name = 'OrderDetailPage';
}

class OrderDetailPageArgs {
  const OrderDetailPageArgs({this.key, required this.orderId});

  final _i7.Key? key;

  final String orderId;

  @override
  String toString() {
    return 'OrderDetailPageArgs{key: $key, orderId: $orderId}';
  }
}
