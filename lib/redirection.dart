import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// This scenario demonstrates how to use redirect to handle a sign-in flow.
///
/// The GoRouter.redirect method is called before the app is navigate to a new page.
/// You can choose to redirect to a different page by returning a non-null URL string.

/// The login information

class LoginInfo extends ChangeNotifier {
  /// The username of login.
  String _username = '';
  String get username => _username;

  // Whether a user has logged in.
  bool get loggedIn => _username.isNotEmpty;

  // Logs in a user
  void login(String username) {
    _username = username;
    notifyListeners();
  }

  // Logs out the current user.
  void logout() {
    _username = "";
    notifyListeners();
  }
}

void main() => runApp(App());

class App extends StatelessWidget {
  // Creates an [App].
  App({super.key});

  final LoginInfo _loginInfo = LoginInfo();

  // The title of the app.
  static const String title = "GoRouter Example: Redirection";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _loginInfo,
      child: MaterialApp.router(
        routerConfig: _router,
        title: title,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  late final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          // The matched location until this point.
          String matchedLocation = state.matchedLocation;
          log(matchedLocation, name: "currentMatched Location");
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
    ],
    // redirect to the login page if the user is not logged in
    redirect: (context, state) {
      // if the user is not logged in, they need to login
      final bool loggedIn = _loginInfo.loggedIn;

      //The matched location until this point.
      final bool loggingIn = state.matchedLocation == '/login';
      if (!loggedIn) {
        return '/login';
      }

      // if the user is logged in but still on the login page, send them to
      // the home page
      if (loggingIn) {
        return '/';
      }

      // no need to redirect at all
      return null;
    },

    // changes on the listenable will cause the router to refresh it's route
    refreshListenable: _loginInfo,
  );
}

/// The login screen.
class LoginScreen extends StatelessWidget {
  /// Creates a [LoginScreen].
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // log a user in, letting all the listeners know
              context.read<LoginInfo>().login('test-user');

              // router will automatically redirect from "/login" to "/"" using
              // refreshListenable
            },
            child: const Text('Login'),
          ),
        ),
      );
}

/// The home screen.
class HomeScreen extends StatelessWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginInfo info = context.read<LoginInfo>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(App.title),
        actions: <Widget>[
          IconButton(
            onPressed: info.logout,
            tooltip: 'Logout: ${info.username}',
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: const Center(
        child: Text('HomeScreen'),
      ),
    );
  }
}
