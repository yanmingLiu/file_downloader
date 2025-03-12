# 📥 file_downloader

🚀 一个 **支持断点续传**、**多格式下载** 的 Dart/Flutter 下载工具，适用于 **MP3、MP4、PDF、ZIP 等文件**。

<p align="center">
  <img src="https://raw.githubusercontent.com/yanmingLiu/file_downloader/main/assets/banner.png" alt="File Downloader" width="600"/>
</p>

📂 **支持所有文件类型** | ⏳ **断点续传** | 🚀 **轻量高效** | 🔧 **可自定义存储路径**  

---

## ✨ **特性 (Features)**  

✅ **支持所有文件格式**（音频、视频、图片、文档等）  
✅ **支持断点续传**（中断后可继续下载）  
✅ **自定义下载目录**（存储到 `downloads/` 、 `videos/` 等文件夹）  
✅ **文件自动命名**（优先从 URL 提取，否则使用哈希值）  
✅ **轻量 & 高效**（基于 `Dio` + `path_provider` ）  

---

## 📦 **安装 (Installation)**  

在 `pubspec.yaml` 中添加：  

```yaml
dependencies:
  file_downloader:
    git:
      url: https://github.com/yanmingLiu/file_downloader.git
```

然后运行：  

```sh
flutter pub get
```

---

## 🚀 **使用 (Usage)**  

### **📌 基础下载示例**

```dart
import 'package:file_downloader/file_downloader.dart';

void main() async {
  String url = "https://example.com/sample.mp4"; // 示例下载链接

  String? filePath = await FileDownloader.download(
    url,
    folderName: 'videos', // 存储到 'videos' 目录
    onProgress: (received, total) {
      print('下载进度：\${(received / total * 100).toStringAsFixed(0)}%');
    },
  );

  if (filePath != null) {
    print('📥 文件下载成功: $filePath');
  } else {
    print('❌ 下载失败');
  }
}
```

---

## 📂 **文件存储路径**

| 平台 | 存储路径 |
|------|----------|
| Android | `/data/user/0/com.example.app/files/your_folder_name` |
| iOS | `Documents/your_folder_name` |
| MacOS | `~/Library/Containers/com.example.app/Data/Documents/your_folder_name` |
| Windows | `C:\\Users\\YourUser\\AppData\\Roaming\\your_folder_name` |

---

## ⚙️ **高级用法**

### **📌 指定文件名**

```dart
await FileDownloader.download(
  "https://example.com/audio.mp3",
  folderName: 'audios',
  customFileName: 'my_song.mp3',
);
```

### **📌 获取下载进度**

```dart
await FileDownloader.download(
  "https://example.com/large.zip",
  folderName: 'downloads',
  onProgress: (received, total) {
    double progress = (received / total * 100);
    print('📊 下载进度: \${progress.toStringAsFixed(2)}%');
  },
);
```

---

## 🤝 **贡献 (Contributing)**

欢迎任何形式的贡献！请提交 Pull Request 或 Issue 🙌

1. Fork 代码仓库
2. 创建新分支 (`git checkout -b feature-branch`)
3. 提交更改 (`git commit -m '新增功能'`)
4. 推送 (`git push origin feature-branch`)
5. 提交 Pull Request

---

## 📄 **许可证 (License)**

MIT License. 详情请参考 [LICENSE](https://github.com/yanmingLiu/file_downloader/blob/main/LICENSE)。

📌 **GitHub 仓库**: [file_downloader](https://github.com/yanmingLiu/file_downloader)
