import 'dart:io';

import 'package:file_downloader/file_downloader.dart';
import 'package:test/test.dart';

void main() {
  test('测试文件下载 (Test file download)', () async {
    String url = "https://sample-videos.com/audio/mp3/crowd-cheering.mp3"; // MP3 示例
    String folderName = 'test_downloads';

    String? filePath = await FileDownloader.download(url, folderName: folderName);

    expect(filePath, isNotNull); // 断言文件路径不为空
    expect(File(filePath!).existsSync(), isTrue); // 断言文件存在
  });

  test('测试断点续传 (Test resumable download)', () async {
    String url = "https://d2s8mov10jm2l5.cloudfront.net/sweet/video/4.mp4";
    String folderName = 'test_downloads';

    // 第一次下载（部分下载）
    String? firstDownload = await FileDownloader.download(url, folderName: folderName);
    expect(firstDownload, isNotNull);

    // 第二次下载（断点续传）
    String? resumedDownload = await FileDownloader.download(url, folderName: folderName);
    expect(resumedDownload, equals(firstDownload)); // 断言路径一致
  });
}
