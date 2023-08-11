import 'package:auto_route/auto_route.dart';

import '../message_handler.dart';
import '../pages/notifications.dart';
import '../pages/notifications_detail.dart';
import '../pages/order_detail.dart';
import '../pages/orders.dart';
import '../pages/personal_data.dart';
part 'router.gr.dart';

// @MaterialAutoRouter(replaceInRouteName: 'Page,Route', routes: [
//   AutoRoute(path: '/', name: 'HomePage', page: MessageHandler),
//   AutoRoute(
//       path: 'notifications',
//       name: 'NotificationsPage',
//       page: EmptyRouterPage,
//       children: [
//         AutoRoute(
//           path: '',
//           name: 'NotificationsRoute',
//           page: NotificationsPage,
//         ),
//         AutoRoute(
//           path: ':id',
//           page: NotificationDetailPage,
//         )
//       ]),
//   AutoRoute(
//       path: 'order',
//       name: 'OrdersPage',
//       page: EmptyRouterPage,
//       children: [
//         AutoRoute(
//           path: '',
//           name: 'OrdersList',
//           page: Orders,
//         ),
//         AutoRoute(
//           path: ':orderId',
//           name: 'OrderDetailPage',
//           page: OrderDetail,
//         )
//       ]),
// ])
// class $AppRouter {}

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: '/', page: MessageHandlerRoute.page),
        AutoRoute(
          path: '/notifications',
          page: NotificationsRoute.page,
        ),
        AutoRoute(
          path: '/:id',
          page: NotificationDetailRoute.page,
        ),
        AutoRoute(
          path: '/order',
          page: OrdersRoute.page,
        ),
        AutoRoute(
          path: '/order/:orderId',
          page: OrderDetailRoute.page,
        )
      ];
}
