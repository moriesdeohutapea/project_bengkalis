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
    this.page = 1,
    this.includeAdult = false,
    this.includeVideo = false,
    this.language = 'en-US',
    this.sortBy = 'popularity.desc',
  });

  @override
  List<Object?> get props => [page, includeAdult, includeVideo, language, sortBy];

  @override
  String toString() {
    return 'FetchMovieListsEvent(page: $page, includeAdult: $includeAdult, includeVideo: $includeVideo, language: $language, sortBy: $sortBy)';
  }
}

class RefreshMovieListsEvent extends MovieListEvent {
  final bool includeAdult;
  final bool includeVideo;
  final String language;
  final String sortBy;

  RefreshMovieListsEvent({
    this.includeAdult = false,
    this.includeVideo = false,
    this.language = 'en-US',
    this.sortBy = 'popularity.desc',
  });

  @override
  List<Object?> get props => [includeAdult, includeVideo, language, sortBy];

  @override
  String toString() {
    return 'RefreshMovieListsEvent(includeAdult: $includeAdult, includeVideo: $includeVideo, language: $language, sortBy: $sortBy)';
  }
}