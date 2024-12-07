import 'package:get_it/get_it.dart';

import '../data/services/MovieListService.dart';
import '../data/services/dio_client.dart';

final getIt = GetIt.instance;

void setupInjector() {
  // Register DioClient
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Register MovieListService
  getIt.registerLazySingleton<MovieListService>(() => MovieListService(getIt<DioClient>()));
}
