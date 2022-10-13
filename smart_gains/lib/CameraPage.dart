import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'package:wakelock/wakelock.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as imglib;
import 'package:text_to_speech/text_to_speech.dart';

import 'NavBar_Base.dart';
import 'models/exercise_model.dart';
import 'websocket.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.title}) : super(key: key);
  final int title;
  @override
  State<CameraPage> createState() => _CameraPageState(title);
}

class _CameraPageState extends State<CameraPage> {
  int reps = 0;
  int exercise_idx = 0;
  _CameraPageState(int index) {
    exercise_idx = index;
  }

  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;

  // 1.
  TextToSpeech tts = TextToSpeech();
  // 2.
  String _ttsGreet = 'How may I help you?';
  // 3.
  String _ttsStaticResult = 'Its very hot today';

  final WebSocket _socket = WebSocket("ws://192.168.10.103:5000");
  bool _isConnected = false;
  bool _finishSet = false;
  bool _streaming = false;

  void connect(BuildContext context) async {
    _socket.connect();
    setState(() {
      _isConnected = true;
    });
    print("connected");

    _socket.getChannel!.sink.add(jsonEncode(
        {"type": "EXERCISE", "exercise": exercises[exercise_idx].name}));
    Wakelock.enable();
  }

  void disconnect() {
    _socket.disconnect();
    Wakelock.disable();
    setState(() {
      _isConnected = false;
    });
  }

  @override
  void initState() {
    //showModal(context);
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
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");

    print(data);

    if (data["type"] == "IN_FRAME") {
      if (data["in_frame"] == "true") {
        return Text('in frame');
      } else {
        _processRequest("Not in frame");
        return Text('not in frame');
      }
    }

    // Rep count
    if (data["type"] == "REP_DONE") {
      _processRequest(data["count"].toString());
      _processRequest(data["feedback_id"].toString());
      reps++;
      return Text('Repetition Count : ${data["count"]}');
    }

    // Set State
    if (data["type"] == "SET_STATE") {
      // Start set
      if (data["state"] == "true") {
        return Text("Starting");
      }
      // End set
      else {
        if (!_finishSet) {
          _processRequest("finished set");
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _finishSet = true;
            showReps(context);
          });
          if (_streaming) {
            _cameraController.stopImageStream();
            setState(() {
              _streaming = false;
            });
          }
        });

        return Text('Finished Set');
      }
    }
  }

  void badFrame(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop(true);
          });
          return const AlertDialog(
            title: Text("Not in frame!", style: TextStyle(color: Colors.red)),
          );
        });
  }

  void showReps(BuildContext context) {
    Widget okButton = ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      },
      child: Text('Going Back'),
    );

    Widget sendButton = ElevatedButton(
      onPressed: () {},
      child: Text('Export'),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: const [
              Text("Set Report",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38)),
            ]),
            SingleChildScrollView(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(exercises[exercise_idx].starter_pose),
                  fit: BoxFit.cover,
                )),
              ),
            )
          ],
        ),
        actions: [okButton, sendButton],
      ),
    );
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
      if (exercises[exercise_idx].name != "Pushup") {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        return Scaffold(
            body: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(top: 30),
                child: Container(
                    color: Colors.white,
                    child: Center(
                        child: Text(exercises[exercise_idx].name,
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'fonts/KronaOne-Regular.tff',
                                fontSize: 40)))),
              )),
              if (!_finishSet) ...[
                CameraPreview(_cameraController)
              ] else ...[
                const Text('Finished')
              ],
              StreamBuilder(
                stream: _socket.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _processMessage(snapshot);
                  }
                  return const Text(
                    '',
                    style: TextStyle(
                        backgroundColor: Color.fromARGB(255, 37, 171, 117)),
                  );
                },
              ),
              Expanded(
                  child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    )),
                alignment: FractionalOffset.bottomCenter,
                child: Column(children: [
                  Text(reps.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'fonts/KronaOne-Regular.tff',
                          fontSize: 50)),
                  Text("Accuracy 90%")
                ]),
              ))
            ],
          ),
        ));
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ]);
        return Scaffold(
            body: Row(
          children: [
            Expanded(
                child: Container(
                    color: Colors.white,
                    child: Center(child: Text(exercises[exercise_idx].name)))),
            CameraPreview(_cameraController),
            StreamBuilder(
              stream: _socket.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _processMessage(snapshot);
                }
                return const Text('');
              },
            ),
            Expanded(
                child: Container(
                    color: Colors.white,
                    child: Center(child: Text(exercises[exercise_idx].name)))),
          ],
        ));
      }
    }
  }
}
