import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_bengkalis/presentation/screens/movie_detail_screen.dart';

import '../../data/models/movie_list.dart';
import '../blocs/movie_list/MovieListBloc.dart';
import '../blocs/movie_list/MovieListEvent.dart';
import '../blocs/movie_list/MovieListState.dart';
import '../widgets/component.dart';
import '../widgets/movie_list_card.dart';

class HomePage extends StatefulWidget {
  final int accountId;

  const HomePage({super.key, required this.accountId});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController(keepScrollOffset: true);

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MovieListBloc>().add(FetchMovieListsEvent(page: 1));
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _scrollController.addListener(() {
      context.read<MovieListBloc>().add(UpdateScrollPosition(_scrollController.position.pixels));
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      final bloc = context.read<MovieListBloc>();
      final currentState = bloc.state;

      if (currentState is MovieListLoaded && currentState.hasMore) {
        bloc.add(ScrollReachedBottom(currentState.currentPage));
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
          if (state is MovieListLoaded && _scrollController.hasClients) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollController.jumpTo(state.scrollPosition);
            });
          }
        },
        child: BlocBuilder<MovieListBloc, MovieListState>(
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
        ),
      ),
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
              context.read<MovieListBloc>().add(FetchMovieListsEvent(page: 1));
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
