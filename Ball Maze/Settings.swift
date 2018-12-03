//
//  Settings.swift
//  Ball Maze
//
//  Created by Keifer Francis on 2018-12-03.
//  Copyright © 2018 Braydon Hanson. All rights reserved.
//

import Foundation
import os.log

class Settings: NSObject, NSCoding {
    
    // MARK: Properties
    
    var user: String
    var sfxOn: Bool
    var musicOn: Bool
    
    // MARK Initialization
    
    init?(user: String, sfxOn: Bool, musicOn: Bool) {
        
        // Initialize stored properties.
        // If no user, user = default
        if user.isEmpty {
            self.user = "Default"
        } else {
            self.user = user
        }
        
        self.sfxOn = sfxOn
        self.musicOn = musicOn
    }
    
    // MARK: Types
    
    struct PropertyKey {
        static let user = "user"
        static let sfxOn = "sfxOn"
        static let musicOn = "musicOn"
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(user, forKey: PropertyKey.user)
        aCoder.encode(sfxOn, forKey: PropertyKey.sfxOn)
        aCoder.encode(musicOn, forKey: PropertyKey.musicOn)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The user is required. If we cannot decode a user string, the initializer should fail.
        guard let user = aDecoder.decodeObject(forKey: PropertyKey.user) as? String else {
            os_log("Unable to decode the user for a Settings object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let sfxOn = aDecoder.decodeBool(forKey: PropertyKey.sfxOn)  as? Bool else {
            os_log("Unable to decode the sfxOn for a Settings object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let musicOn = aDecoder.decodeBool(forKey: PropertyKey.musicOn)  as? Bool else {
            os_log("Unable to decode the musicOn for a Settings object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        
        // Must call designated initializer.
        self.init(user: user, sfxOn: sfxOn, musicOn: musicOn)
    }
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("settings")
}
