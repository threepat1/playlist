import 'package:flutter/material.dart';
import 'package:playlistme/models/albumlist.dart';
import 'package:playlistme/view/page/album.dart';

class SongListTile extends StatelessWidget {
  const SongListTile({
    super.key,
    required this.imageUrl,
    required this.result,
  });

  final String imageUrl;
  final AlbumList result;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: imageUrl.isNotEmpty ? Image.network(imageUrl) : null,
      title: Text(result.name),
      subtitle: Text(result.type),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AlbumPage(albumId: result.id)));
      },
    );
  }
}
