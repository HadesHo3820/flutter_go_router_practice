import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// To use a custom transition animation, provide a 'pageBuilder' with a
/// CustomTransitionPage.
///
void main() => runApp(const MyApp());

/// The route configuration
final GoRouter _router = GoRouter(routes: [
  GoRoute(
      path: '/',
      builder: (context, state) {
        return const HomeScreen();
      },
      routes: [
        GoRoute(
          path: 'details',
          pageBuilder: (context, state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              child: const DetailsScreen(),
              transitionDuration: const Duration(milliseconds: 150),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // Change the opacity of the screen using a Curve based on the animation's value
                return FadeTransition(
                  opacity:
                      CurveTween(curve: Curves.easeInOut).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: 'dismissible-details',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const DismissibleDetails(),
              barrierDismissible: true,
              barrierColor: Colors.black38,

              /// Whether the route obscures previous routes when the transition is complete.
              /// When an opaque route's entrance transition is complete, the routes behind the opaque route will not be built to save resources.
              opaque: false,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              transitionsBuilder: (_, __, ___, child) => child,
            );
          },
        ),
        GoRoute(
          path: 'custom-reverse-transition-duration',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              barrierDismissible: true,
              barrierColor: Colors.black38,
              opaque: false,
              transitionDuration: const Duration(milliseconds: 500),
              reverseTransitionDuration: const Duration(milliseconds: 200),
              child: const DetailsScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          },
        )
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
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => context.go('/dismissible-details'),
              child: const Text('Go to the Dismissible Details screen'),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () =>
                  context.go('/custom-reverse-transition-duration'),
              child: const Text(
                'Go to the Custom Reverse Transition Duration Screen',
              ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go back to the Home screen'),
            ),
          ],
        ),
      ),
    );
  }
}

/// The dismissible details screen
class DismissibleDetails extends StatelessWidget {
  /// Constructs a [DismissibleDetails]
  const DismissibleDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(48),
      child: ColoredBox(color: Colors.red),
    );
  }
}
