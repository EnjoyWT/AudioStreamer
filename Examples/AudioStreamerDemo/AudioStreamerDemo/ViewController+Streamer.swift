//
//  ViewController+Streamer.swift
//  AudioStreamerDemo
//  Created by JoyTim on 2024/3/7
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//
    
import AudioStreamer
import Foundation
import os.log
import UIKit

extension ViewController: StreamingDelegate {
    func streamer(_ streamer: Streaming, failedDownloadWithError error: Error, forURL url: URL) {
        os_log("%@ - %d [%@]", log: ViewController.logger, type: .debug, #function, #line, error.localizedDescription)
        
        let alert = UIAlertController(title: "Download Failed", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        show(alert, sender: self)
    }
    
    func streamer(_ streamer: Streaming, updatedDownloadProgress progress: Float, forURL url: URL) {
        os_log("下载进度=%@ - %d [%.2f]", log: ViewController.logger, type: .debug, #function, #line, progress)
        
//        self.progressSlider.progress  = 1
//        DispatchQueue.main.async {
//            self.progressSlider.progress = progress
//
//        }
    }
    
    func streamer(_ streamer: Streaming, changedState state: StreamingState) {
        os_log("%@ - %d [%@]", log: ViewController.logger, type: .debug, #function, #line, String(describing: state))
        
        switch state {
        case .playing:
            playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        case .paused, .stopped:
            playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
    }
    
    func streamer(_ streamer: Streaming, updatedCurrentTime currentTime: TimeInterval) {
        os_log("%@ - %d [%@]", log: ViewController.logger, type: .debug, #function, #line, currentTime.toMMSS())
        
        if !isSeeking {
            progressSlider.value = Float(currentTime)
            currentTimeLabel.text = currentTime.toMMSS()
        }
    }
    
    func streamer(_ streamer: Streaming, updatedDuration duration: TimeInterval) {
        let formattedDuration = duration.toMMSS()
        os_log("%@ - %d [%@]", log: ViewController.logger, type: .debug, #function, #line, formattedDuration)
        
        durationTimeLabel.text = formattedDuration
        durationTimeLabel.isEnabled = true
        playButton.isEnabled = true
        progressSlider.isEnabled = true
        progressSlider.minimumValue = 0.0
        progressSlider.maximumValue = Float(duration)
    }
}
