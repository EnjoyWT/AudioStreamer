//
//  TimePitchStreamer.swift
//  TimePitchStreamer
//
//  Created by Syed Haris Ali on 6/5/18.
//  Copyright © 2018 Ausome Apps LLC. All rights reserved.
//

import AudioStreamer
import AVFoundation
import Foundation
//
///// The `TimePitchStreamer` demonstrates how to subclass the `Streamer` and add a time/pitch shift effect.
// final class TimePitchStreamer: Streamer {
//
//    /// An `AVAudioUnitTimePitch` used to perform the time/pitch shift effect
//    let timePitchNode = AVAudioUnitTimePitch()
//
//    /// A `Float` representing the pitch of the audio
//    var pitch: Float {
//        get {
//            return timePitchNode.pitch
//        }
//        set {
//            timePitchNode.pitch = newValue
//        }
//    }
//
//    /// A `Float` representing the playback rate of the audio
//    var rate: Float {
//        get {
//            return timePitchNode.rate
//        }
//        set {
//            timePitchNode.rate = newValue
//        }
//    }
//
//    // MARK: - Methods
//
//    override func attachNodes() {
//        super.attachNodes()
//        engine.attach(timePitchNode)
//    }
//
//    override func connectNodes() {
//        engine.connect(playerNode, to: timePitchNode, format: readFormat)
//        engine.connect(timePitchNode, to: engine.mainMixerNode, format: readFormat)
//    }
//
// }
// import AudioStreamer
import Speech

/// The `TimePitchStreamer` demonstrates how to subclass the `Streamer` and add a time/pitch shift effect.
final class TimePitchStreamer: Streamer {
    /// An `AVAudioUnitTimePitch` used to perform the time/pitch shift effect
    let timePitchNode = AVAudioUnitTimePitch()
    
    lazy var inputNode = engine.inputNode
    
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))

    /// A `Float` representing the pitch of the audio
    var pitch: Float {
        get {
            return timePitchNode.pitch
        }
        set {
            timePitchNode.pitch = newValue
        }
    }
    
    /// A `Float` representing the playback rate of the audio
    var rate: Float {
        get {
            return timePitchNode.rate
        }
        set {
            timePitchNode.rate = newValue
        }
    }
    
    // MARK: - Methods
    
    override func attachNodes() {
        super.attachNodes()
        engine.attach(timePitchNode)
        configInputNode()
    }
    
    func configInputNode() {
        do {
            request.requiresOnDeviceRecognition = true
            recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { [weak self] result, error in
                if let result = result {
                    let transcription = result.bestTranscription.formattedString
                    print("识别结果：\(transcription)")
                   
                } else if let error = error as? NSError {
                    print("识别错误：\(error)")
//                    if error.code == 301 {
//                        print("Recognition request was canceled")
//                    } else {
//
//                    }
                }
            })

            try inputNode.setVoiceProcessingEnabled(true)

            inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputNode.outputFormat(forBus: 0)) { [weak self] buffer, _ in
                self?.request.append(buffer)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func connectNodes() {
        engine.connect(playerNode, to: timePitchNode, format: readFormat)
        engine.connect(timePitchNode, to: engine.mainMixerNode, format: readFormat)
    }
}
