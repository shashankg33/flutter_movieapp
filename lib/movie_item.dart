import 'package:flutter/material.dart';
import 'movie.dart';

class MovieListItem extends StatelessWidget {
  final Movie movie;
  final Function(Movie) toggleFavorite;

  MovieListItem({required this.movie, required this.toggleFavorite});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        'https://image.tmdb.org/t/p/w200${movie.posterPath}',
        width: 50,
        height: 50,
      ),
      title: Text(movie.title),
      subtitle: Text('Vote Average: ${movie.voteAverage}'),
      trailing: IconButton(
        icon: Icon(
          movie.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: () {
          toggleFavorite(movie); // Call the callback function
        },
      ),
    );
  }
}
