// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom widgets

import 'dart:async';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';

class CameraPhoto1 extends StatefulWidget {
  const CameraPhoto1({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _CameraPhotoState createState() => _CameraPhotoState();
}

class _CameraPhotoState extends State<CameraPhoto1> {
  String content = '';
  CameraController? controller;
  late Future<List<CameraDescription>> _cameras;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _cameras = availableCameras();
  }

  @override
  void dispose() {
    controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  final FlutterTts flutterTts = FlutterTts();

  Future<void> pictureTakingAction(String fileBase64) async {
    // Send POST request
    var response = await http.post(
      Uri.parse(
          'https://api.openai.com/v1/chat/completions'), // OpenAI endpoint
     var response = await http.post(
  Uri.parse('https://api.openai.com/v1/chat/completions'), // OpenAI endpoint
  headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}', // Use OpenAI API key from environment variables
  },
      body: jsonEncode({
        "model": "gpt-4-vision-preview",
        "messages": [
          {
            "role": "user",
            "content": [
              {
                "type": "text",
                "text": "What’s in this image? Explain it in 10-15 words"
              },
              {
                "type": "image_url",
                "image_url": {"url": "data:image/jpeg;base64,$fileBase64"}
              }
            ]
          }
        ],
        "max_tokens": 300
      }),
    );

    // Convert response to text-to-speech
    var jsonResponse = jsonDecode(response.body);
    var newContent = jsonResponse['choices'][0]['message']['content'];
    await flutterTts.speak(newContent);

    setState(() {
      content = newContent;
    });
  }

  void startOrStopTimer() {
    Future<void> captureAndSpeak() async {
      if (controller == null || !controller!.value.isInitialized) {
        return;
      }
      final file = await controller!.takePicture();
      Uint8List fileAsBytes = await file.readAsBytes();
      final base64 = base64Encode(fileAsBytes);

      FFAppState().update(() {
        FFAppState().fileBase64 = base64;
      });

      await pictureTakingAction(base64);
    }

    if (_timer == null || !_timer!.isActive) {
      captureAndSpeak(); // Capture and speak immediately

      _timer = Timer.periodic(Duration(seconds: 9), (Timer t) async {
        await captureAndSpeak(); // Capture and speak every 6 seconds
      });
    } else {
      _timer?.cancel();
      _timer = null;
      flutterTts.stop();
    }
  }

  // ...

  // ...

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 389,
      height: 600,
      child: FutureBuilder<List<CameraDescription>>(
        future: _cameras,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              if (controller == null) {
                controller =
                    CameraController(snapshot.data![0], ResolutionPreset.max);
                controller!.initialize().then((_) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {});
                });
              }
              return controller!.value.isInitialized
                  ? Column(
                      children: [
                        Expanded(
                          child: CameraPreview(controller!),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  content,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              FloatingActionButton(
                                onPressed: startOrStopTimer,
                                child: Icon(_timer != null && _timer!.isActive
                                    ? Icons.stop
                                    : Icons.play_arrow),
                                tooltip: _timer != null && _timer!.isActive
                                    ? 'Stop'
                                    : 'Start',
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container();
            } else {
              return Center(child: Text('No cameras available.'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
