import 'package:auto_route/auto_route.dart';
import 'package:chopar_app/message_handler.dart';
import '../pages/notifications.dart';
import '../pages/notifications_detail.dart';
import '../pages/order_detail.dart';
import '../pages/orders.dart';

@MaterialAutoRouter(replaceInRouteName: 'Page,Route', routes: [
  AutoRoute(path: '/', name: 'HomePage', page: MessageHandler),
  AutoRoute(
      path: 'notifications',
      name: 'NotificationsPage',
      page: EmptyRouterPage,
      children: [
        AutoRoute(
          path: '',
          name: 'NotificationsRoute',
          page: NotificationsPage,
        ),
        AutoRoute(
          path: ':id',
          page: NotificationDetailPage,
        )
      ]),
  AutoRoute(
      path: 'order',
      name: 'OrdersPage',
      page: EmptyRouterPage,
      children: [
        AutoRoute(
          path: '',
          name: 'OrdersList',
          page: Orders,
        ),
        AutoRoute(
          path: ':orderId',
          name: 'OrderDetailPage',
          page: OrderDetail,
        )
      ]),
])
class $AppRouter {}
