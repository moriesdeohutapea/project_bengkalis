import 'package:equatable/equatable.dart';

import '../../../data/models/base_response.dart';
import '../../../data/models/movie_list.dart';

abstract class MovieListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieListInitial extends MovieListState {}

class MovieListLoading extends MovieListState {}

class MovieListLoaded extends MovieListState {
  final BaseResponse<MovieList> movieLists;

  MovieListLoaded(this.movieLists);

  @override
  List<Object?> get props => [movieLists];
}

class MovieListError extends MovieListState {
  final String message;

  MovieListError(this.message);

  @override
  List<Object?> get props => [message];
}
