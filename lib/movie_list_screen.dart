import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movieapp/FavouritesScreen.dart'; // Import FavoritesScreen class
import 'movie.dart';
import 'movie_item.dart'; // Import MovieListItem class
import 'package:shared_preferences/shared_preferences.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  List<Movie> movies = [];
  List<Movie> favs = [];
  final ScrollController _scrollController = ScrollController();
  String currentSortType = 'vote_average';
  String searchQuery = '';

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initializePrefs();
    _loadFavorites(); // Load favorites from shared preferences
    fetchMovies();
  }

  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Load favorite movies from shared preferences
  Future<void> _loadFavorites() async {
    final favoritesJson = _prefs.getString('favorites');
    if (favoritesJson != null) {
      final favoritesData = json.decode(favoritesJson);
      setState(() {
        favs = List<Movie>.from(favoritesData.map((movieData) => Movie(
          title: movieData['title'],
          voteAverage: movieData['voteAverage'],
          posterPath: movieData['posterPath'],
          popularity: movieData['popularity'],
          isFavorite: true,
        )));
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchMovies() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/top_rated?api_key=f2e6c31e9c5550986ed55a7054fe22ec'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final results = jsonData['results'];

      setState(() {
        movies = List<Movie>.from(results.map((movieData) => Movie(
          title: movieData['title'],
          voteAverage: movieData['vote_average'].toDouble(),
          posterPath: movieData['poster_path'],
          popularity: movieData['popularity'].toDouble(),
        )));
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  void sortMovies(String sortType) {
    setState(() {
      currentSortType = sortType;
      movies.sort((a, b) {
        switch (sortType) {
          case 'vote_average':
            return b.voteAverage.compareTo(a.voteAverage);
          case 'year':
            return b.title.compareTo(a.title);
          case 'popularity':
            return b.popularity.compareTo(a.popularity);
          default:
            return 0;
        }
      });
    });
  }

  List<Movie>? getFilteredMovies() {
    if (searchQuery.isEmpty) {
      return movies;
    } else {
      return movies
          .where((movie) =>
      movie.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          movie.voteAverage.toString().contains(searchQuery))
          .toList(); // Convert the Iterable to a List
    }
  }

  void toggleFavorite(Movie movie) {
    setState(() {
      movie.isFavorite = !movie.isFavorite;

      if (movie.isFavorite) {
        favs.add(movie);
      } else {
        favs.removeWhere((favMovie) => favMovie.title == movie.title);
      }

      _saveFavorites(); // Save favorites to shared preferences
    });
  }
  // Save favorite movies to shared preferences
  Future<void> _saveFavorites() async {
    final favoritesData = favs.map((movie) => {
      'title': movie.title,
      'voteAverage': movie.voteAverage,
      'posterPath': movie.posterPath,
      'popularity': movie.popularity,
    }).toList();
    final favoritesJson = json.encode(favoritesData);
    await _prefs.setString('favorites', favoritesJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search by title or vote average',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: sortMovies,
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 'vote_average', child: Text('Sort by Vote Average')),
              PopupMenuItem(value: 'year', child: Text('Sort by Year')),
              PopupMenuItem(
                  value: 'popularity', child: Text('Sort by Popularity')),
            ],
            // ... (unchanged)
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(favoriteMovies: favs),
                ),
              );
            },
            icon: Icon(Icons.favorite),
          )
        ],
      ),
      body: movies.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: getFilteredMovies()?.length,
        itemBuilder: (context, index) {
          return MovieListItem(movie: getFilteredMovies()![index],toggleFavorite: toggleFavorite,);
        },
      ),
    );
  }
}

