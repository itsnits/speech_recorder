import 'package:flutter/material.dart';
import 'package:speech_recorder/speech_recorder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech Recorder Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SpeechRecorderDemo(),
    );
  }
}

class SpeechRecorderDemo extends StatefulWidget {
  const SpeechRecorderDemo({super.key});

  @override
  State<SpeechRecorderDemo> createState() => _SpeechRecorderDemoState();
}

class _SpeechRecorderDemoState extends State<SpeechRecorderDemo> {
  String _status = 'Ready';
  bool _isRecording = false;
  bool _isBusy = false;

  Future<void> _speak() async {
    if (_isBusy) return;
    setState(() {
      _isBusy = true;
      _status = 'Speaking...';
    });
    await SpeechRecorder.speakText(
      text: 'This is a speech recorder plugin demo.',
      rate: 0.5,
      pitch: 1.0,
      volume: 0.9,
    );
    setState(() {
      _isBusy = false;
      _status = 'Done speaking';
    });
  }

  Future<void> _toggleRecording() async {
    if (_isBusy) return;
    setState(() {
      _isBusy = true;
    });

    if (_isRecording) {
      final result = await SpeechRecorder.stopRecording();
      setState(() {
        _isRecording = false;
        _isBusy = false;
        _status = 'Recording stopped: $result';
      });
    } else {
      final result = await SpeechRecorder.startRecording();
      setState(() {
        _isRecording = true;
        _isBusy = false;
        _status = 'Recording started: $result';
      });
    }
  }

  Future<void> _play() async {
    if (_isBusy) return;
    setState(() {
      _isBusy = true;
      _status = 'Playing...';
    });
    final result = await SpeechRecorder.playRecording();
    setState(() {
      _isBusy = false;
      _status = 'Playback: $result';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Recorder Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _status,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _isBusy ? null : _speak,
              icon: const Icon(Icons.record_voice_over),
              label: const Text('Speak Text'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isBusy ? null : _toggleRecording,
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isBusy ? null : _play,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play Recording'),
            ),
          ],
        ),
      ),
    );
  }
}

