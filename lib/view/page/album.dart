import 'package:flutter/material.dart';
import 'package:playlistme/constants/spotify.dart';

import 'package:spotify/spotify.dart';
import 'package:flutter/src/widgets/image.dart' as img;

class AlbumPage extends StatefulWidget {
  final String albumId;

  const AlbumPage({required this.albumId, Key? key}) : super(key: key);

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  late Future<AlbumSimple> _albumFuture;

  @override
  void initState() {
    super.initState();
    _albumFuture = _fetchAlbumDetails();
  }

  Future<AlbumSimple> _fetchAlbumDetails() async {
    return SpotifyService.spotify.albums.get(widget.albumId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Album Details'),
      ),
      body: Container(
        color: Colors.black,
        child: FutureBuilder<AlbumSimple>(
          future: _albumFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final album = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        img.Image.network(album.images![0].url!),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          album.name!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),

                  // Add more album details here as needed
                  const MockUpPlayer(),
                  trackList(album),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget trackList(AlbumSimple album) {
    return Expanded(
      child: ListView.builder(
        itemCount: album.tracks!.length,
        itemBuilder: (context, index) {
          final track = album.tracks!.elementAt(index);
          final trackNumber = index + 1;
          return ListTile(
            leading: Text(
              '$trackNumber',
              style: const TextStyle(fontSize: 21),
            ),
            // Add some space between track number and title

            title: Text(track.name!),
            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  truncateArtistName(
                      track.artists!.map((artist) => artist.name).join(", "),
                      25),
                ),
                const Text('  ●  '),
                Text(' ${formatDuration(track.duration!)} '),
              ],
            ),
            trailing: Icon(Icons.more_vert),
            onTap: () {
              // Add functionality to play the track
            },
          );
        },
      ),
    );
  }

  String truncateArtistName(String artistName, int maxLength) {
    if (artistName.length <= maxLength) {
      return artistName;
    } else {
      return artistName.substring(0, maxLength) + '...and more';
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "${duration.inMinutes.remainder(60)}:$twoDigitSeconds";
  }
}

class MockUpPlayer extends StatelessWidget {
  const MockUpPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        const Icon(
          Icons.download,
          size: 24,
          color: Colors.white,
        ),
        const Spacer(),
        const Icon(Icons.library_music, size: 24, color: Colors.white),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(40)),
          width: 80,
          height: 80,
          child: const Icon(
            Icons.play_arrow,
            size: 40,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.fast_forward_outlined,
          color: Colors.white,
          size: 24,
        ),
        const Spacer(),
        const Icon(
          Icons.more_vert,
          color: Colors.white,
          size: 24,
        ),
        const Spacer(),
      ],
    );
  }
}
