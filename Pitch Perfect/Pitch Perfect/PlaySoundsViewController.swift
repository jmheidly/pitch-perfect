//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jim Mhe on 4/4/15.
//  Copyright (c) 2015 Jamal Mhe. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audio: AVAudioPlayer!
    var recievedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioPlayer2:AVAudioPlayer!
    
    enum audioSpeed {
        case normal
        case fast
        case slow
    }

    
    @IBAction func echoButton(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
        audio.currentTime = 0
        let delay:NSTimeInterval = 0.1//100ms
        var playtime:NSTimeInterval
        playtime = audioPlayer2.deviceCurrentTime + delay
        audioPlayer2.stop()
        audioPlayer2.currentTime = 0
        audioPlayer2.volume = 0.8;
        audioPlayer2.playAtTime(playtime)
    }
    
    @IBAction func slowButton(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
        playAudoAtInterval(audioSpeed.slow)
    }
    
    func playAudoAtInterval(speed: audioSpeed) {
        audio.enableRate=true
        audio.stop()
        
        switch speed {
        case .normal:
            audio.rate = 1
        case .slow:
            audio.rate = 0.5
        case .fast:
            audio.rate = 1.5
        }
        
        audio.play()
    }
    
    func playAudioAtTimePitch(interval: Float) {
        audio.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode();
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch();
        changePitchEffect.pitch = interval
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    @IBAction func playChipmunkAudioButton(sender: UIButton) {
        playAudioAtTimePitch(1000);
    }
    
    
    @IBAction func playDarthvaderAudioButton(sender: UIButton) {
        playAudioAtTimePitch(-1000);
    }
    
    override func viewDidLoad() {
        audio = AVAudioPlayer(contentsOfURL: recievedAudio.filePathURL, error: nil)
        audioPlayer2 = AVAudioPlayer(contentsOfURL: recievedAudio.filePathURL, error: nil)

        audioEngine = AVAudioEngine();
        audioFile = AVAudioFile(forReading: recievedAudio.filePathURL, error: nil)
    }
    
    @IBAction func fastButton(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
        playAudoAtInterval(audioSpeed.fast)
    }
    
    @IBAction func stopButton(sender: UIButton) {
        if (audio != nil) {
            audio.stop()
        }
        if (audioPlayer2 != nil) {
        audioPlayer2.stop()
        }
        
        if(audioEngine != nil) {
            audioEngine.stop()
        }
    }
}
