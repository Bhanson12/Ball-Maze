//
//  GameEndViewController.swift
//  Ball Maze
//
//  Created by Braydon Hanson on 2018-12-03.
//  Copyright © 2018 Braydon Hanson. All rights reserved.
//

import UIKit

class GameEndViewController: UIViewController {
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    var option = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller based on which button is pressed
        if let button = sender as? UIButton, button === restartButton {
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
