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
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    enum RecordingState { case recording, notRecording }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configRecord(.notRecording)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configRecord(_ recordState: RecordingState) {
        switch(recordState) {
        case .recording:
            recordButton.isEnabled = false
            stopButton.isEnabled = true
        case .notRecording:
            recordButton.isEnabled = true
            stopButton.isEnabled = false
        }
    }
    
    @IBAction func recordButton(_ sender: Any) {
        labelRecord.text = "Recording in Progress"
        configRecord(.recording)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string:pathArray.joined(separator:"/"))
        
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
        configRecord(.notRecording)
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
        if segue.identifier == "stopButton" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}

