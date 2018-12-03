//
//  MusicController.swift
//  Ball Maze
//
//  Created by Keifer Francis on 2018-12-02.
//  Copyright © 2018 Braydon Hanson. All rights reserved.
//

import Foundation

import AVKit

class MusicController {
    static let sharedMusic = MusicController()
    var music: AVAudioPlayer?
    
    var enabled = true
    
    func play() {
        let path = Bundle.main.path(forResource: "Music/music.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            music = try AVAudioPlayer(contentsOf: url)
            music?.numberOfLoops = -1
            music?.play()
            print("Playing music")
        } catch {
            print("Couldn't load music file")
        }
    }
    
    func stop() {
        music?.stop()
    }
    
    func isPlaying() -> Bool? {
        return music?.isPlaying
    }
    
    
    func isEnabled() -> Bool? {
        return enabled
    }
    
    func disable() {
        enabled = false
        stop()
    }
    
    func enable() {
        enabled = true
        play()
    }
}





