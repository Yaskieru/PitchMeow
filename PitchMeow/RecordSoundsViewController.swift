//
//  RecordSoundsViewController.swift
//  PitchMeow
//
//  Created by Yasmin Almario on 27/05/2018.
//  Copyright © 2018 Yasmin Almario. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudioURL: URL!

    @IBOutlet weak var labelRecord: UILabel!
    @IBOutlet weak var recordOutlet: UIButton!
    @IBOutlet weak var StopOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        StopOutlet.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }


    @IBAction func recordButton(_ sender: Any) {
        labelRecord.text = "Recording in Progress"
        StopOutlet.isEnabled = true
        recordOutlet.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        //print(filePath as Any)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopButton(_ sender: Any) {
        labelRecord.text = "Tap to Record"
        StopOutlet.isEnabled = false
        recordOutlet.isEnabled = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
             performSegue(withIdentifier: "stopButton", sender: audioRecorder.url)
        } else {
            print("Recording not successful :(")
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopButton"{
            let playSoundsVC = segue.destination as! PlaySoundViewController
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}

