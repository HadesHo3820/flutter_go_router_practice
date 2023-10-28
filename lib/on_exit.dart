// This sample app demonstrates how to use GoRoute.onExit.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const MyApp());

/// The route configuration.
final GoRouter _router = GoRouter(debugLogDiagnostics: true, routes: [
  GoRoute(
      path: '/',
      builder: (context, state) {
        return const HomeScreen();
      },
      routes: [
        GoRoute(
          path: "details",
          builder: (context, state) {
            return const DetailsScreen();
          },
          routes: [
            GoRoute(
              name: "detail1",
              path: "detail_1",
              builder: (context, state) {
                return const Detail1Screen();
              },
            )
          ],
          onExit: (context) async {
            final bool? confirmed = await showDialog<bool>(
              context: context,
              builder: (_) {
                return AlertDialog(
                  content: const Text('Are you sure to leave this page?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Confirm'),
                    ),
                  ],
                );
              },
            );
            return confirmed ?? false;
          },
        ),
        GoRoute(
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsScreen();
          },
        ),
      ])
]);

/// The main app.
class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

/// The home screen
class HomeScreen extends StatelessWidget {
  /// Constructs a [HomeScreen]
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => context.go('/details'),
              child: const Text('Go to the Details screen'),
            ),
          ],
        ),
      ),
    );
  }
}

/// The details screen
class DetailsScreen extends StatelessWidget {
  /// Constructs a [DetailsScreen]
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details Screen')),
      body: Center(
          child: Column(
        children: <Widget>[
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('go back'),
          ),
          TextButton(
            onPressed: () {
              context.go('/details/detail_1');
            },
            child: const Text('Go Detail 1'),
          ),
          TextButton(
            onPressed: () {
              context.go('/settings');
            },
            child: const Text('go to settings'),
          ),
        ],
      )),
    );
  }
}

/// The settings screen
class SettingsScreen extends StatelessWidget {
  /// Constructs a [SettingsScreen]
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings Screen')),
      body: const Center(
        child: Text('Settings'),
      ),
    );
  }
}

/// The settings screen
class Detail1Screen extends StatelessWidget {
  /// Constructs a [Detail1Screen]
  const Detail1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail1 Screen')),
      body: const Center(
        child: Text('Detail1 Screen'),
      ),
    );
  }
}
