# 🎙️ speech_recorder

A Flutter plugin for **iOS** that provides a unified interface for **text-to-speech synthesis**, **audio recording**, and **audio playback** — all powered by Apple's native `AVFoundation` framework.

---

## ✨ Features

- 🔊 **Text-to-Speech** — Convert any text to natural-sounding speech with configurable rate, pitch, and volume
- 🎤 **Audio Recording** — Record audio from the device microphone with a simple start/stop API
- ▶️ **Audio Playback** — Play back previously recorded audio instantly
- 🍎 **Native iOS Implementation** — Built on top of `AVSpeechSynthesizer`, `AVAudioRecorder`, and `AVAudioPlayer`
- 🔌 **Platform Interface Pattern** — Follows Flutter's recommended federated plugin architecture

---

## 📱 Platform Support

| Platform | Status  |
|----------|---------|
| iOS      | ✅ Supported |
| Android  | 🚧 Not yet supported |
| Web      | 🚧 Not yet supported |
| macOS    | 🚧 Not yet supported |

---

## 🚀 Getting Started

### Installation

Add `speech_recorder` to your `pubspec.yaml`:

```yaml
dependencies:
  speech_recorder:
    path: ../speech_recorder  # or your pub.dev version once published
```

Then run:

```bash
flutter pub get
```

---

### iOS Permissions

This plugin requires microphone access for recording. Add the following key to your `ios/Runner/Info.plist`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access to record audio.</string>
```

> ⚠️ **Note:** Without this permission, `startRecording()` will fail silently on iOS devices.

**Minimum iOS version:** iOS 13.0+

---

## 📖 Usage

Import the package:

```dart
import 'package:speech_recorder/speech_recorder.dart';
```

---

### 🔊 Text-to-Speech

Speak any text aloud using the device's speech synthesizer:

```dart
await SpeechRecorder.speakText(
  text: 'Hello, world!',
  rate: 0.5,    // Speech rate: 0.0 (slowest) – 1.0 (fastest). Default: 0.5
  pitch: 1.0,   // Voice pitch: 0.5 (low) – 2.0 (high). Default: 1.0
  volume: 0.8,  // Volume: 0.0 (muted) – 1.0 (max). Default: 0.8
);
```

| Parameter | Type     | Default | Description                              |
|-----------|----------|---------|------------------------------------------|
| `text`    | `String` | —       | **Required.** The text to be spoken.     |
| `rate`    | `double` | `0.5`   | Speech rate (0.0 = slowest, 1.0 = fastest) |
| `pitch`   | `double` | `1.0`   | Voice pitch (0.5 = low, 2.0 = high)      |
| `volume`  | `double` | `0.8`   | Playback volume (0.0 = muted, 1.0 = max) |

---

### 🎤 Start Recording

Begin recording audio from the microphone:

```dart
final String result = await SpeechRecorder.startRecording();
print('Recording started: $result');
```

Returns a `String` with a status message from the native layer. Returns an empty string on failure.

---

### ⏹️ Stop Recording

Stop the active recording session:

```dart
final String result = await SpeechRecorder.stopRecording();
print('Recording stopped: $result');
```

Returns a `String` with a status message (e.g., the saved file path or a status code). Returns an empty string on failure.

---

### ▶️ Play Recording

Play the most recently recorded audio:

```dart
final String result = await SpeechRecorder.playRecording();
print('Playback result: $result');
```

Returns a `String` status message from the native layer. Returns an empty string on failure.

---

### 🧩 Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:speech_recorder/speech_recorder.dart';

class SpeechDemo extends StatefulWidget {
  const SpeechDemo({super.key});

  @override
  State<SpeechDemo> createState() => _SpeechDemoState();
}

class _SpeechDemoState extends State<SpeechDemo> {
  String _status = 'Ready';
  bool _isRecording = false;

  Future<void> _speak() async {
    setState(() => _status = 'Speaking...');
    await SpeechRecorder.speakText(
      text: 'This is a speech recorder plugin demo.',
      rate: 0.5,
      pitch: 1.0,
      volume: 0.9,
    );
    setState(() => _status = 'Done speaking');
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final result = await SpeechRecorder.stopRecording();
      setState(() {
        _isRecording = false;
        _status = 'Recording stopped: $result';
      });
    } else {
      final result = await SpeechRecorder.startRecording();
      setState(() {
        _isRecording = true;
        _status = 'Recording: $result';
      });
    }
  }

  Future<void> _play() async {
    final result = await SpeechRecorder.playRecording();
    setState(() => _status = 'Playing: $result');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speech Recorder Demo')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_status, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _speak,
              icon: const Icon(Icons.record_voice_over),
              label: const Text('Speak Text'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _toggleRecording,
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _play,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🏗️ Architecture

This plugin follows Flutter's **federated plugin** architecture:

```
speech_recorder/
├── lib/
│   ├── speech_recorder.dart                    # Public API surface
│   ├── speech_recorder_platform_interface.dart # Abstract platform interface
│   └── speech_recorder_method_channel.dart     # Method channel implementation
└── ios/
    └── Classes/
        └── SpeechRecorderPlugin.swift          # Native iOS implementation
```

| Layer | File | Role |
|-------|------|------|
| **Public API** | `speech_recorder.dart` | Exposed to consumers via static methods |
| **Platform Interface** | `speech_recorder_platform_interface.dart` | Abstract contract, enables platform swapping |
| **Method Channel** | `speech_recorder_method_channel.dart` | Dart ↔ Native bridge using `MethodChannel('speech_recorder')` |
| **Native (iOS)** | `SpeechRecorderPlugin.swift` | AVFoundation implementation for TTS, recording & playback |

---

## 🔧 Native Method Channel Reference

The method channel name is `speech_recorder`. The following methods are handled:

| Method           | Arguments                                         | Returns  |
|------------------|---------------------------------------------------|----------|
| `speakText`      | `text: String, rate: double, pitch: double, volume: double` | `void`   |
| `startRecording` | —                                                 | `String` |
| `stopRecording`  | —                                                 | `String` |
| `playRecording`  | —                                                 | `String` |

---

## 🛠️ Requirements

| Requirement    | Version    |
|----------------|------------|
| Flutter        | ≥ 3.3.0    |
| Dart SDK       | ≥ 3.0.0    |
| iOS            | ≥ 13.0     |
| Swift          | 5.0+       |

---

## 📄 License

This project is licensed under the terms found in the [LICENSE](LICENSE) file.

---

## 🗓️ Changelog

See [CHANGELOG.md](CHANGELOG.md) for a record of changes made to this plugin.

---

> Built with ❤️ using Flutter & AVFoundation
