// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_share/flutter_share.dart';
// import 'package:video_player/video_player.dart';

// class VideoScreen extends StatefulWidget {
//   const VideoScreen({
//     Key key,
//     @required this.videoFile,
//   }) : super(key: key);

//   final File videoFile;

//   @override
//   _VideoScreenState createState() => _VideoScreenState();
// }

// class _VideoScreenState extends State<VideoScreen> {
//   VideoPlayerController _controller;
//   bool initialized = false;

//   String sharepath;

//   @override
//   void initState() {
//     _initVideo();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   _initVideo() async {
//     final video = await widget.videoFile;
//     sharepath = video.path;
//     _controller = VideoPlayerController.file(video)
//       // Play the video again when it ends
//       ..setLooping(true)

//       // initialize the controller and notify UI when done
//       ..initialize().then((_) => setState(() => initialized = true));
//   }

//   @override
//   Widget build(BuildContext context) {
//     _initVideo();
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text("Video Viewer"),
//       //   actions: [
//       //     IconButton(
//       //       onPressed: () async {
//       //         await FlutterShare.shareFile(
//       //           title: 'Image share',
//       //           text: 'Image share ',
//       //           filePath: sharepath,
//       //         );
//       //       },
//       //       icon: Icon(Icons.share_outlined),
//       //     ),
//       //   ],
//       // ),

//       body: initialized
//           // If the video is initialized, display it
//           ? Scaffold(
//               body: Center(
//                 child: Stack(
//                   children: [
//                     Container(
//                       height: 60,
//                       decoration: BoxDecoration(),
//                       child: AspectRatio(
//                         aspectRatio: _controller.value.aspectRatio,
//                         // Use the VideoPlayer widget to display the video.
//                         child: VideoPlayer(_controller),
//                       ),
//                     ),
//                     Positioned(
//                       top: 0,
//                       left: 5,
//                       right: 5,
//                       child: VideoProgressIndicator(
//                         _controller,
//                         padding: EdgeInsets.symmetric(vertical: 5),
//                         allowScrubbing: true,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               floatingActionButton: FloatingActionButton(
//                 onPressed: () {
//                   // Wrap the play or pause in a call to `setState`. This ensures the
//                   // correct icon is shown.
//                   setState(() {
//                     // If the video is playing, pause it.
//                     if (_controller.value.isPlaying) {
//                       _controller.pause();
//                     } else {
//                       // If the video is paused, play it.
//                       _controller.play();
//                     }
//                   });
//                 },
//                 // Display the correct icon depending on the state of the player.
//                 child: Icon(
//                   _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                 ),
//               ),
//             )
//           // If the video is not yet initialized, display a spinner
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
// }
