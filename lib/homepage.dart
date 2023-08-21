import 'package:flutter/material.dart';
import 'movie_list_screen.dart'; // Import MovieListScreen class

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Top Rated Movies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MovieListScreen(),
    );
  }
}
