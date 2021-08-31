import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewer extends StatelessWidget {
  final File file;

  const PhotoViewer({Key key, this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(file);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: PhotoView(
                  enableRotation: true, imageProvider: FileImage(file)),
            ),
          ],
        ),
      ),
    );
  }
}
