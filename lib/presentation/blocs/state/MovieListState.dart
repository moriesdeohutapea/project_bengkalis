import 'package:equatable/equatable.dart';

import '../../../data/models/movie_list.dart';

abstract class MovieListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieListInitial extends MovieListState {}

class MovieListLoading extends MovieListState {
  final List<MovieList> movieLists;

  MovieListLoading({this.movieLists = const []});

  @override
  List<Object?> get props => [movieLists];
}

class MovieListLoadingPagination extends MovieListState {
  final List<MovieList> movieLists;

  MovieListLoadingPagination(this.movieLists);

  @override
  List<Object?> get props => [movieLists];
}

class MovieListLoaded extends MovieListState {
  final List<MovieList> movieLists;
  final bool hasMore;
  final int currentPage;

  MovieListLoaded({
    required this.movieLists,
    required this.hasMore,
    required this.currentPage,
  });
}

class MovieListError extends MovieListState {
  final String message;

  MovieListError(this.message);

  @override
  List<Object?> get props => [message];
}
