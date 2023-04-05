import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const names = [
  "Zinezu",
  "Monday",
  "Naruto",
  "Eren",
  "Arimin",
  "Mikasa",
  "Oyankipo",
  "Kruger",
  "Levi Arckerman",
  "Slim Shady",
  "Nathaniel",
  "Timi",
  "Ambrose",
  "Femi",
  "Abasifreke",
  "Damon",
  "Elena",
  "Klaus",
  "Kol",
  "Michael",
  "Finn",
  "Deucalion",
];

final tickerProvider = StreamProvider(
  (ref) {
    return Stream.periodic(
      const Duration(seconds: 3),
      (e) => e + 1,
    );
  },
);

// final nameProvider = StreamProvider((ref){
//   final ticker = ref.watch(tickerProvider);
//   ticker.map(data: data, error: error, loading: loading)
  

  

// });

class StreamApp extends ConsumerWidget {
  const StreamApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Text('Material App Bar'),
      ),
      body: const Center(
        child: Text('Hello World'),
      ),
    );
  }
}
