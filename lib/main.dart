import 'package:flutter/material.dart';
import 'package:mobileremote/components/data_storage.dart';
import 'package:mobileremote/pages/alarm_alert_page.dart';
import 'package:mobileremote/pages/home_page.dart';
import 'package:mobileremote/pages/show_me_game_page.dart';
import 'package:mobileremote/pages/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return UserDataContainer(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashPage(),
        onGenerateRoute: generateRoute,
      ),
    );
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashPage.id:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case HomePage.id:
        return MaterialPageRoute(builder: (_) => HomePage());
      case ShowMeGamePage.id:
        return MaterialPageRoute(builder: (_) => ShowMeGamePage());
      case AlarmAlertPage.id:
        return MaterialPageRoute(builder: (_) => AlarmAlertPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

