//
//  GameEndViewController.swift
//  Ball Maze
//
//  Created by Braydon Hanson on 2018-12-03.
//  Copyright © 2018 Braydon Hanson. All rights reserved.
//

import UIKit
import os.log

class GameEndViewController: UIViewController {
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var scoreText: UILabel!
    
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
        if let button = sender as? UIButton, button === restartButton {
            SFXController.sharedSFX.playStartSound()
            scores.append(Score(user: (settings?.user)!, score: scoreIn)!)
            saveScores()
            option = 1
        } else if let button = sender as? UIButton, button === exitButton {
            SFXController.sharedSFX.playQuitSound()
            scores.append(Score(user: (settings?.user)!, score: scoreIn)!)
            saveScores()
            option = 2
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
