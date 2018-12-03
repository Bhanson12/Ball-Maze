//
//  PauseViewController.swift
//  Ball Maze
//
//  Created by Keifer Francis on 2018-12-01.
//  Copyright © 2018 Braydon Hanson. All rights reserved.
//

import UIKit
import os.log

@IBDesignable class PauseViewController: UIViewController {

    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var sfxSwitch: UISwitch!
    @IBOutlet weak var musicSwitch: UISwitch!
    
    var settings: Settings?
    
    var option = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedSettings = loadSettings() {
            settings = savedSettings
            os_log("Loading saved settings", log: OSLog.default, type: .debug)
        }  else {
            loadDefaultSettings()
            os_log("Loading default settings", log: OSLog.default, type: .debug)
        }
        
        sfxSwitch.setOn((settings?.sfxOn)!, animated: false)
        musicSwitch.setOn((settings?.musicOn)!, animated: false)
    }

    @IBAction func sfxSwitch(_ sender: Any) {
        SFXController.sharedSFX.playClickSound()
        if((sender as AnyObject).isOn == true){
            SFXController.sharedSFX.enable()
            settings?.sfxOn = true
        } else {
            SFXController.sharedSFX.disable()
            settings?.sfxOn = false
        }
    }
    
    @IBAction func musicSwitch(_ sender: Any) {
        SFXController.sharedSFX.playClickSound()
        if((sender as AnyObject).isOn == true){
            MusicController.sharedMusic.enable()
            settings?.musicOn = true
        } else {
            MusicController.sharedMusic.disable()
            settings?.musicOn = false
        }
    }
    
    private func loadDefaultSettings() {
        
        guard let defaultSettings = Settings(user: "default", sfxOn: false, musicOn: false) else {
            fatalError("Unable to instantiate default settings")
        }
        settings = defaultSettings
    }
    
    private func loadSettings() -> Settings? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Settings.ArchiveURL.path) as? Settings
    }
    
    private func saveSettings() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(settings, toFile: Settings.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Settings successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save settings...", log: OSLog.default, type: .error)
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller based on which button is pressed
        saveSettings()
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
