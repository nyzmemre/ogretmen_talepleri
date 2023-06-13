
import 'package:flutter/material.dart';

import '../../features/homepage/homepage_view.dart';
import 'route_text.dart';

class Routes {
  static Route<dynamic>? createRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteText.routeHomepageView:
        return MaterialPageRoute(builder: (_) => HomepageView());

    }
  }
}
