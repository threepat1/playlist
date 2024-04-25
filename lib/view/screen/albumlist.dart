import 'package:flutter/material.dart';

import 'package:playlistme/constants/spotify.dart';
import 'package:playlistme/models/albumlist.dart';
import 'package:playlistme/view/widget/song_grid.dart';
import 'package:spotify/spotify.dart';

class AlbumListScreen extends StatefulWidget {
  const AlbumListScreen({Key? key}) : super(key: key);

  @override
  _AlbumListScreenState createState() => _AlbumListScreenState();
}

class _AlbumListScreenState extends State<AlbumListScreen> {
  List<AlbumList> albums = [];

  @override
  void initState() {
    super.initState();
    _fetchAlbums();
  }

  Future<void> _fetchAlbums() async {
    try {
      final response = await SpotifyService.spotify.search.get(
        'Mix', // Your predefined query
        types: [SearchType.album],
      ).getPage(20);

      List<AlbumList> fetchedAlbums = [];

      for (final page in response) {
        if (page.items != null) {
          for (final item in page.items!) {
            if (item is AlbumSimple) {
              fetchedAlbums.add(AlbumList.fromAlbumSimple(item));
            }
          }
        }
      }

      setState(() {
        albums = fetchedAlbums;
      });
    } catch (e) {
      print('Error fetching albums: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // You can adjust the number of columns as needed
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.75, // Adjust aspect ratio as needed
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        String imageUrl = album.images.isNotEmpty ? album.images[0] : '';
        return SongGrid(album: album, imageUrl: imageUrl);
      },
    );
  }
}
