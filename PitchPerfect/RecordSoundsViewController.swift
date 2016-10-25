//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by joey frenette on 2016-06-16.
//  Copyright © 2016 joey frenette. All rights reserved.
//

import UIKit
import AVFoundation

//RecordSoundsViewController inherits from UIViewController and conforms to the AVAudioRecorderDelegate
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Do stuff before the view appears: Disable stop button
    override func viewWillAppear(animated: Bool) {
        print("view will appear loaded")
        stopButton.enabled = false
        recordingLabel.font = UIFont(name: "Times New Roman", size: CGFloat(25))
    }
    
    //Record audio button pressed
    @IBAction func recordAudio(sender: AnyObject) {
        print("record audio button pressed!")
        
        //Update UI elements on the view
        recordingLabel.text = "Say Something! 🗣🤓"
        stopButton.enabled = true
        recordButton.enabled = false
        
        //Prepare the file name and file path of where the audio data will be stored
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        //Start an AVAudioSession
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        //Start recording AVAudio with AVAudioRecorder
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self //Set the current class instance as the delegate for AVAudioRecorder
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    //Stop recording button is pressed
    @IBAction func stopRecording(sender: UIButton) {
        print("recording stopped")
        
        //Update UI elements on the view
        recordingLabel.text = "Touch me again. 😝"
        stopButton.enabled = false
        recordButton.enabled = true
        
        //Stop recording audio using AVAudioRecorder
        audioRecorder.stop()
        
        //End AVAudioSession (This will trigger the delegate function "audioRecorderDidFinishRecording")
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //Method called from AVAudioRecorderDelegate when audio is finished recording.
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecorder finished recording")
        
        //If the recording finished succesfully, then go to segue named "stopRecording" and send the URL where the audio file is located.
        if flag {
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url) }
        else {
            print("Recording failed.") }
    }
    
    //Prepares for segue and recieving the recorded audio
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //Ensure that segue is "stopRecording" and cast the destinationViewController to "PlaySoundsViewController"
        //Enable PlaySoundsViewController to recieve URL to the recorded audio
        if(segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as!
                PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
        
        
    }
}

