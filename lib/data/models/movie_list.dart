import 'package:hive/hive.dart';
import 'package:project_bengkalis/core/extension.dart';

@HiveType(typeId: 0)
class MovieList {
  @HiveField(0)
  final bool adult;

  @HiveField(1)
  final String backdropPath;

  @HiveField(2)
  final List<int> genreIds;

  @HiveField(3)
  final int id;

  @HiveField(4)
  final String originalLanguage;

  @HiveField(5)
  final String originalTitle;

  @HiveField(6)
  final String overview;

  @HiveField(7)
  final double popularity;

  @HiveField(8)
  final String posterPath;

  @HiveField(9)
  final String releaseDate;

  @HiveField(10)
  final String title;

  @HiveField(11)
  final bool video;

  @HiveField(12)
  final double voteAverage;

  @HiveField(13)
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
      genreIds: (json['genre_ids'] as List<dynamic>?).orEmpty().map((e) => (e as int?).orZero()).toList(),
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
