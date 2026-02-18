import 'speech_recorder_platform_interface.dart';

class SpeechRecorder {
  static Future<void> speakText({
    required String text,
    double rate = 0.5,
    double pitch = 1.0,
    double volume = 0.8,
  }) {
    return SpeechRecorderPlatform.instance.speakText(
      text: text,
      rate: rate,
      pitch: pitch,
      volume: volume,
    );
  }

  static Future<String> startRecording() {
    return SpeechRecorderPlatform.instance.startRecording();
  }

  static Future<String> stopRecording() {
    return SpeechRecorderPlatform.instance.stopRecording();
  }

  static Future<String> playRecording() {
    return SpeechRecorderPlatform.instance.playRecording();
  }
}
