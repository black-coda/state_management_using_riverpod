// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_application_hooks/main.dart';

// class CounterApp extends StatelessWidget {
//   const CounterApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Material App',
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Material App Bar'),
//         ),
//         body: const Center(
//           child: Text('Hello World'),
//         ),
//       ),
//     );
//   }
// }

class CounterApp extends ConsumerWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(":Counter App"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final coup = ref.watch(counterProvider)?.toDouble();
                return Text(
                  coup == null ? "pressed The FAB" : coup.toString(),
                  style: Theme.of(context).textTheme.headlineLarge,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ref.read(counterProvider.notifier).increment,
        child: const Icon(
          Icons.add_rounded,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.onPrimary,
        height: 55,
      ),
    );
  }
}

final counterProvider = StateNotifierProvider<CounterNotifier, int?>((ref) {
  return CounterNotifier();
});

class CounterNotifier extends StateNotifier<int?> {
  CounterNotifier() : super(0);

  void increment() => state = state == null ? 1 : state + 1;
  void reset() => state = 0;
  int? get value => state;
}
