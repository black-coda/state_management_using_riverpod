// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

@immutable
class Person {
  final String id;
  final String name;
  final String age;
  Person({
    required this.name,
    required this.age,
  }) : id = const Uuid().v4();

  Person copyWith({
    String? name,
    String? age,
  }) {
    return Person(
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }

  @override
  bool operator ==(covariant Person other) {
    if (identical(this, other)) return true;

    return other.name == name && other.age == age;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}

class PersonNotifier extends StateNotifier<List<Person>> {
  PersonNotifier() : super([]);

  void create(Person person) {
    state = [
      ...state,
      person,
    ];
  }

  void update(Person person) {
    final index = state.indexOf(person);
    final old = state[index];

    if (old.name != person.name || old.age != person.age) {
      state[index] = old.copyWith(name: person.name, age: person.age);
    }
  }
}

final personProvider =
    StateNotifierProvider<PersonNotifier, List<Person>>((ref) {
  return PersonNotifier();
});

// class PersonApp extends ConsumerWidget {
//   const PersonApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {}
// }

class PersonApp extends ConsumerStatefulWidget {
  const PersonApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PersonAppState();
}

class _PersonAppState extends ConsumerState<PersonApp> {
  late TextEditingController _ageController;
  late TextEditingController _nameController;

  @override
  void initState() {
    _ageController = TextEditingController();
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.yellow[400],
          title: const Text('TextField AlertDemo'),
          shape: const RoundedRectangleBorder(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Name"),
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Age"),
              ),
            ],
          ),
          actions: <Widget>[
            MaterialButton(
              child: const Text('Create'),
              onPressed: () {
                Person individual = Person(
                    name: _nameController.text, age: _ageController.text);
                ref.read(personProvider.notifier).create(individual);
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final people = ref.watch(personProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onDoubleTap: null,
                    child: ListTile(
                      title: Text(people[index].name),
                      tileColor: Colors.limeAccent[300],
                      leading: CircleAvatar(child: Text(people[index].age)),
                    ),
                  ),
                );
              },
              itemCount: people.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}
