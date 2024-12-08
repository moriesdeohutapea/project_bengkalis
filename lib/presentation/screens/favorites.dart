import 'package:flutter/material.dart';

import '../../core/services/hive_service.dart';
import '../../data/local/movie_local_data_source.dart';
import '../../data/models/movie_list.dart';
import '../../repository/movie_repository.dart';

class SavedMovieScreen extends StatefulWidget {
  const SavedMovieScreen({super.key});

  @override
  State<SavedMovieScreen> createState() => _SavedMovieScreenState();
}

class _SavedMovieScreenState extends State<SavedMovieScreen> {
  late MovieRepository movieRepository;
  late List<MovieList> savedMovies = [];

  @override
  void initState() {
    super.initState();

    final hiveService = HiveService<MovieList>('favoritesBox');
    final localDataSource = MovieLocalDataSource(hiveService);
    movieRepository = MovieRepository(localDataSource);

    _loadSavedMovies();
  }

  Future<void> _loadSavedMovies() async {
    final movies = await movieRepository.fetchAllMovies();
    setState(() {
      savedMovies = movies;
    });
  }

  Future<void> _removeMovie(int id) async {
    await movieRepository.deleteMovie(id);
    _loadSavedMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Movies'),
      ),
      body: savedMovies.isEmpty
          ? const Center(
              child: Text('No saved movies yet!'),
            )
          : ListView.builder(
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
                  title: Text(movie.title),
                  subtitle: Text('Release: ${movie.releaseDate}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => _removeMovie(movie.id),
                  ),
                );
              },
            ),
    );
  }
}