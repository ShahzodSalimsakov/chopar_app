// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    MessageHandlerRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MessageHandlerPage(),
      );
    },
    NotificationDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<NotificationDetailRouteArgs>(
          orElse: () =>
              NotificationDetailRouteArgs(id: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NotificationDetailPage(
          id: args.id,
          notification: args.notification,
        ),
      );
    },
    NotificationsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationsPage(),
      );
    },
    OrderDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<OrderDetailRouteArgs>(
          orElse: () =>
              OrderDetailRouteArgs(orderId: pathParams.getString('orderId')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OrderDetailPage(orderId: args.orderId),
      );
    },
    OrdersRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OrdersPage(),
      );
    },
    PersonalDataRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PersonalDataPage(),
      );
    },
  };
}

/// generated route for
/// [MessageHandlerPage]
class MessageHandlerRoute extends PageRouteInfo<void> {
  const MessageHandlerRoute({List<PageRouteInfo>? children})
      : super(
          MessageHandlerRoute.name,
          initialChildren: children,
        );

  static const String name = 'MessageHandlerRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NotificationDetailPage]
class NotificationDetailRoute
    extends PageRouteInfo<NotificationDetailRouteArgs> {
  NotificationDetailRoute({
    required String id,
    Map<String, dynamic>? notification,
    List<PageRouteInfo>? children,
  }) : super(
          NotificationDetailRoute.name,
          args: NotificationDetailRouteArgs(
            id: id,
            notification: notification,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'NotificationDetailRoute';

  static const PageInfo<NotificationDetailRouteArgs> page =
      PageInfo<NotificationDetailRouteArgs>(name);
}

class NotificationDetailRouteArgs {
  const NotificationDetailRouteArgs({
    required this.id,
    this.notification,
  });

  final String id;

  final Map<String, dynamic>? notification;

  @override
  String toString() {
    return 'NotificationDetailRouteArgs{id: $id, notification: $notification}';
  }
}

/// generated route for
/// [NotificationsPage]
class NotificationsRoute extends PageRouteInfo<void> {
  const NotificationsRoute({List<PageRouteInfo>? children})
      : super(
          NotificationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OrderDetailPage]
class OrderDetailRoute extends PageRouteInfo<OrderDetailRouteArgs> {
  OrderDetailRoute({
    required String orderId,
    List<PageRouteInfo>? children,
  }) : super(
          OrderDetailRoute.name,
          args: OrderDetailRouteArgs(orderId: orderId),
          rawPathParams: {'orderId': orderId},
          initialChildren: children,
        );

  static const String name = 'OrderDetailRoute';

  static const PageInfo<OrderDetailRouteArgs> page =
      PageInfo<OrderDetailRouteArgs>(name);
}

class OrderDetailRouteArgs {
  const OrderDetailRouteArgs({required this.orderId});

  final String orderId;

  @override
  String toString() {
    return 'OrderDetailRouteArgs{orderId: $orderId}';
  }
}

/// generated route for
/// [OrdersPage]
class OrdersRoute extends PageRouteInfo<void> {
  const OrdersRoute({List<PageRouteInfo>? children})
      : super(
          OrdersRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrdersRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PersonalDataPage]
class PersonalDataRoute extends PageRouteInfo<void> {
  const PersonalDataRoute({List<PageRouteInfo>? children})
      : super(
          PersonalDataRoute.name,
          initialChildren: children,
        );

  static const String name = 'PersonalDataRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
