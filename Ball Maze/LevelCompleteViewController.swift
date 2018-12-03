//
//  LevelCompleteViewController.swift
//  Ball Maze
//
//  Created by Keifer Francis on 2018-12-02.
//  Copyright © 2018 Braydon Hanson. All rights reserved.
//

import UIKit
import os.log

class LevelCompleteViewController: UIViewController {

    @IBOutlet weak var scoreText: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
 
    
    var option = 0
    var scoreIn: Int!
    var scores = [Score]()
    var settings: Settings?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scoreText.text = "Score: " + String(scoreIn)
        
        if let savedSettings = loadSettings() {
            settings = savedSettings
            os_log("Loading saved settings", log: OSLog.default, type: .debug)
        }  else {
            settings?.user = "default"
        }
        
        if let savedScores = loadScores() {
            scores += savedScores
        }
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller based on which button is pressed
        if let button = sender as? UIButton, button === nextButton {
            SFXController.sharedSFX.playStartSound()
            option = 0
        } else if let button = sender as? UIButton, button === exitButton {
            SFXController.sharedSFX.playQuitSound()
            scores.append(Score(user: (settings?.user)!, score: scoreIn)!)
            saveScores()
            option = 1
        } else {
            return
        }
    }
    
    private func saveScores() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(scores, toFile: Score.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Score successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save score...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadScores() -> [Score]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Score.ArchiveURL.path) as? [Score]
    }
    
    private func loadSettings() -> Settings? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Settings.ArchiveURL.path) as? Settings
    }
}
