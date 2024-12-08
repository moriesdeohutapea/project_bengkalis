import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_bengkalis/core/utils.dart';

import '../../../data/models/movie_list.dart';
import '../../../data/services/MovieListService.dart';
import '../event/MovieListEvent.dart';
import '../state/MovieListState.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final MovieListService movieListService;

  MovieListBloc(this.movieListService) : super(MovieListInitial()) {
    on<FetchMovieListsEvent>(_onFetchMovieLists);
  }

  Future<void> _onFetchMovieLists(FetchMovieListsEvent event, Emitter<MovieListState> emit) async {
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
}