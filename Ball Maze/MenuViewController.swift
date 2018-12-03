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

var music:AVAudioPlayer?

class MenuViewController: UIViewController {

    @IBOutlet weak var StartBut: UIButton!
    @IBOutlet weak var LBBut: UIButton!
    
    var GameView: GameViewController!
    var PauseMenu: PauseViewController!
    var MainMenu: MenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MusicController.sharedMusic.play()
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
        /*
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller
        if let button = sender as? UIBarButtonItem, button === StartBut {
            
        } else {
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)*/
    }
}

