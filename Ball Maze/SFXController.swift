//
//  MusicController.swift
//  Ball Maze
//
//  Created by Keifer Francis on 2018-12-02.
//  Copyright © 2018 Braydon Hanson. All rights reserved.
//

import Foundation

import AVKit

class SFXController {
    static let sharedSFX = SFXController()
    var sfx: AVAudioPlayer?
    var enabled = true
    
    func playButtonSound() {
        if(enabled) {
            let path = Bundle.main.path(forResource: "SFX/Select.wav", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            
            do {
                sfx = try AVAudioPlayer(contentsOf: url)
                sfx?.numberOfLoops = 0
                sfx?.play()
            } catch {
                print("Couldn't load sfx file")
            }
        }
    }
    
    func playBackSound() {
        if(enabled) {
            let path = Bundle.main.path(forResource: "SFX/Back.wav", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            
            do {
                sfx = try AVAudioPlayer(contentsOf: url)
                sfx?.numberOfLoops = 0
                sfx?.play()
            } catch {
                print("Couldn't load sfx file")
            }
        }
    }
    
    func playStartSound() {
        if(enabled) {
            let path = Bundle.main.path(forResource: "SFX/StartLevel.wav", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            
            do {
                sfx = try AVAudioPlayer(contentsOf: url)
                sfx?.numberOfLoops = 0
                sfx?.play()
            } catch {
                print("Couldn't load sfx file")
            }
        }
    }
    
    func playClickSound() {
        if(enabled) {
            let path = Bundle.main.path(forResource: "SFX/Click.wav", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            
            do {
                sfx = try AVAudioPlayer(contentsOf: url)
                sfx?.numberOfLoops = 0
                sfx?.play()
            } catch {
                print("Couldn't load sfx file")
            }
        }
    }
    
    func playQuitSound() {
        if(enabled) {
            let path = Bundle.main.path(forResource: "SFX/QuitLevel.wav", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            
            do {
                sfx = try AVAudioPlayer(contentsOf: url)
                sfx?.numberOfLoops = 0
                sfx?.play()
            } catch {
                print("Couldn't load sfx file")
            }
        }
    }
    
    func playUnpauseSound() {
        if(enabled) {
            let path = Bundle.main.path(forResource: "SFX/Unpause.wav", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            
            do {
                sfx = try AVAudioPlayer(contentsOf: url)
                sfx?.numberOfLoops = 0
                sfx?.play()
            } catch {
                print("Couldn't load sfx file")
            }
        }
    }
    
    func isEnabled() -> Bool? {
        return enabled
    }

    func disable() {
        enabled = false
    }
    
    func enable() {
        enabled = true
    }
}





