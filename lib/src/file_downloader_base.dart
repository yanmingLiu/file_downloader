library file_downloader;

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileDownloader {
  static final Dio _dio = Dio();

  /// 下载文件（支持断点续传）
  /// Download file (support resumable downloads)
  ///
  /// - [url]: 远程文件 URL (Remote file URL)
  /// - [folderName]: 存储目录，默认 `downloads` (Storage directory, default: `downloads`)
  /// - [customFileName]: 自定义文件名，可选 (Custom file name, optional)
  /// - [onProgress]: 下载进度回调 (Download progress callback)
  static Future<String?> download(
    String url, {
    String folderName = 'downloads',
    String? customFileName,
    Function(int received, int total)? onProgress,
  }) async {
    try {
      // 获取存储目录 (Get storage directory)
      Directory docDir = await getApplicationDocumentsDirectory();
      String folderPath = path.join(docDir.path, folderName);
      Directory(folderPath).createSync(recursive: true);

      // 解析文件名（优先使用自定义名称）(Parse filename, prioritize custom name)
      String fileName = customFileName ?? _extractFileName(url);
      String filePath = path.join(folderPath, fileName);
      filePath = path.normalize(filePath);

      File file = File(filePath);
      int existingFileSize = file.existsSync() ? file.lengthSync() : 0;

      // 获取远程文件大小 (Get remote file size)
      int totalFileSize = await _getFileSize(url);
      if (existingFileSize > 0 && existingFileSize == totalFileSize) {
        print('[FileDownloader] 文件已完整存在: $filePath');
        print('[FileDownloader] File already fully downloaded: $filePath');
        return filePath;
      }

      // 发送断点续传请求 (Send resumable download request)
      Response<ResponseBody> response = await _dio.get<ResponseBody>(
        url,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            if (existingFileSize > 0) 'Range': 'bytes=$existingFileSize-',
          },
        ),
      );

      // 追加写入文件 (Append data to file)
      RandomAccessFile raf = file.openSync(mode: FileMode.append);
      int received = existingFileSize;
      int total = totalFileSize;

      await for (var chunk in response.data!.stream) {
        raf.writeFromSync(chunk);
        received += chunk.length;
        onProgress?.call(received, total);
      }
      await raf.close();

      print('[FileDownloader] 下载完成: $filePath');
      print('[FileDownloader] Download completed: $filePath');
      return filePath;
    } catch (e) {
      print('[FileDownloader] 下载失败: $e, URL: $url');
      print('[FileDownloader] Download failed: $e, URL: $url');
      return null;
    }
  }

  /// 获取远程文件大小
  /// Get remote file size
  static Future<int> _getFileSize(String url) async {
    try {
      Response response = await _dio.head(url);
      return int.tryParse(response.headers.value('content-length') ?? '0') ?? 0;
    } catch (e) {
      print('[FileDownloader] 获取文件大小失败: $e');
      print('[FileDownloader] Failed to get file size: $e');
      return 0;
    }
  }

  /// 解析文件名（如果 URL 没有文件名，则用哈希值代替）
  /// Extract filename from URL, use hash if no filename found
  static String _extractFileName(String url) {
    Uri uri = Uri.parse(url);
    String fileName = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
    if (fileName.isEmpty || !fileName.contains('.')) {
      fileName = _generateFileHash(url);
    }
    return fileName;
  }

  /// 生成基于 URL 的哈希文件名
  /// Generate hashed filename based on URL
  static String _generateFileHash(String url) {
    var bytes = utf8.encode(url);
    var hash = sha256.convert(bytes).toString();
    return hash.substring(0, 16);
  }
}
