import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:playlistme/constants/strings.dart';
import 'package:playlistme/view/screen/albumlist.dart';
import 'package:playlistme/view/screen/playlist.dart';
import 'package:playlistme/view/screen/search.dart';
import 'package:spotify/spotify.dart';

void main() async {
  var credentials = SpotifyApiCredentials(
    CustomStrings.clientId,
    CustomStrings.clientSecret,
  );

  var spotify = SpotifyApi(credentials);
  runApp(MyApp(
    spotify: spotify,
  ));
}

class MyApp extends StatelessWidget {
  final SpotifyApi spotify; // Declare a field to hold the spotify instance

  const MyApp({required this.spotify, Key? key})
      : super(key: key); // Update constructor to accept spotify

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Search',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.white, // Setting text color to white
            ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  // Declare a field to hold the spotify instance

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const AlbumListScreen(),
    const SearchPage(),
    const PlayListPage(),
  ]; // Declare _pages as a late variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
      ),
      body: Stack(
        children: [
          // Main content area
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),

          // Bottom navigation bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.album),
                  label: 'Albums',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.playlist_play),
                  label: 'Playlist',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
