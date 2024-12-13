import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/hive_service.dart';
import '../../data/local/movie_local_data_source.dart';
import '../../data/models/movie_list.dart';
import '../../repository/movie_repository.dart';
import '../blocs/favorites/SavedMoviesBloc.dart';
import '../blocs/favorites/SavedMoviesEvent.dart';
import '../blocs/favorites/SavedMoviesState.dart';
import '../widgets/component.dart';

class SavedMovieScreen extends StatelessWidget {
  const SavedMovieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final hiveService = HiveService<MovieList>('favoritesBox');
        final localDataSource = MovieLocalDataSource(hiveService);
        return SavedMoviesBloc(MovieRepository(localDataSource))..add(FetchSavedMoviesEvent());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const CustomText(
            text: 'Saved Movies',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: const SavedMovieContent(),
      ),
    );
  }
}

class SavedMovieContent extends StatelessWidget {
  const SavedMovieContent({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<SavedMoviesBloc>().add(FetchSavedMoviesEvent());
      },
      child: BlocBuilder<SavedMoviesBloc, SavedMoviesState>(
        builder: (context, state) {
          if (state is SavedMoviesLoading && state is! SavedMoviesLoaded) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is SavedMoviesLoaded) {
            return _buildSavedMoviesList(state.savedMovies);
          }

          if (state is SavedMoviesError) {
            return _buildErrorView(state.message);
          }

          return _buildEmptyListView();
        },
      ),
    );
  }

  Widget _buildSavedMoviesList(List<MovieList> savedMovies) {
    if (savedMovies.isEmpty) {
      return Stack(
        children: [
          ListView(),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CustomText(
                text: 'No saved movies yet!',
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      itemCount: savedMovies.length,
      itemBuilder: (context, index) {
        final movie = savedMovies[index];
        return ListTile(
          leading: movie.posterPath.isNotEmpty
              ? Image.network(
                  'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                  width: 50,
                  height: 75,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                )
              : const Icon(Icons.movie),
          title: CustomText(
            text: movie.title,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          subtitle: CustomText(
            text: 'Release: ${movie.releaseDate}',
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              context.read<SavedMoviesBloc>().add(RemoveSavedMovieEvent(movie.id));
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorView(String message) {
    return Stack(
      children: [
        ListView(),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomText(
              text: message,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyListView() {
    return ListView();
  }
}
