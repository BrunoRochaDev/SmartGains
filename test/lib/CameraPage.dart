import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'websocket.dart';
import 'package:image/image.dart' as imglib;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:text_to_speech/text_to_speech.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;

  // 1.
  TextToSpeech tts = TextToSpeech();
  // 2.
  String _ttsGreet = 'How may I help you?';
  // 3.
  String _ttsStaticResult = 'Its very hot today';

  final WebSocket _socket = WebSocket("ws://192.168.180.149:5000");
  bool _isConnected = false;
  bool _finishSet = false;
  bool _streaming = false;

  void connect(BuildContext context) async {
    _socket.connect();
    setState(() {
      _isConnected = true;
    });
    print("connected");
  }

  void disconnect() {
    _socket.disconnect();
    setState(() {
      _isConnected = false;
    });
  }

  @override
  void initState() {
    connect(context);
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _processRequest(String transcription) {
    tts.speak(transcription); //<-- SEE HERE
  }

  static const shift = (0xFF << 24);
  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.low);
    await _cameraController.initialize();
    setState(() => _isLoading = false);

    imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);

    var count = 0;
    if (!_finishSet) {
      setState(() {
        _streaming = true;
      });
      await _cameraController.startImageStream((CameraImage image) {
        count += 1;
        if (count % 5 == 1) {
          try {
            final int width = image.width;
            final int height = image.height;
            final int uvRowStride = image.planes[1].bytesPerRow;
            final int? uvPixelStride = image.planes[1].bytesPerPixel;

            // imgLib -> Image package from https://pub.dartlang.org/packages/image
            var img = imglib.Image(width, height); // Create Image buffer

            // Fill image buffer with plane[0] from YUV420_888
            for (int x = 0; x < width; x++) {
              for (int y = 0; y < height; y++) {
                if (uvPixelStride != null) {
                  final int uvIndex = uvPixelStride * (x / 2).floor() +
                      uvRowStride * (y / 2).floor();
                  final int index = y * width + x;

                  final yp = image.planes[0].bytes[index];
                  final up = image.planes[1].bytes[uvIndex];
                  final vp = image.planes[2].bytes[uvIndex];
                  // Calculate pixel color
                  int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
                  int g =
                      (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
                          .round()
                          .clamp(0, 255);
                  int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
                  // color: 0x FF  FF  FF  FF
                  //           A   B   G   R
                  img.data[index] = shift | (b << 16) | (g << 8) | r;
                }
              }
            }

            imglib.PngEncoder pngEncoder =
                new imglib.PngEncoder(level: 0, filter: 0);
            List<int> png = pngEncoder.encodeImage(img);

            var result = FlutterImageCompress.compressWithList(
                Uint8List.fromList(png),
                quality: 50);

            result.then((value) => {_socket.getChannel!.sink.add(value)});
          } catch (e) {
            print("could not send frame");
          }
        }
      });
    }
  }

  _processMessage(message) {
    Map<String, dynamic> data = jsonDecode(message.data);
    if (data["message"] == "repCount") {
      _processRequest(data["repCount"].toString());
      return Text('Repetition Count : ${data["repCount"]}');
    } else if (data["message"] == "finished") {
      if (!_finishSet) {
        _processRequest("finished set");
        _socket.getChannel!.sink.add(jsonEncode({"message": "statistics"}));
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _finishSet = true;
        });
        if (_streaming) {
          _cameraController.stopImageStream();
          setState(() {
            _streaming = false;
          });
        }
      });
      return Text('Finished Set -> Gifs: ${data["gifs"]}');
    } else if (data["message"] == "statistics") {
      return const Text("Statistics message");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_finishSet) ...[
              CameraPreview(_cameraController)
            ] else ...[
              const Text('')
            ],
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _socket.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _processMessage(snapshot);
                }
                return const Text('');
              },
            )
          ],
        ),
      ));
    }
  }
}
