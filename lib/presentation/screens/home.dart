import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_bengkalis/presentation/screens/movie_detail_screen.dart';

import '../../data/models/movie_list.dart';
import '../../widgets/component.dart';
import '../blocs/bloc/MovieListBloc.dart';
import '../blocs/event/MovieListEvent.dart';
import '../blocs/state/MovieListState.dart';

class HomePage extends StatefulWidget {
  final int accountId;

  const HomePage({super.key, required this.accountId});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController(keepScrollOffset: true);
  double? _lastScrollPosition;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      final bloc = context.read<MovieListBloc>();
      final currentState = bloc.state;

      if (currentState is MovieListLoaded && currentState.hasMore) {
        _lastScrollPosition = _scrollController.position.pixels;

        bloc.add(FetchMovieListsEvent(page: currentState.currentPage + 1));
      }
    }
  }

  void _onMovieItemClicked(BuildContext context, MovieList movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailScreen(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: "Movie Lists",
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: BlocListener<MovieListBloc, MovieListState>(
        listener: (context, state) {
          if (state is MovieListLoaded && _lastScrollPosition != null && _scrollController.hasClients) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollController.jumpTo(_lastScrollPosition!);
            });
          }
        },
        child: buildMovieList(),
      ),
    );
  }

  Widget buildMovieList() {
    return BlocBuilder<MovieListBloc, MovieListState>(
      builder: (context, state) {
        if (state is MovieListLoading && state.movieLists.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MovieListLoaded || state is MovieListLoadingPagination) {
          final movieLists = state is MovieListLoaded ? state.movieLists : (state as MovieListLoadingPagination).movieLists;
          final hasMore = state is MovieListLoaded && state.hasMore;
          return buildMovieListView(movieLists, hasMore);
        } else if (state is MovieListError) {
          return buildErrorView(state);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget buildMovieListView(List<MovieList> movieLists, bool hasMore) {
    return ListView.builder(
      key: const PageStorageKey<String>('movieList'),
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: movieLists.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == movieLists.length && hasMore) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final movie = movieLists[index];
        return GestureDetector(
          onTap: () => _onMovieItemClicked(context, movie),
          child: MovieListCard(
            key: ValueKey(movie.id),
            imageUrl: movie.posterPath.isNotEmpty ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}' : null,
            title: movie.title,
            description: movie.overview,
            voteAverage: movie.voteAverage,
            voteCount: movie.voteCount,
            releaseDate: movie.releaseDate,
          ),
        );
      },
    );
  }

  Widget buildErrorView(MovieListError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: state.message,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          CustomButton(
            label: "Retry",
            onPressed: () {
              context.read<MovieListBloc>().add(FetchMovieListsEvent());
            },
            backgroundColor: Colors.red,
            borderRadius: 12.0,
            textStyle: const TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
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
