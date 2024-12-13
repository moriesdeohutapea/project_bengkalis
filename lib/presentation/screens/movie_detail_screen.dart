import 'package:flutter/material.dart';

import '../../core/services/hive_service.dart';
import '../../data/models/movie_list.dart';
import '../widgets/component.dart';

class MovieDetailScreen extends StatefulWidget {
  final MovieList movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late HiveService<MovieList> favoritesService;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    favoritesService = HiveService<MovieList>('favoritesBox');

    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final favoriteMovie = await favoritesService.getItem(widget.movie.id.toString());
    setState(() {
      isFavorite = favoriteMovie != null;
    });
  }

  Future<void> _toggleFavorite() async {
    if (isFavorite) {
      // Hapus dari daftar favorit
      await favoritesService.deleteItem(widget.movie.id.toString());
      setState(() {
        isFavorite = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.movie.title} has been removed from favorites!'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // Simpan ke daftar favorit
      await favoritesService.saveItem(widget.movie.id.toString(), widget.movie);
      setState(() {
        isFavorite = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.movie.title} has been added to favorites!'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackdrop(context),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackdrop(BuildContext c) {
    return Stack(
      children: [
        // Backdrop Image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          child: Image.network(
            'https://image.tmdb.org/t/p/w500${widget.movie.backdropPath}',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 250),
          ),
        ),
        // Back Arrow
        Positioned(
          top: 20,
          left: 8,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(c);
            },
          ),
        ),
        // Favorite Button
        Positioned(
          top: 20,
          right: 16,
          child: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: _toggleFavorite,
            iconSize: 30,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: 8),
          _buildSubtitle(),
          const SizedBox(height: 16),
          _buildSectionTitle("Overview"),
          _buildOverview(),
          const SizedBox(height: 16),
          _buildSectionTitle("Genres"),
          _buildGenres(),
          const SizedBox(height: 16),
          _buildSectionTitle("Additional Details"),
          _buildAdditionalDetails(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return CustomText(
      text: widget.movie.title,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildSubtitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: 'Release: ${widget.movie.releaseDate}',
          fontSize: 14,
          color: Colors.grey,
        ),
        CustomText(
          text: '⭐ ${widget.movie.voteAverage.toStringAsFixed(1)}',
          fontSize: 14,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return CustomText(
      text: title,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildOverview() {
    return CustomText(
      text: widget.movie.overview,
      fontSize: 14,
      maxLine: 10,
    );
  }

  Widget _buildGenres() {
    return Wrap(
      spacing: 8.0,
      children: widget.movie.genreIds
          .map(
            (id) => Chip(
              label: CustomText(
                text: 'Genre $id',
                fontSize: 12,
              ),
              backgroundColor: Colors.blueGrey[100],
            ),
          )
          .toList(),
    );
  }

  Widget _buildAdditionalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailItem("Original Title", widget.movie.originalTitle),
        _buildDetailItem("Original Language", widget.movie.originalLanguage.toUpperCase()),
        _buildDetailItem("Vote Count", widget.movie.voteCount.toString()),
        _buildDetailItem("Popularity", widget.movie.popularity.toStringAsFixed(2)),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: CustomText(
        text: "$label: $value",
        fontSize: 14,
      ),
    );
  }
}
