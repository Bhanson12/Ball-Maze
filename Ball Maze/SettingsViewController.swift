//
//  SettingsViewController.swift
//  Ball Maze
//
//  Created by Keifer Francis on 2018-12-01.
//  Copyright © 2018 Braydon Hanson. All rights reserved.
//

import UIKit
import os.log

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var sfxSwitch: UISwitch!
    @IBOutlet weak var musicSwitch: UISwitch!
    @IBOutlet weak var userText: UITextField!
    
    var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userText.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Main Menu", style: .plain, target: self, action: #selector(backButtonPressed))
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let savedSettings = loadSettings() {
            settings = savedSettings
            os_log("Loading saved settings", log: OSLog.default, type: .debug)
        }  else {
            loadDefaultSettings()
            os_log("Loading default settings", log: OSLog.default, type: .debug)
        }
        
        sfxSwitch.setOn((settings?.sfxOn)!, animated: false)
        musicSwitch.setOn((settings?.musicOn)!, animated: false)
        userText.text = settings?.user
    }
    
    // MARK UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        settings?.user = textField.text!
    }
    
    // MARK: IBActions
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
    
    @objc func backButtonPressed() {
        SFXController.sharedSFX.playBackSound()
        saveSettings()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Load/Save Settings
    
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
