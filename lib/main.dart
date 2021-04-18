import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signup_app/services/authentication/cubit/authentication_cubit.dart';
import 'package:signup_app/services/geo_services/geo_locator.dart';
import 'package:signup_app/util/presets/presets.dart';

import 'widgets/home/home.dart';
import 'widgets/splash/splash.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(AppThemeData.uiOverlayStyle);
  WidgetsFlutterBinding.ensureInitialized();
  await GeoLocator().initialize();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return BlocProvider(
      create: (_) => AuthenticationCubit()..appStarted(),
      child: AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //! Checked Mode Flag is disabled
      debugShowCheckedModeBanner: false,
      theme: AppThemeData().materialTheme,
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            // directing to the home screen and passing the current authentication state
            _navigator!.pushAndRemoveUntil<void>(
              HomePage.route(loggedIn: (state is Authenticated) ? true : false),
              (route) => false,
            );
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
