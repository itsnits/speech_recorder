import Flutter
import UIKit
import AVFoundation

public class SpeechRecorderPlugin: NSObject, FlutterPlugin, AVSpeechSynthesizerDelegate, AVAudioRecorderDelegate {

  private var speechSynthesizer = AVSpeechSynthesizer()
  private var audioRecorder: AVAudioRecorder?
  private var audioPlayer: AVAudioPlayer?
  private var recordingURL: URL?
  private let audioSession = AVAudioSession.sharedInstance()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "speech_recorder", binaryMessenger: registrar.messenger())
    let instance = SpeechRecorderPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  // MARK: - Method Channel Handler
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "speakText":
      handleSpeakText(call, result)
    case "startRecording":
      handleStartRecording(result)
    case "stopRecording":
      handleStopRecording(result)
    case "playRecording":
      handlePlayRecording(result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
