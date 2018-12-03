//
//  SettingsViewController.swift
//  Ball Maze
//
//  Created by Keifer Francis on 2018-12-01.
//  Copyright © 2018 Braydon Hanson. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Main Menu", style: .plain, target: self, action: #selector(backButtonPressed))
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
    
    @objc func backButtonPressed() {
        SFXController.sharedSFX.playBackSound()
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
