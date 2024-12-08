import '../../core/services/hive_service.dart';
import '../models/movie_list.dart';

class MovieLocalDataSource {
  final HiveService<MovieList> hiveService;

  MovieLocalDataSource(this.hiveService);

  Future<void> saveMovie(MovieList movie) async {
    await hiveService.saveItem(movie.id.toString(), movie);
  }

  Future<MovieList?> fetchMovie(int id) async {
    return await hiveService.getItem(id.toString());
  }

  Future<List<MovieList>> fetchAllMovies() async {
    return await hiveService.getAllItems();
  }

  Future<void> deleteMovie(int id) async {
    await hiveService.deleteItem(id.toString());
  }

  Future<void> clearAllMovies() async {
    await hiveService.clearItems();
  }
}
