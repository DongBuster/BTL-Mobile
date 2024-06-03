import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/addItemPage/add_item_page.dart';
import '../pages/auth/views/login_page.dart';
import '../pages/auth/views/register_page.dart';
import '../pages/homePage/home_page.dart';
import '../pages/profilePage/profile_page.dart';
import 'custom_transtion_page.dart';

/// The route configuration.
final GoRouter routeConfig = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildPageWithNoDefaultTransition(
          context: context,
          state: state,
          child: const LoginPage(),
        );
      },
      redirect: (context, state) async {
        // print('here');
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        // print(prefs.getBool('islogin'));
        if (prefs.getBool('islogin') == true) {
          return '/homePage';
        } else {
          return '/login';
        }
      },
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildPageWithNoDefaultTransition(
          context: context,
          state: state,
          child: const RegisterPage(),
        );
      },
    ),
    GoRoute(
      path: '/homePage',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const HomePage(),
        );
      },
    ),
    GoRoute(
      path: '/profilePage',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const ProfilePage(),
        );
      },
    ),
    GoRoute(
      path: '/addItemPage',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildPageWithNoDefaultTransition(
          context: context,
          state: state,
          child: AddItemPage(),
        );
      },
    ),
  ],
);
