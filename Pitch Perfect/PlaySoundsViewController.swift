//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Marius Horga on 7/8/15.
//  Copyright © 2015 Marius Horga. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playSlowButton: UIButton!
    @IBOutlet weak var playFastButton: UIButton!
    @IBOutlet weak var playLowPitchButton: UIButton!
    @IBOutlet weak var playHighPitchButton: UIButton!
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioPlayerNode: AVAudioPlayerNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.enabled = false
        audioPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading: receivedAudio.filePathUrl)
        // forces the device to play audio on the speaker, not on the earpiece
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        } catch _ {
            print("Error")
        }
    }
    
    func buttonsInPlayMode() {
        playSlowButton.enabled = false
        playFastButton.enabled = false
        playLowPitchButton.enabled = false
        playHighPitchButton.enabled = false
        stopButton.enabled = true
    }
    
    func buttonsInRecordMode() {
        playSlowButton.enabled = true
        playFastButton.enabled = true
        playLowPitchButton.enabled = true
        playHighPitchButton.enabled = true
        stopButton.enabled = false
    }
    
    func resetAudioEngineAndPlayer() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudio() {
        resetAudioEngineAndPlayer()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        buttonsInPlayMode()
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        resetAudioEngineAndPlayer()
        audioPlayer.rate = 0.5
        playAudio()
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        resetAudioEngineAndPlayer()
        audioPlayer.rate = 1.5
        playAudio()
    }
    
    @IBAction func playHighPitchAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playLowPitchAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        resetAudioEngineAndPlayer()
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch _ {
            print("Error")
        }
        audioPlayerNode.play()
        buttonsInPlayMode()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        resetAudioEngineAndPlayer()
        buttonsInRecordMode()
    }
}
