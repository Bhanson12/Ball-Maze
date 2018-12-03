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
    var score: Score?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            score = Score(user:"test", score: scoreIn)
            saveScore()
            option = 1
        } else {
            return
        }
    }
    
    private func saveScore() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(score, toFile: Score.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Score successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save score...", log: OSLog.default, type: .error)
        }
    }
}
