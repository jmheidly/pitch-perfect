//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jim Mhe on 4/3/15.
//  Copyright (c) 2015 Jamal Mhe. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    @IBOutlet var recording: UILabel!
    @IBOutlet var recordbutton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var pauseResumeButton: UIButton!
    
    enum Resumable {
        case Resume
        case Pause
    }
    
    func pauseOrResume(resumable: Resumable, hide: Bool) {
        if !hide {
            if (pauseResumeButton.titleLabel?.text == "Pause") {
                if (audioRecorder !== nil && audioRecorder.recording) {
                    audioRecorder.pause()
                    pauseResumeButton.setTitle("Resume", forState: nil)
                }
            }else if (pauseResumeButton.titleLabel?.text == "Resume") {
                if (audioRecorder !== nil && !audioRecorder.recording) {
                    audioRecorder.record()
                }
                pauseResumeButton.setTitle("Pause", forState: nil)
            }
        } else {
            pauseResumeButton.hidden=true
        }
    }
    
    @IBAction func pauseResume(sender: UIButton) {
        if (pauseResumeButton.titleLabel?.text == "Pause") {
            pauseOrResume(Resumable.Resume,hide: false)
        } else if (pauseResumeButton.titleLabel?.text == "Resume") {
            pauseOrResume(Resumable.Pause,hide: false)
        }
    }
    
    
    @IBAction func stop(sender: UIButton) {
        pauseResumeButton.hidden=true
        stopButton.hidden=false
        audioRecorder.stop()
        recordbutton.enabled=true
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        pauseOrResume(Resumable.Pause,hide: true)
        
    }
    
    func recordAudio() {

        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        pauseResumeButton.hidden=false
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundVD: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundVD.recievedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag){
            recordedAudio = RecordedAudio(FilePathURL: recorder.url ,Title: recorder.url.lastPathComponent)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            recordbutton.enabled=true
            stopButton.hidden=true
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        stopButton.hidden=false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        stopButton.hidden=true
        recordbutton.enabled=true
        recording.text = "Tap To Record"
        recording.sizeToFit()
        pauseOrResume(Resumable.Pause,hide: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        recording.text="Recording in Progress"
        pauseOrResume(Resumable.Pause, hide: false)
        recording.sizeToFit()
        stopButton.hidden=false
        recordbutton.enabled=false
        recordAudio()
    }

    
}

