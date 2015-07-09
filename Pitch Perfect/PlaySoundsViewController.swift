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
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    func playAudio() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        playSlowButton.enabled = false
        playFastButton.enabled = false
        playLowPitchButton.enabled = false
        playHighPitchButton.enabled = false
        stopButton.enabled = true
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.rate = 0.5
        playAudio()
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
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
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        playSlowButton.enabled = false
        playFastButton.enabled = false
        playLowPitchButton.enabled = false
        playHighPitchButton.enabled = false
        stopButton.enabled = true
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        playSlowButton.enabled = true
        playFastButton.enabled = true
        playLowPitchButton.enabled = true
        playHighPitchButton.enabled = true
        stopButton.enabled = false
    }
}
