import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'app_constants.dart';

class PickedMedia {
  const PickedMedia(
      {required this.name, required this.path, required this.isVideo});

  final String name;
  final String path;
  final bool isVideo;
}

class PickedMediaResult {
  const PickedMediaResult(this.files, this.skippedTooLarge);

  final List<PickedMedia> files;
  final int skippedTooLarge;
}

class MediaPicker {
  MediaPicker._();

  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickAvatar() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 80,
    );
    return file?.path;
  }

  static Future<PickedMediaResult> pickMedia() async {
    final files = await _picker.pickMultipleMedia(imageQuality: 85);
    final picked = <PickedMedia>[];
    var skipped = 0;
    for (final file in files) {
      final size = await File(file.path).length();
      if (size > AppConstants.maxAttachmentMb * 1024 * 1024) {
        skipped++;
        continue;
      }
      final lower = file.path.toLowerCase();
      final isVideo = lower.endsWith('.mp4') ||
          lower.endsWith('.mov') ||
          lower.endsWith('.m4v') ||
          (file.mimeType?.startsWith('video') ?? false);
      picked
          .add(PickedMedia(name: file.name, path: file.path, isVideo: isVideo));
    }
    return PickedMediaResult(picked, skipped);
  }
}
