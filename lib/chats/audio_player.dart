import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:fyp_secure_com/colors/color.dart';

class AudioPlayerView extends StatefulWidget {
  final path;

  AudioPlayerView({Key key, this.path}) : super(key: key);

  @override
  _AudioPlayerViewState createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<AudioPlayerView> {
  FlutterSoundPlayer flutterSoundPlayer;
  Duration duration = Duration(seconds: 0);
  Duration position = Duration(seconds: 0);
  bool isPlayinga = true;

  Widget slider() {
    return InkWell(
      onTap: () {
        //advancedPlayer.pause();
        flutterSoundPlayer.pausePlayer();
      },
      child: Slider(
          inactiveColor: Colors.white,
          value: position.inSeconds.toDouble(),
          min: 0.0,
          max: duration.inSeconds.toDouble(),
          onChanged: (double value) {
            setState(() {
              seekToSecond(value.toInt());
              value = value;
            });
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !isPlayinga
            ? IconButton(
                onPressed: () {
                  //advancedPlayer.pause();
                  flutterSoundPlayer.pausePlayer();
                },
                icon: Icon(
                  Icons.pause_circle_filled,
                  size: 30,
                  color: blue,
                ),
              )
            : IconButton(
                onPressed: () async {
                  //advancedPlayer = AudioPlayer();
                  isPlayinga = false;
                  setState(() {});
                  flutterSoundPlayer = FlutterSoundPlayer();
                  flutterSoundPlayer.openAudioSession();
                  duration = await flutterSoundPlayer.startPlayer(
                      fromURI: widget.path);
                  setState(() {});
                  print(duration.inSeconds);

                  var timer = Timer.periodic(Duration(seconds: 1), (timer) {
                    if (position.inSeconds == duration.inSeconds) {
                      timer.cancel();
                      isPlayinga = true;

                      position = Duration(seconds: 0);
                    } else {
                      position = Duration(seconds: position.inSeconds + 1);
                    }
                    setState(() {});
                  });

                  if (position.inSeconds == duration.inSeconds) {
                    timer.cancel();
                    isPlayinga = true;
                    position = Duration(seconds: 0);
                    setState(() {});
                  }
                  // await advancedPlayer.play(widget.path);
                  // advancedPlayer.onPlayerStateChanged
                  //     .listen((AudioPlayerState event) {
                  //   if (event == AudioPlayerState.PLAYING) {
                  //     duration = advancedPlayer.duration;
                  //     isPlayinga = false;
                  //   } else if (event == AudioPlayerState.COMPLETED) {
                  //     advancedPlayer.stop();
                  //     isPlayinga = true;
                  //   } else if (event == AudioPlayerState.PAUSED) {
                  //     isPlayinga = true;
                  //   } else {
                  //     isPlayinga = true;
                  //   }
                  //   setState(() {});
                  // });

                  // advancedPlayer.onAudioPositionChanged.listen((Duration p) {
                  //   // print('Current position: $p');

                  //   setState(() {
                  //     position = p;
                  //   });
                  // });
                },
                icon: Icon(
                  Icons.play_circle_fill,
                  size: 30,
                  color: Colors.white,
                ),
              ),
        Flexible(child: slider()),
      ],

      // actions: [
      //   Text(
      //     "${position.inSeconds}/${duration.inSeconds}",
      //     style: TextStyle(color: blue),
      //   ),
      // ],
    );
    // return PreferredSize(
    //   preferredSize: Size(size.width, 10),
    //   child: ListTile(
    //     tileColor: Colors.white,
    //     leading: !isPlayinga
    //         ? IconButton(
    //             onPressed: () {
    //               //advancedPlayer.pause();
    //               flutterSoundPlayer.pausePlayer();
    //             },
    //             icon: Icon(
    //               Icons.pause_circle_filled,
    //               size: 40,
    //               color: blue,
    //             ),
    //           )
    //         : IconButton(
    //             onPressed: () async {
    //               print("audio path");
    //               print(widget.path);
    //               //advancedPlayer = AudioPlayer();
    //               isPlayinga = false;
    //               setState(() {});
    //               flutterSoundPlayer = FlutterSoundPlayer();
    //               flutterSoundPlayer.openAudioSession();
    //               duration = await flutterSoundPlayer.startPlayer(
    //                   fromURI: widget.path);
    //               setState(() {});
    //               print(duration.inSeconds);

    //               var timer = Timer.periodic(Duration(seconds: 1), (timer) {
    //                 if (position.inSeconds == duration.inSeconds) {
    //                   timer.cancel();
    //                   isPlayinga = true;

    //                   position = Duration(seconds: 0);
    //                 } else {
    //                   position = Duration(seconds: position.inSeconds + 1);
    //                 }
    //                 setState(() {});
    //               });

    //               if (position.inSeconds == duration.inSeconds) {
    //                 timer.cancel();
    //                 isPlayinga = true;
    //                 position = Duration(seconds: 0);
    //                 setState(() {});
    //               }
    //               // await advancedPlayer.play(widget.path);
    //               // advancedPlayer.onPlayerStateChanged
    //               //     .listen((AudioPlayerState event) {
    //               //   if (event == AudioPlayerState.PLAYING) {
    //               //     duration = advancedPlayer.duration;
    //               //     isPlayinga = false;
    //               //   } else if (event == AudioPlayerState.COMPLETED) {
    //               //     advancedPlayer.stop();
    //               //     isPlayinga = true;
    //               //   } else if (event == AudioPlayerState.PAUSED) {
    //               //     isPlayinga = true;
    //               //   } else {
    //               //     isPlayinga = true;
    //               //   }
    //               //   setState(() {});
    //               // });

    //               // advancedPlayer.onAudioPositionChanged.listen((Duration p) {
    //               //   // print('Current position: $p');

    //               //   setState(() {
    //               //     position = p;
    //               //   });
    //               // });
    //             },
    //             icon: Icon(
    //               Icons.play_circle_fill,
    //               size: 40,
    //               color: blue,
    //             ),
    //           ),
    //     title: Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Flexible(child: slider()),
    //       ],
    //     ),
    //     // actions: [
    //     //   Text(
    //     //     "${position.inSeconds}/${duration.inSeconds}",
    //     //     style: TextStyle(color: blue),
    //     //   ),
    //     // ],
    //   ),
    // );
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    //advancedPlayer.seek(newDuration.inMilliseconds.toDouble());
    flutterSoundPlayer.seekToPlayer(newDuration);
  }
}
