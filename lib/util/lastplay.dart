import 'package:musicplayer/database/flute_music_player.dart';

class MyQueue {
  static List<Song> songs; // current playing queue
  static Song song; // current playing song
  static int index; // current playing song index
  static MusicFinder player = new MusicFinder();
  static List<Song> allSongs;
}
