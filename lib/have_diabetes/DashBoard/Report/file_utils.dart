import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileUtils {
  // Check if storage permission is granted
  static Future<bool> checkStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        return result == PermissionStatus.granted;
      }
      return true;
    } else if (Platform.isIOS) {
      // iOS doesn't need explicit permission for this operation
      return true;
    }
    return false;
  }

  // Get the download directory based on platform
  static Future<Directory?> getDownloadDirectory() async {
    try {
      if (Platform.isAndroid) {
        // For Android, use the Downloads directory
        return Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        // For iOS, use the Documents directory
        return await getApplicationDocumentsDirectory();
      }
      // Fallback to temporary directory
      return await getTemporaryDirectory();
    } catch (e) {
      debugPrint("Error getting download directory: $e");
      return null;
    }
  }

  // Create a file with the given content
  static Future<String?> createFile(String fileName, List<int> bytes) async {
    try {
      // Check permission
      if (!await checkStoragePermission()) {
        return "Storage permission denied";
      }

      // Get download directory
      final directory = await getDownloadDirectory();
      if (directory == null) {
        return "Could not access download directory";
      }

      // Create file path
      final filePath = '${directory.path}/$fileName';

      // Write to file
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      return filePath;
    } catch (e) {
      debugPrint("Error creating file: $e");
      return null;
    }
  }

  // Check if a file exists
  static Future<bool> fileExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      debugPrint("Error checking if file exists: $e");
      return false;
    }
  }

  // Delete a file
  static Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error deleting file: $e");
      return false;
    }
    }
}