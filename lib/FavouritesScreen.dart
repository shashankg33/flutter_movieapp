import 'package:flutter/material.dart';
import 'movie.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Movie> favoriteMovies;

  FavoritesScreen({required this.favoriteMovies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Movies'),
      ),
      body: favoriteMovies.isEmpty
          ? Center(
        child: Text('No favorite movies yet.'),
      )
          : ListView.builder(
        itemCount: favoriteMovies.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(
              'https://image.tmdb.org/t/p/w200${favoriteMovies[index].posterPath}',
              width: 50,
              height: 50,
            ),
            title: Text(favoriteMovies[index].title),
            subtitle: Text('Vote Average: ${favoriteMovies[index].voteAverage}'),
          );
        },
      ),
    );
  }
}
