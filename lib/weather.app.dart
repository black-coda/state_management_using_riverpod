import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WeatherApp extends ConsumerWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.medium(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: currentWeather.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
                error: (error, stackTrace) =>
                    const Text("Oops Something Went Wrong"),
                data: (data) => Text(
                  data,
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
              centerTitle: true,
            ),
            leading: IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(Icons.arrow_back_ios),
            ),
            actions: const [
              IconButton(
                  onPressed: null, icon: Icon(Icons.account_circle_rounded)),
              IconButton(
                  onPressed: null, icon: Icon(Icons.account_balance_rounded))
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final city = City.values[index];
                final isSelectedCity = city == ref.watch(currentCityProvider);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    tileColor: Colors.deepPurpleAccent,
                    title: Text(city.name),
                    trailing:
                        isSelectedCity ? const Icon(Icons.check_rounded) : null,
                    onTap: () {
                      ref.read(currentCityProvider.notifier).state = city;
                    },
                  ),
                );
              },
              childCount: City.values.length,
            ),
          )
        ],
      ),
    );
  }
}

enum City { tokyo, lagos, capetown }

typedef WeatherEmoji = String;

Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
    const Duration(seconds: 3),
    () =>
        {
          City.capetown: "🌨️",
          City.lagos: "🌦️",
          City.tokyo: "⛈️",
        }[city] ??
        "🤷🏿‍♂️",
  );
}

// StateProvider exists primarily to allow the modification of simple variables by the User Interface.
// The state of a StateProvider is typically one of:

//     an enum, such as a filter type
//     a String, typically the raw content of a text field
//     a boolean, for checkboxes
//     a number, for pagination or age form fields

// You should not use StateProvider if:

//     your state needs validation logic
//     your state is a complex object (such as a custom class, a list/map, ...)
//     the logic for modifying your state is more advanced than a simple count++.

final currentCityProvider = StateProvider<City?>((ref) => null);

final weatherProvider = FutureProvider<WeatherEmoji>(
  (ref) async {
    final city = ref.watch(currentCityProvider);

    if (city != null) {
      return getWeather(city);
    } else {
      return "🤷🏿‍♂️";
    }
  },
);
