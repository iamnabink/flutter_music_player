import 'package:musicplayer/database/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/database/database_client.dart';
import 'package:musicplayer/musichome.dart';
import 'package:musicplayer/pages/NoMusicFound.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SplashState();
  }
}

class SplashState extends State<SplashScreen> {
  var db;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: SafeArea(
          child: new Container(

            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            Container(
            child: Image.asset(
              'images/splash.png',
              fit: BoxFit.cover,
            )),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 5),
                  child: Text(
                    "Music player",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                ),

                Expanded(
                  child: Center(
                    child: isLoading ? CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ) : Container(),
                  ),
                ),
                Text("Setting up...",
                    style: TextStyle(color: Colors.white, fontSize: 20))

              ],
            ),
          ),
        ));
  }

  loadSongs() async {
    setState(() {
      isLoading = true;
    });
    var db = new DatabaseClient();
    await db.create();
    if (await db.alreadyLoaded()) {
      Navigator.of(context).pop();
      Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
        return new MusicHome();
      }));
    } else {
      var songs;
      try {
        songs = await MusicFinder.allSongs();
        List<Song> list = new List.from(songs);

        if (list == null || list.length == 0) {
          print("List-> $list");
          Navigator.of(context).pop(true);
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return new NoMusicFound();
          }));
        }
        else {
          for (Song song in list)
            db.upsertSOng(song);
          if (!mounted) {
            return;
          }
          Navigator.of(context).pop(true);
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return new MusicHome();
          }));
        }
      } catch (e) {
        print("failed to get songs"+e.toString());
      }
    }
  }
}