import 'package:project_bengkalis/core/extension.dart';

class MovieList {
  final bool adult;
  final String backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final String releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  MovieList({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory MovieList.fromJson(Map<String, dynamic> json) {
    return MovieList(
      adult: (json['adult'] as bool?).orFalse(),
      backdropPath: (json['backdrop_path'] as String?).orEmpty(),
      genreIds: (json['genre_ids'] as List<dynamic>?)!.map((e) => (e as int?).orZero()).toList().orEmpty(),
      id: (json['id'] as int?).orZero(),
      originalLanguage: (json['original_language'] as String?).orEmpty(),
      originalTitle: (json['original_title'] as String?).orEmpty(),
      overview: (json['overview'] as String?).orEmpty(),
      popularity: (json['popularity'] as num?)!.toDouble().orZero(),
      posterPath: (json['poster_path'] as String?).orEmpty(),
      releaseDate: (json['release_date'] as String?).orEmpty(),
      title: (json['title'] as String?).orEmpty(),
      video: (json['video'] as bool?).orFalse(),
      voteAverage: (json['vote_average'] as num?)!.toDouble().orZero(),
      voteCount: (json['vote_count'] as int?).orZero(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adult': adult,
      'backdrop_path': backdropPath,
      'genre_ids': genreIds,
      'id': id,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'title': title,
      'video': video,
      'vote_average': voteAverage,
      'vote_count': voteCount,
    };
  }
}
