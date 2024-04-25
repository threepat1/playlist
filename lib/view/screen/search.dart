import 'package:flutter/material.dart';
import 'package:playlistme/constants/spotify.dart';
import 'package:playlistme/models/albumlist.dart';
import 'package:playlistme/view/page/album.dart';

import 'package:spotify/spotify.dart';
import 'package:flutter/src/widgets/image.dart' as img;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  List<AlbumList> _searchResults = [];
  bool _isLoading = false;
  int _limit = 20;
  int _offset = 0;
  bool _showLoadMoreButton = false;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchSearchResults(String query) async {
    setState(() {
      _isLoading = true;
      _offset = 0; // Reset offset when performing a new search
    });

    try {
      final searchResult = await SpotifyService.spotify.search
          .get(
            query,
            market: Market.TH,
          )
          .getPage(_limit, _offset);

      List<AlbumList> results = [];

      for (final page in searchResult) {
        if (page.items != null) {
          for (final item in page.items!) {
            if (item is AlbumSimple) {
              results.add(AlbumList.fromAlbumSimple(item));
            }
          }
        }
      }

      setState(() {
        _searchResults = results;
        _showLoadMoreButton = true;
        _isLoading = false;
      });
    } catch (e) {
      print('Error searching: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreResults() async {
    setState(() {
      _isLoading = true;
      _offset += _limit; // Increment offset to fetch the next page
    });

    try {
      final searchResult = await SpotifyService.spotify.search
          .get(
            _searchController.text,
            market: Market.TH,
          )
          .getPage(_limit, _offset);

      List<AlbumList> newResults = [];

      for (final page in searchResult) {
        if (page.items != null) {
          for (final item in page.items!) {
            if (item is AlbumSimple) {
              newResults.add(AlbumList.fromAlbumSimple(item));
            }
            // else if (item is Artist) {
            //   newResults.add(SearchResult.fromArtist(item));
            // } else if (item is PlaylistSimple) {
            //   newResults.add(SearchResult.fromPlaylistSimple(item));
            // } else if (item is Track) {
            //   newResults.add(SearchResult.fromTrack(item));
            // }
          }
        }
      }

      setState(() {
        _searchResults.addAll(newResults);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading more results: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: (value) {
                _fetchSearchResults(value);
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
              ),
            ),
          ),
          _isLoading
              ? CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final result = _searchResults[index];
                      // Display the first image if available
                      String imageUrl =
                          result.images.isNotEmpty ? result.images[0] : '';
                      return ListTile(
                        leading: imageUrl.isNotEmpty
                            ? img.Image.network(imageUrl)
                            : null,
                        title: Text(result.name),
                        subtitle: Text(result.type),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  AlbumPage(albumId: result.id)));
                        },
                      );
                    },
                  ),
                ),
          if (_showLoadMoreButton) // Render the button only if the flag is true
            ElevatedButton(
              onPressed: _loadMoreResults,
              child: Text('Load More'),
            ),
        ],
      ),
    );
  }
}
