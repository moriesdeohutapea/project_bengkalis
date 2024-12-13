import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/movie_repository.dart';
import 'SavedMoviesEvent.dart';
import 'SavedMoviesState.dart';

class SavedMoviesBloc extends Bloc<SavedMoviesEvent, SavedMoviesState> {
  final MovieRepository movieRepository;

  SavedMoviesBloc(this.movieRepository) : super(SavedMoviesInitial()) {
    on<FetchSavedMoviesEvent>(_onFetchSavedMovies);
    on<RemoveSavedMovieEvent>(_onRemoveSavedMovie);
  }

  Future<void> _onFetchSavedMovies(FetchSavedMoviesEvent event, Emitter<SavedMoviesState> emit) async {
    emit(SavedMoviesLoading());
    try {
      final movies = await movieRepository.fetchAllMovies();
      emit(SavedMoviesLoaded(savedMovies: movies));
    } catch (e) {
      emit(SavedMoviesError('Failed to fetch saved movies: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveSavedMovie(RemoveSavedMovieEvent event, Emitter<SavedMoviesState> emit) async {
    try {
      await movieRepository.deleteMovie(event.movieId);
      add(FetchSavedMoviesEvent()); // Refresh saved movies after deletion
    } catch (e) {
      emit(SavedMoviesError('Failed to remove the movie: ${e.toString()}'));
    }
  }
}
