//
//  ViewController.swift
//  Ball Maze
//
//  Created by Keifer Francis on 2018-12-01.
//  Copyright © 2018 Braydon Hanson. All rights reserved.
//

import UIKit
import SceneKit
import AVKit
import os.log

var music:AVAudioPlayer?

class MenuViewController: UIViewController {

    @IBOutlet weak var StartBut: UIButton!
    @IBOutlet weak var LBBut: UIButton!
    @IBOutlet weak var userText: UILabel!
    
    var settings: Settings?
    
    var GameView: GameViewController!
    var PauseMenu: PauseViewController!
    var MainMenu: MenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedSettings = loadSettings() {
            settings = savedSettings
            os_log("Loading saved settings", log: OSLog.default, type: .debug)
        }  else {
            loadDefaultSettings()
            os_log("Loading default settings", log: OSLog.default, type: .debug)
        }
        
        if(settings!.musicOn) {
            MusicController.sharedMusic.enable()
        } else {
            MusicController.sharedMusic.disable()
        }
        if(settings!.sfxOn){
            SFXController.sharedSFX.enable()
        } else {
            SFXController.sharedSFX.disable()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userText.text = "Current User: " + (settings?.user)!
    }
    
    @IBAction func StartButton(_ sender: Any) {
        SFXController.sharedSFX.playStartSound()
    }
    
    @IBAction func LBButton(_ sender: Any) {
        SFXController.sharedSFX.playButtonSound()
    }
    
    @IBAction func SettingsButton(_ sender: Any) {
        SFXController.sharedSFX.playButtonSound()
    }
    

    
    
    // MARK: - Navigation

    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
 
    }
    
    private func loadDefaultSettings() {
        
        guard let defaultSettings = Settings(user: "default", sfxOn: true, musicOn: true) else {
            fatalError("Unable to instantiate default settings")
        }
        settings = defaultSettings
    }
    
    private func loadSettings() -> Settings? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Settings.ArchiveURL.path) as? Settings
    }
}

