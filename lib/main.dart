import 'package:flutter/material.dart';
import 'package:flutter_application_hooks/counter_app.dart';
import 'package:flutter_application_hooks/person.app.2.dart';
import 'package:flutter_application_hooks/person.app.dart';
import 'package:flutter_application_hooks/weather.app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() => runApp(const ProviderScope(child: AppWidget()));

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // darkTheme: ThemeData.dark(useMaterial3: true),

      theme: ThemeData(
          // useMaterial3: true,
          colorScheme: const ColorScheme.light(
              primary: Color.fromRGBO(251, 192, 45, 1),
              onPrimary: Color.fromRGBO(0, 96, 100, 1))),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'App Entry',
            style: TextStyle(letterSpacing: 2.5),
          ),
          titleSpacing: 4.5,
          centerTitle: true,
        ),
        body: const HomePage(),
      ),
    );
  }
}

final currentDateTime = Provider<DateTime>((ref) {
  return DateTime.now();
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(currentDateTime);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            Center(
              child: Text(
                date.toIso8601String(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CounterApp(),
                ),
              ),
              color: Colors.blue[100],
              child: const Text("Counter App"),
            ),
            const SizedBox(
              height: 25,
            ),
            MaterialButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const WeatherApp(),
                ),
              ),
              color: Colors.blue[200],
              child: const Text("Weather App"),
            ),
            const SizedBox(
              height: 25,
            ),
            MaterialButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PersonApp(),
                ),
              ),
              color: Colors.blue[300],
              child: const Text("Person App"),
            ),
            const SizedBox(
              height: 25,
            ),
            MaterialButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PersonedApp(),
                ),
              ),
              color: Colors.blue[400],
              child: const Text("Person App"),
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}

extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }

  //* this(leftHand operand), other(rightHand operand)
}
