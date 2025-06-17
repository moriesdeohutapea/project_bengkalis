import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/movie_list.dart';
import '../../../data/services/MovieListService.dart';
import 'MovieListEvent.dart';
import 'MovieListState.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final MovieListService movieListService;

  MovieListBloc(this.movieListService) : super(MovieListInitial()) {
    on<FetchMovieListsEvent>(_handleFetchMovies);
    on<RefreshMovieListsEvent>(_handleRefreshMovies);
  }

  Future<void> _handleFetchMovies(FetchMovieListsEvent event, Emitter<MovieListState> emit) async {
    try {
      final currentState = state;
      List<MovieList> currentMovies = [];
      int currentPage = event.page;

      if (event.page == 1) {
        emit(MovieListLoading());
      } else if (currentState is MovieListLoaded) {
        currentMovies = currentState.movieLists;
        emit(MovieListLoadingPagination(currentMovies));
      }

      final response = await movieListService.fetchMovieLists(
        page: event.page,
        includeAdult: event.includeAdult,
        includeVideo: event.includeVideo,
        language: event.language,
        sortBy: event.sortBy,
      );

      final newMovies = response.results as List<MovieList>;
      final allMovies = [...currentMovies, ...newMovies];

      emit(MovieListLoaded(
        movieLists: allMovies,
        hasMore: newMovies.isNotEmpty && event.page < response.totalPages,
        currentPage: currentPage,
      ));
    } on DioException catch (dioError) {
      final errorMessage = dioError.response?.data['status_message'] ?? 'Failed to fetch movie lists';
      emit(MovieListError(errorMessage));
    } catch (e) {
      emit(MovieListError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _handleRefreshMovies(RefreshMovieListsEvent event, Emitter<MovieListState> emit) async {
    try {
      emit(MovieListLoading());
      final response = await movieListService.fetchMovieLists(
        page: 1,
        includeAdult: event.includeAdult,
        includeVideo: event.includeVideo,
        language: event.language,
        sortBy: event.sortBy,
      );

      emit(MovieListLoaded(
        movieLists: response.results as List<MovieList>,
        hasMore: response.results.isNotEmpty,
        currentPage: 1,
      ));
    } catch (e) {
      emit(MovieListError('Failed to refresh movies: ${e.toString()}'));
    }
  }
}
