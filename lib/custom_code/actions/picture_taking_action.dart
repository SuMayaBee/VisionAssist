// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';

Future<void> pictureTakingAction(String fileBase64) async {
  final FlutterTts flutterTts = FlutterTts();

  // Send POST request
  var response = await http.post(
    Uri.parse('https://api.openai.com/v1/chat/completions'), // OpenAI endpoint
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'Bearer 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', // Replace with your OpenAI API key
    },
    body: jsonEncode({
      "model": "gpt-4-vision-preview",
      "messages": [
        {
          "role": "user",
          "content": [
            {"type": "text", "text": "What’s in this image?"},
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
  var content = jsonResponse['choices'][0]['message']['content'];
  await flutterTts.speak(content);
}

Timer? _timer;

void startOrStopTimer() {
  if (_timer == null || !_timer!.isActive) {
    _timer = Timer.periodic(Duration(seconds: 9), (Timer t) async {
      String fileBase64 =
          FFAppState().fileBase64; // Get the base64 string from FFAppState
      await pictureTakingAction(fileBase64);
    });
  } else {
    _timer?.cancel();
    _timer = null;
  }
}
