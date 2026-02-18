import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'speech_recorder_method_channel.dart';

abstract class SpeechRecorderPlatform extends PlatformInterface {
  /// Constructs a SpeechRecorderPlatform.
  SpeechRecorderPlatform() : super(token: _token);

  static final Object _token = Object();

  static SpeechRecorderPlatform _instance = MethodChannelSpeechRecorder();

  /// The default instance of [SpeechRecorderPlatform] to use.
  ///
  /// Defaults to [MethodChannelSpeechRecorder].
  static SpeechRecorderPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SpeechRecorderPlatform] when
  /// they register themselves.
  static set instance(SpeechRecorderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> speakText({
    required String text,
    double rate = 0.5,
    double pitch = 1.0,
    double volume = 0.8,
  });

  Future<String> startRecording();
  Future<String> stopRecording();
  Future<String> playRecording();
}
