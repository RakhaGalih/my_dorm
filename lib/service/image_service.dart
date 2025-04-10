import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_dorm/constant/constant.dart';

class MyNetworkImage extends StatelessWidget {
  final String imageURL;
  final double? width;
  final double? height;
  final BoxFit? fit;
  const MyNetworkImage({
    super.key,
    required this.imageURL,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(imageURL, width: width, height: height, fit: fit,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) {
        return child;
      } else {
        return Center(
          child: SizedBox(
            width: width,
            height: height,
            child: CircularProgressIndicator(
              color: kMain,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            ),
          ),
        );
      }
    }, errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported),
            Text(
              'Failed to load image',
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    });
  }
}

class ImageService {
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  File? getSelectedImage() {
    return selectedImage;
  }

  Future<String> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      return pickedFile.path;
    } else {
      print("No image selected");
      return '';
    }
  }

  void clearImage() {
    selectedImage = null;
  }
}
