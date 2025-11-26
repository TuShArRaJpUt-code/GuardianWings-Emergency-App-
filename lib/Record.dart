// import 'package:flutter/material.dart';
// import 'package:record/record.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: AudioRecorderScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class AudioRecorderScreen extends StatefulWidget {
//   const AudioRecorderScreen({super.key});
//
//   @override
//   State<AudioRecorderScreen> createState() => _AudioRecorderScreenState();
// }
//
// class _AudioRecorderScreenState extends State<AudioRecorderScreen> {
//   final _recorder = AudioRecorder();
//   bool _isRecording = false;
//   String? _filePath;
//
//   Future<String> _getDownloadPath() async {
//     if (Platform.isAndroid) {
//       // Get external storage directory (Android)
//       Directory? directory = await getExternalStorageDirectory();
//       String newPath = '';
//       if (directory != null) {
//         List<String> paths = directory.path.split('/');
//         // Navigate to Downloads folder
//         for (int i = 1; i < paths.length; i++) {
//           String folder = paths[i];
//           if (folder == 'Android') break;
//           newPath += '/$folder';
//         }
//         newPath += '/Download';
//       }
//       Directory downloadsDir = Directory(newPath);
//       if (!await downloadsDir.exists()) {
//         await downloadsDir.create(recursive: true);
//       }
//       return downloadsDir.path;
//     } else {
//       // iOS fallback: save in app documents
//       Directory dir = await getApplicationDocumentsDirectory();
//       return dir.path;
//     }
//   }
//
//   Future<void> _startRecording() async {
//     if (await _recorder.hasPermission()) {
//       final dirPath = await _getDownloadPath();
//       String path =
//           '$dirPath/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
//       await _recorder.start(
//         const RecordConfig(encoder: AudioEncoder.aacLc),
//         path: path,
//       );
//       setState(() {
//         _isRecording = true;
//         _filePath = path;
//       });
//     }
//   }
//
//   Future<void> _stopRecording() async {
//     final path = await _recorder.stop();
//     setState(() => _isRecording = false);
//
//     if (path != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Recording saved at: $path')),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _recorder.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Sound Recorder")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               _isRecording ? Icons.mic : Icons.mic_none,
//               color: _isRecording ? Colors.red : Colors.blue,
//               size: 100,
//             ),
//             const SizedBox(height: 40),
//             ElevatedButton.icon(
//               onPressed: _isRecording ? _stopRecording : _startRecording,
//               icon: Icon(_isRecording ? Icons.stop : Icons.fiber_manual_record),
//               label: Text(_isRecording ? "Stop Recording" : "Start Recording"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: _isRecording ? Colors.red : Colors.green,
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//               ),
//             ),
//             if (_filePath != null) ...[
//               const SizedBox(height: 20),
//               const Text(
//                 "Last saved file:",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Text(_filePath ?? ''),
//             ]
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecorderService {
  final _recorder = AudioRecorder();
  bool _isRecording = false;
  String? _filePath;

  bool get isRecording => _isRecording;
  String? get filePath => _filePath;

  // --- Get download path (Android/iOS) ---
  Future<String> _getDownloadPath() async {
    if (Platform.isAndroid) {
      Directory? directory = await getExternalStorageDirectory();
      String newPath = '';
      if (directory != null) {
        List<String> paths = directory.path.split('/');
        for (int i = 1; i < paths.length; i++) {
          String folder = paths[i];
          if (folder == 'Android') break;
          newPath += '/$folder';
        }
        newPath += '/Download';
      }
      Directory downloadsDir = Directory(newPath);
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }
      return downloadsDir.path;
    } else {
      Directory dir = await getApplicationDocumentsDirectory();
      return dir.path;
    }
  }

  // --- Start recording ---
  Future<void> startRecording() async {
    if (await _recorder.hasPermission()) {
      final dirPath = await _getDownloadPath();
      String path =
          '$dirPath/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );
      _filePath = path;
      _isRecording = true;
    }
  }

  // --- Stop recording ---
  Future<String?> stopRecording() async {
    final path = await _recorder.stop();
    _isRecording = false;
    return path ?? _filePath;
  }

  // --- Dispose recorder ---
  void dispose() {
    _recorder.dispose();
  }
}
