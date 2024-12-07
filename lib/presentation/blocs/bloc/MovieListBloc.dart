import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/MovieListService.dart';
import '../event/MovieListEvent.dart';
import '../state/MovieListState.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final MovieListService movieListService;

  MovieListBloc(this.movieListService) : super(MovieListInitial()) {
    on<FetchMovieListsEvent>(_onFetchMovieLists);
  }

  Future<void> _onFetchMovieLists(FetchMovieListsEvent event, Emitter<MovieListState> emit) async {
    emit(MovieListLoading());

    try {
      final lists = await movieListService.fetchMovieLists(
        page: event.page,
        includeAdult: event.includeAdult,
        includeVideo: event.includeVideo,
        language: event.language,
        sortBy: event.sortBy,
      );
      emit(MovieListLoaded(lists));
    } on DioException catch (dioError) {
      final message = dioError.response?.data['status_message'] ?? 'Failed to fetch movie lists';
      emit(MovieListError(message));
    } catch (e) {
      emit(MovieListError('An unexpected error occurred'));
    }
  }
}
