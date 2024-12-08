import 'package:flutter/material.dart';

import '../../data/models/movie_list.dart';
import '../../widgets/component.dart';

class MovieDetailScreen extends StatelessWidget {
  final MovieList movie;

  const MovieDetailScreen({super.key, required this.movie});

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
            'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
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
      text: movie.title,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildSubtitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: 'Release: ${movie.releaseDate}',
          fontSize: 14,
          color: Colors.grey,
        ),
        CustomText(
          text: '⭐ ${movie.voteAverage.toStringAsFixed(1)}',
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
      text: movie.overview,
      fontSize: 14,
      maxLine: 10,
    );
  }

  Widget _buildGenres() {
    return Wrap(
      spacing: 8.0,
      children: movie.genreIds
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
        _buildDetailItem("Original Title", movie.originalTitle),
        _buildDetailItem("Original Language", movie.originalLanguage.toUpperCase()),
        _buildDetailItem("Vote Count", movie.voteCount.toString()),
        _buildDetailItem("Popularity", movie.popularity.toStringAsFixed(2)),
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
