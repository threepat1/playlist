import 'package:spotify/spotify.dart';

class AlbumList {
  final String id;
  final String name;
  final String type;
  final List<String> images;

  AlbumList({
    required this.id,
    required this.name,
    required this.type,
    required this.images,
  });

  factory AlbumList.fromAlbumSimple(AlbumSimple album) {
    return AlbumList(
      id: album.id!,
      name: album.name!,
      type: 'Album',
      images: _extractImages(album.images),
    );
  }
  static List<String> _extractImages(List<Image>? images) {
    return images?.map((image) => image.url!).toList() ?? [];
  }
}
