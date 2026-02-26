import Flutter
import UIKit
import AVFoundation

@objc class SpeechRecorderPlugin: NSObject, FlutterPlugin, AVAudioRecorderDelegate {
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "speech_recorder", binaryMessenger: registrar.messenger())
        let instance = SpeechRecorderPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    // MARK: - Properties
    private var ttsSynthesizer = AVSpeechSynthesizer()
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordingURL: URL?
    private var recordingSession = AVAudioSession.sharedInstance()
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "speakText": handleSpeakText(call, result)
        case "startRecording": handleStartRecording(result)
        case "stopRecording": handleStopRecording(result)
        case "playRecording": handlePlayRecording(result)
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - TTS (Reference pronunciation)
    private func handleSpeakText(_ call: FlutterMethodCall, _ result: FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let text = args["text"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing text", details: nil))
            return
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = Float((args["rate"] as? Double) ?? 0.5)
        utterance.pitchMultiplier = Float((args["pitch"] as? Double) ?? 1.0)
        utterance.volume = Float((args["volume"] as? Float) ?? 0.8)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        ttsSynthesizer.speak(utterance)
        result(nil)
    }
    
    // MARK: - Recording (User pronunciation)
    private func handleStartRecording(_ result: @escaping FlutterResult) {
        setupAudioSession { error in
            if let error = error {
                result(FlutterError(code: "AUDIO_SESSION", message: error.localizedDescription, details: nil))
                return
            }
            self.startRecorder { error in
                if let error = error {
                    result(FlutterError(code: "RECORDING_ERROR", message: error.localizedDescription, details: nil))
                } else {
                    result("recording_started")
                }
            }
        }
    }
    
    private func handleStopRecording(_ result: @escaping FlutterResult) {
        audioRecorder?.stop()
        audioRecorder = nil
        try? recordingSession.setActive(false)
        result(recordingURL?.path ?? FlutterError(code: "NO_RECORDING", message: "No recording", details: nil))
    }
    
    private func handlePlayRecording(_ result: @escaping FlutterResult) {
        guard let url = recordingURL, FileManager.default.fileExists(atPath: url.path) else {
            result(FlutterError(code: "NO_FILE", message: "No recording file", details: nil))
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            result("playback_started")
        } catch {
            result(FlutterError(code: "PLAYBACK_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    // MARK: - Helpers
    private func setupAudioSession(completion: @escaping (Error?) -> Void) {
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try recordingSession.setActive(true)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    private func startRecorder(completion: @escaping (Error?) -> Void) {
        recordingURL = FileManager.default.temporaryDirectory.appendingPathComponent("speech_\(Date().timeIntervalSince1970).m4a")
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL!, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Speech recording finished: \(flag)")
    }
}
