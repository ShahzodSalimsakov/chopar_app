import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

// Импорты страниц
import '../pages/home.dart';
import '../pages/notifications.dart';
import '../pages/notifications_detail.dart';
import '../pages/order_detail.dart';
import '../pages/orders.dart';
import '../pages/personal_data.dart';
import '../pages/about_us.dart';
import '../pages/product_detail.dart';
import '../pages/order_registration.dart';
import '../pages/main_page.dart';
import '../pages/bonuses.dart';

// Простой класс роутера для использования с MaterialApp
class AppRouter {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Метод для генерации маршрутов
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    print(
        "Router: Navigating to ${settings.name} with arguments: ${settings.arguments}");

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Home());
      case '/notifications':
        return MaterialPageRoute(builder: (_) => const NotificationsPage());
      case '/notifications-detail':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => NotificationDetailPage(
            id: args?['id'] as String? ?? '',
          ),
        );
      case '/order-detail':
        final args = settings.arguments as Map<String, dynamic>?;
        print(
            "Router: Creating OrderDetailPage with orderId: ${args?['orderId']}");
        return MaterialPageRoute(
          builder: (_) => OrderDetailPage(
            orderId: args?['orderId'] as String? ?? '',
          ),
        );
      case '/orders':
        return MaterialPageRoute(builder: (_) => OrdersPage());
      case '/personal-data':
        return MaterialPageRoute(builder: (_) => const PersonalDataPage());
      case '/about-us':
        return MaterialPageRoute(builder: (_) => const AboutUs());
      case '/product-detail':
        final args = settings.arguments as Map<String, dynamic>?;
        final detail = args?['detail'];
        return MaterialPageRoute(
          builder: (_) => ProductDetail(detail: detail),
        );
      case '/order-registration':
        return MaterialPageRoute(builder: (_) => OrderRegistration());
      case '/main-page':
        return MaterialPageRoute(builder: (_) => const MainPage());
      case '/bonuses':
        return MaterialPageRoute(builder: (_) => const Bonuses());
      default:
        return MaterialPageRoute(builder: (_) => const Home());
    }
  }

  // Метод для навигации к именованному маршруту
  Future<dynamic> navigateTo(String routeName,
      {Map<String, dynamic>? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  // Метод для замены текущего маршрута
  Future<dynamic> replaceTo(String routeName,
      {Map<String, dynamic>? arguments}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  // Метод для возврата назад
  void goBack() {
    navigatorKey.currentState!.pop();
  }
}
