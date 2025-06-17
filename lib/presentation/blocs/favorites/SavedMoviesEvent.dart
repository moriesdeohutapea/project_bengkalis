import 'package:equatable/equatable.dart';

abstract class SavedMoviesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchSavedMoviesEvent extends SavedMoviesEvent {}

class RemoveSavedMovieEvent extends SavedMoviesEvent {
  final int movieId;

  RemoveSavedMovieEvent(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
