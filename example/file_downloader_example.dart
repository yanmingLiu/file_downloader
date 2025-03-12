import 'package:file_downloader/file_downloader.dart';

void main() async {
  String url = "https://d2s8mov10jm2l5.cloudfront.net/sweet/video/4.mp4"; // 示例视频文件 (Example video file)

  String? filePath = await FileDownloader.download(
    url,
    folderName: 'videos', // 存储到 'videos' 文件夹 (Save in 'videos' folder)
    onProgress: (received, total) {
      print('下载进度 (Download progress)：${(received / total * 100).toStringAsFixed(0)}%');
    },
  );

  print(filePath != null ? '文件下载成功 (File downloaded successfully): $filePath' : '下载失败 (Download failed)');
}
