import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

@immutable
class Person {
  final String name;
  final int age;
  final String uuid;

  Person({required this.name, required this.age, String? uuid})
      : uuid = uuid ?? const Uuid().v4();

  Person copyWith({
    String? name,
    int? age,
  }) {
    return Person(
      name: name ?? this.name,
      age: age ?? this.age,
      uuid: uuid,
    );
  }

  @override
  bool operator ==(covariant Person other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;

  String get displayName => "$name ($age year's old)";
}

class PersonNotifier extends ChangeNotifier {
  final List<Person> _people = [];
  UnmodifiableListView<Person> get people => UnmodifiableListView(_people);
  int get count => _people.length;

  void add(Person person) {
    _people.add(person);
    notifyListeners();
  }

  void remove(Person person) {
    _people.remove(person);
    notifyListeners();
  }

  void update(Person updatedPerson) {
    final personIndex = _people.indexOf(updatedPerson);
    final person = _people[personIndex];

    if (person.name != updatedPerson.name || person.age != updatedPerson.age) {
      _people[personIndex] = person.copyWith(
        name: updatedPerson.name,
        age: updatedPerson.age,
      );
      notifyListeners();
    }
  }
}

final personProvider = ChangeNotifierProvider<PersonNotifier>((ref) {
  return PersonNotifier();
});

final _nameController = TextEditingController();
final _ageController = TextEditingController();

Future<Person?> createOrUpdatePersonDialog(BuildContext context,
    [Person? existingPerson]) {
  String? name = existingPerson?.name;
  int? age = existingPerson?.age;

  _nameController.text = name ?? '';
  _ageController.text = age?.toString() ?? '';

  return showDialog<Person?>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Create Person Object"),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (name != null && age != null) {
                if (existingPerson != null) {
                  final newPerson =
                      existingPerson.copyWith(name: name, age: age);
                  Navigator.of(context).pop(newPerson);
                } else {
                  Navigator.of(context).pop(
                    Person(name: name!, age: age!),
                  );
                }
              } else {}
            },
            child: const Text(
              "Save",
            ),
          )
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              autocorrect: true,
              controller: _nameController,
              decoration: const InputDecoration(
                  hintText: "Enter your name", border: OutlineInputBorder()),
              onChanged: (value) {
                name = value;
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              autocorrect: true,
              controller: _ageController,
              decoration: const InputDecoration(hintText: "Enter your age"),
              onChanged: (value) {
                age = int.tryParse(value);
              },
            ),
          ],
        ),
      );
    },
  );
}

class PersonaApp extends StatelessWidget {
  const PersonaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final dataModel = ref.watch(personProvider);
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final person = await createOrUpdatePersonDialog(context);
              if (person != null) {
                final dmodel = ref.read(personProvider).add(person);
              }
            },
          ),
          body: SafeArea(
            child: ListView.builder(
              itemCount: dataModel.count,
              itemBuilder: (BuildContext context, int index) {
                final person = dataModel.people[index];
                return GestureDetector(
                  onTap: () async {
                    final updatedPerson =
                        await createOrUpdatePersonDialog(context, person);

                    if (updatedPerson != null) {
                      dataModel.update(updatedPerson);
                    }
                  },
                  child: ListTile(
                    title: Text(person.displayName),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
