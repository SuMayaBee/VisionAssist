// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_tts/flutter_tts.dart';

Future talkToMe() async {
  FlutterTts flutterTts = FlutterTts();
  flutterTts.setLanguage("en-US");
  // flutterTts.setVoice({"name": "Wavenet-A", "locale": "en-US"});
  String text = FFAppState().tts;
  flutterTts.speak(text);
}
