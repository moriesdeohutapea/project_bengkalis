import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/component.dart';
import '../../data/services/MovieListService.dart';
import '../../di/injection.dart';
import '../blocs/bloc/MovieListBloc.dart';
import '../blocs/event/MovieListEvent.dart';
import '../blocs/state/MovieListState.dart';

class HomePage extends StatelessWidget {
  final int accountId;

  const HomePage({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieListBloc(getIt<MovieListService>())
        ..add(FetchMovieListsEvent(
          page: 1,
        )),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Movie Lists"),
          centerTitle: true,
        ),
        body: BlocBuilder<MovieListBloc, MovieListState>(
          builder: (context, state) {
            if (state is MovieListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieListLoaded) {
              final lists = state.movieLists.results;
              if (lists.isEmpty) {
                return const Center(child: Text("No movie lists available."));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: lists.length,
                itemBuilder: (context, index) {
                  final movie = lists[index];
                  return MovieListCard(
                    imageUrl: movie.posterPath.isNotEmpty ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}' : null,
                    title: movie.title,
                    description: movie.overview,
                    voteAverage: movie.voteAverage,
                    voteCount: movie.voteCount,
                    releaseDate: movie.releaseDate,
                  );
                },
              );
            } else if (state is MovieListError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("No data available."));
          },
        ),
      ),
    );
  }
}

class MovieListCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String description;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;

  const MovieListCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar dengan placeholder custom
          Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              color: Colors.grey[300],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image.network(
                imageUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 50,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    maxLine: 2,
                  ),
                  const SizedBox(height: 8.0),
                  CustomText(
                    text: description,
                    color: Colors.grey[600]!,
                    maxLine: 2,
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          CustomText(
                            text: voteAverage.toStringAsFixed(1),
                            fontSize: 14.0,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.people, color: Colors.grey, size: 16),
                          const SizedBox(width: 4),
                          CustomText(
                            text: '$voteCount votes',
                            fontSize: 14.0,
                            color: Colors.grey[600]!,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  CustomText(
                    text: 'Release: $releaseDate',
                    fontSize: 12.0,
                    color: Colors.grey[500]!,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}