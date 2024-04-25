import 'package:playlistme/constants/strings.dart';
import 'package:spotify/spotify.dart';

class SpotifyService {
  static final SpotifyApi spotify = SpotifyApi(SpotifyApiCredentials(
      CustomStrings.clientId, CustomStrings.clientSecret));
}
