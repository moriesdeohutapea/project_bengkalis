import '../models/base_response.dart';
import '../models/movie_list.dart';
import 'dio_client.dart';

class MovieListService {
  final DioClient _dioClient;

  MovieListService(this._dioClient);

  Future<BaseResponse<MovieList>> fetchMovieLists({
    required int page,
    String language = "en-US",
    String sortBy = "popularity.desc",
    bool includeAdult = false,
    bool includeVideo = false,
  }) async {
    try {
      final response = await _dioClient.get(
        "discover/movie",
        queryParameters: {
          "include_adult": includeAdult,
          "include_video": includeVideo,
          "language": language,
          "page": page,
          "sort_by": sortBy,
        },
      );

      return BaseResponse<MovieList>.fromJson(
        response.data,
        (item) => MovieList.fromJson(item),
      );
    } catch (e) {
      throw Exception("Failed to fetch movie lists: ${e.toString()}");
    }
  }

  Future<void> createMovieList(String name, String description) async {
    try {
      final response = await _dioClient.post(
        "list",
        data: {
          "name": name,
          "description": description,
          "language": "en",
        },
      );

      if (response.statusCode != 201) {
        throw Exception("Failed to create movie list");
      }
    } catch (e) {
      throw Exception("Error creating movie list: ${e.toString()}");
    }
  }
}
