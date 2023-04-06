// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilmWidget extends ConsumerWidget {
  const FilmWidget({
    super.key,
    required this.provider,
  });

  final AlwaysAliveProviderBase<Iterable<Film>> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);
    return Expanded(
      child: ListView.builder(
        itemCount: films.length,
        itemBuilder: (BuildContext context, int index) {
          return;
        },
      ),
    );
  }
}

class FilmApp extends ConsumerWidget {
  const FilmApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}

@immutable
class Film {
  final String id;
  final String title;
  final String description;
  final bool isFavourite;

  const Film(
      {required this.id,
      required this.title,
      required this.description,
      required this.isFavourite});

  //Since only the isFavorite Field that changes
  Film copyWith({
    required bool isFavourite,
  }) {
    return Film(
      id: id,
      title: title,
      description: description,
      isFavourite: isFavourite,
    );
  }

  @override
  String toString() {
    return 'Film(id: $id, title: $title, description: $description, isFavorite: $isFavourite)';
  }

  @override
  bool operator ==(covariant Film other) =>
      id == other.id && isFavourite == other.isFavourite;

  @override
  int get hashCode => Object.hashAll([id, isFavourite]);
}

const List<Film> films = [
  Film(
      id: "1",
      title: "The Godfather",
      description:
          "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.",
      isFavourite: false),
  Film(
      id: "2",
      title: "The Shawshank Redemption",
      description:
          "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.",
      isFavourite: false),
  Film(
      id: "3",
      title: "The Dark Knight",
      description:
          "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.",
      isFavourite: true),
  Film(
      id: "4",
      title: "The Lord of the Rings: The Fellowship of the Ring",
      description:
          "A meek hobbit of the Shire and eight companions set out on a journey to Mount Doom to destroy the One Ring and the dark lord Sauron.",
      isFavourite: true),
  Film(
      id: "5",
      title: "Pulp Fiction",
      description:
          "The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.",
      isFavourite: false),
  Film(
      id: "6",
      title: "Forrest Gump",
      description:
          "The presidencies of Kennedy and Johnson, the events of Vietnam, Watergate and other historical events unfold through the perspective of an Alabama man named Forrest Gump, who has IQ of 75.",
      isFavourite: false),
  Film(
      id: "7",
      title: "The Matrix",
      description:
          "A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.",
      isFavourite: true),
  Film(
      id: "8",
      title: "Star Wars: Episode IV - A New Hope",
      description:
          "Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a Wookiee and two droids to save the galaxy from the Empire's world-destroying battle station, while also attempting to rescue Princess Leia from the mysterious Darth Vader.",
      isFavourite: true),
  Film(
      id: "9",
      title: "The Silence of the Lambs",
      description:
          "A young F.B.I. cadet must confide in an incarcerated and manipulative killer to receive his help on catching another serial killer who skins his victims.",
      isFavourite: false),
  Film(
      id: "10",
      title: "Jurassic Park",
      description:
          "During a preview tour, a theme park suffers a major power breakdown that allows its cloned dinosaur exhibits to run amok.",
      isFavourite: true)
];

class FilmNotifier extends StateNotifier<List<Film>> {
  FilmNotifier() : super(films);

  void update({required Film film, required bool isFavourite}) {
    state = state
        .map((stateFilm) => stateFilm.id == film.id
            ? stateFilm.copyWith(isFavourite: isFavourite)
            : stateFilm)
        .toList();
  }
}

final filmStateNotifierProvider =
    StateNotifierProvider<FilmNotifier, List<Film>>((ref) {
  return FilmNotifier();
});
// Favorite p
final selectFavoriteProvider = Provider<Iterable<Film>>((ref) => ref
    .watch(filmStateNotifierProvider)
    .where((element) => element.isFavourite));

enum FavouriteStatus { favorite, notFavorite, all }

final allProvider = StateProvider<FavouriteStatus>((_) {
  return FavouriteStatus.all;
});

//* Not Favorite
final selectNotFavoriteProvider = Provider<Iterable<Film>>((ref) {
  return ref
      .watch(filmStateNotifierProvider)
      .where((element) => !element.isFavourite);
});
final favoriteProvider = StateProvider<FavouriteStatus>((ref) {
  return FavouriteStatus.favorite;
});
