class Movie {
  final String title;
  final double voteAverage;
  final String posterPath;
  final double popularity;
   bool isFavorite;

  Movie({
    required this.title,
    required this.voteAverage,
    required this.posterPath,
    required this.popularity,
    this.isFavorite=false,
  });
}
