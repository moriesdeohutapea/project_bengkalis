import 'package:equatable/equatable.dart';

import '../../../data/models/movie_list.dart';

abstract class SavedMoviesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SavedMoviesInitial extends SavedMoviesState {}

class SavedMoviesLoading extends SavedMoviesState {}

class SavedMoviesLoaded extends SavedMoviesState {
  final List<MovieList> savedMovies;

  SavedMoviesLoaded({required this.savedMovies});

  @override
  List<Object?> get props => [savedMovies];
}

class SavedMoviesError extends SavedMoviesState {
  final String message;

  SavedMoviesError(this.message);

  @override
  List<Object?> get props => [message];
}
