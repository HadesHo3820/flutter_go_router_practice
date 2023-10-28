import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// This scenario demonstrates how to navigate using named locations instead of URLs
///
/// Instead of hardcoding the URI locations, you can also use the named locations
/// To use this API, give a unique name to each GoRoute.
/// The name can then be used in context.namedLocation to be translated back to the actual URL location.

// Family data class
class Family {
  // The last name of the family
  final String lastName;

  // The people in the family
  final Map<String, Person> people;

  Family({required this.lastName, required this.people});
}

class Person {
  // The first name of the person.
  final String firstName;

  // The age of the person
  final int age;

  Person({required this.firstName, required this.age});
}

Map<String, Family> _families = {
  'f1': Family(lastName: "Doe", people: {
    'p1': Person(firstName: "Jun", age: 23),
    'p2': Person(firstName: "John", age: 6)
  }),
  'f2': Family(lastName: "Wong", people: {
    'p1': Person(firstName: "June", age: 51),
    'p2': Person(firstName: "Xin", age: 44)
  }),
};

void main() => runApp(App());

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: title,
      debugShowCheckedModeBanner: false,
    );
  }

  /// The title of the app.
  static const String title = 'GoRouter Example: Named Routes';

  final GoRouter _router = GoRouter(debugLogDiagnostics: true, routes: [
    GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
              name: 'family',
              path: 'family/:fid',
              builder: (context, state) =>
                  FamilyScreen(fid: state.pathParameters['fid']!),
              routes: [
                GoRoute(
                  name: 'person',
                  path: 'person/:pid',
                  builder: (context, state) => PersonScreen(
                      fid: state.pathParameters['fid']!,
                      pid: state.pathParameters['pid']!),
                )
              ])
        ])
  ]);
}

/// The home screen that shows a list of families.
class HomeScreen extends StatelessWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(App.title),
      ),
      body: ListView(
        children: <Widget>[
          for (final MapEntry<String, Family> entry in _families.entries)
            ListTile(
              title: Text(entry.value.lastName),
              onTap: () => context.go(context.namedLocation('family',
                  pathParameters: <String, String>{'fid': entry.key})),
            )
        ],
      ),
    );
  }
}

/// The screen that shows a list of persons in a family.
class FamilyScreen extends StatelessWidget {
  /// Creates a [FamilyScreen].
  const FamilyScreen({required this.fid, super.key});

  /// The id family to display.
  final String fid;

  @override
  Widget build(BuildContext context) {
    final Map<String, Person> people = _families[fid]!.people;
    return Scaffold(
      appBar: AppBar(title: Text(_families[fid]!.lastName)),
      body: ListView(
        children: <Widget>[
          for (final MapEntry<String, Person> entry in people.entries)
            ListTile(
              title: Text(entry.value.firstName),
              onTap: () {
                String location = context.namedLocation(
                  'person',
                  pathParameters: <String, String>{
                    'fid': fid,
                    'pid': entry.key
                  },
                  queryParameters: <String, String>{'qid': 'quid'},
                );
                log(location, name: "person location msg");
                context.go(location);
              },
            ),
        ],
      ),
    );
  }
}

/// The person screen.
class PersonScreen extends StatelessWidget {
  /// Creates a [PersonScreen].
  const PersonScreen({required this.fid, required this.pid, super.key});

  /// The id of family this person belong to.
  final String fid;

  /// The id of the person to be displayed.
  final String pid;

  @override
  Widget build(BuildContext context) {
    final Family family = _families[fid]!;
    final Person person = family.people[pid]!;
    return Scaffold(
      appBar: AppBar(title: Text(person.firstName)),
      body: Text(
          '${person.firstName} ${family.lastName} is ${person.age} years old'),
    );
  }
}
