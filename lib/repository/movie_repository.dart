import '../data/local/movie_local_data_source.dart';
import '../data/models/movie_list.dart';

class MovieRepository {
  final MovieLocalDataSource localDataSource;

  MovieRepository(this.localDataSource);

  Future<void> saveMovie(MovieList movie) => localDataSource.saveMovie(movie);

  Future<MovieList?> fetchMovie(int id) => localDataSource.fetchMovie(id);

  Future<List<MovieList>> fetchAllMovies() => localDataSource.fetchAllMovies();

  Future<void> deleteMovie(int id) => localDataSource.deleteMovie(id);

  Future<void> clearAllMovies() => localDataSource.clearAllMovies();
}
