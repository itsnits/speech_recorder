import 'package:flutter_test/flutter_test.dart';
import 'package:speech_recorder/speech_recorder.dart';
import 'package:speech_recorder/speech_recorder_platform_interface.dart';
import 'package:speech_recorder/speech_recorder_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSpeechRecorderPlatform
    with MockPlatformInterfaceMixin
    implements SpeechRecorderPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SpeechRecorderPlatform initialPlatform = SpeechRecorderPlatform.instance;

  test('$MethodChannelSpeechRecorder is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSpeechRecorder>());
  });

  test('getPlatformVersion', () async {
    SpeechRecorder speechRecorderPlugin = SpeechRecorder();
    MockSpeechRecorderPlatform fakePlatform = MockSpeechRecorderPlatform();
    SpeechRecorderPlatform.instance = fakePlatform;

    expect(await speechRecorderPlugin.getPlatformVersion(), '42');
  });
}
