// utils/video_utils.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_compress/video_compress.dart';

class VideoUtils {
  // Generate thumbnail from video file
  static Future<Uint8List?> generateVideoThumbnail(String videoPath) async {
    try {
      final thumbnail = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 500,
        quality: 25,
      );
      return thumbnail;
    } catch (e) {
      print('Error generating thumbnail: $e');
      return null;
    }
  }

  // Get video information (dimensions, duration, etc.)
  static Future<MediaInfo?> getVideoInfo(String videoPath) async {
    try {
      final videoInfo = await VideoCompress.getMediaInfo(videoPath);
      return videoInfo;
    } catch (e) {
      print('Error getting video info: $e');
      return null;
    }
  }

  // Generate thumbnail and video info together
  static Future<Map<String, dynamic>?> getVideoPosterData(
      String videoPath) async {
    try {
      final thumbnail = await generateVideoThumbnail(videoPath);
      final videoInfo = await getVideoInfo(videoPath);

      return {
        'thumbnail': thumbnail,
        'width': videoInfo?.width?.toDouble(),
        'height': videoInfo?.height?.toDouble(),
        'duration': videoInfo?.duration,
      };
    } catch (e) {
      print('Error getting video poster data: $e');
      return null;
    }
  }
}
