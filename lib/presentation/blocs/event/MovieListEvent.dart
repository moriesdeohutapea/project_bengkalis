import 'package:equatable/equatable.dart';

abstract class MovieListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMovieListsEvent extends MovieListEvent {
  final int page;
  final bool includeAdult;
  final bool includeVideo;
  final String language;
  final String sortBy;

  FetchMovieListsEvent({
    required this.page,
    this.includeAdult = false,
    this.includeVideo = false,
    this.language = "en-US",
    this.sortBy = "popularity.desc",
  });

  @override
  List<Object?> get props => [page, includeAdult, includeVideo, language, sortBy];
}
