import 'package:flutter/material.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  bool _makePhoto = false;
  bool get makePhoto => _makePhoto;
  set makePhoto(bool value) {
    _makePhoto = value;
  }

  String _fileBase64 = '';
  String get fileBase64 => _fileBase64;
  set fileBase64(String value) {
    _fileBase64 = value;
  }

  String _sstSendText = '';
  String get sstSendText => _sstSendText;
  set sstSendText(String value) {
    _sstSendText = value;
  }

  String _btnTalk = 'Talk';
  String get btnTalk => _btnTalk;
  set btnTalk(String value) {
    _btnTalk = value;
  }

  String _stt = 'Speak...';
  String get stt => _stt;
  set stt(String value) {
    _stt = value;
  }

  String _tts = '';
  String get tts => _tts;
  set tts(String value) {
    _tts = value;
  }
}
