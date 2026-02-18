import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'speech_recorder_platform_interface.dart';

/// An implementation of [SpeechRecorderPlatform] that uses method channels.
class MethodChannelSpeechRecorder extends SpeechRecorderPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('speech_recorder');

  @override
  Future<void> speakText({
    required String text,
    double rate = 0.5,
    double pitch = 1.0,
    double volume = 0.8,
  }) async {
    try {
      await methodChannel.invokeMethod('speakText', {
        'text': text,
        'rate': rate,
        'pitch': pitch,
        'volume': volume,
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to speak text: ${e.message}');
    }
  }

  @override
  Future<String> startRecording() async {
    try {
      final result = await methodChannel.invokeMethod<String>('startRecording');
      return result ?? '';
    } on PlatformException catch (e) {
      debugPrint('Failed to start recording: ${e.message}');
      return '';
    }
  }

  @override
  Future<String> stopRecording() async {
    try {
      final result = await methodChannel.invokeMethod<String>('stopRecording');
      return result ?? '';
    } on PlatformException catch (e) {
      debugPrint('Failed to stop recording: ${e.message}');
      return '';
    }
  }

  @override
  Future<String> playRecording() async {
    try {
      final result = await methodChannel.invokeMethod<String>('playRecording');
      return result ?? '';
    } on PlatformException catch (e) {
      debugPrint('Failed to play recording: ${e.message}');
      return '';
    }
  }
}
