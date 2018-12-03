//
//  PauseViewController.swift
//  Ball Maze
//
//  Created by Keifer Francis on 2018-12-01.
//  Copyright © 2018 Braydon Hanson. All rights reserved.
//

import UIKit

@IBDesignable class PauseViewController: UIViewController {

    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    
    var option = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func sfxSwitch(_ sender: Any) {
        SFXController.sharedSFX.playClickSound()
        if((sender as AnyObject).isOn == true){
            if(SFXController.sharedSFX.isEnabled()!){
                
            } else {
                SFXController.sharedSFX.enable()
            }
        } else {
            if(SFXController.sharedSFX.isEnabled()!){
                SFXController.sharedSFX.disable()
            } else {
                
            }
        }
    }
    
    @IBAction func musicSwitch(_ sender: Any) {
        SFXController.sharedSFX.playClickSound()
        if((sender as AnyObject).isOn == true){
            if(MusicController.sharedMusic.isPlaying()!){
                
            } else {
                MusicController.sharedMusic.play()
            }
        } else {
            if(MusicController.sharedMusic.isPlaying()!){
                MusicController.sharedMusic.stop()
            } else {
                
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller based on which button is pressed
        if let button = sender as? UIButton, button === resumeButton {
            SFXController.sharedSFX.playUnpauseSound()
            option = 0
        } else if let button = sender as? UIButton, button === restartButton {
            SFXController.sharedSFX.playStartSound()
            option = 1
        } else if let button = sender as? UIButton, button === exitButton {
            SFXController.sharedSFX.playQuitSound()
            option = 2
        } else {
            return
        }
    }
}
