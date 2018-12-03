//
//  Score.swift
//  Ball Maze
//
//  Created by Keifer Francis on 2018-12-02.
//  Copyright © 2018 Braydon Hanson. All rights reserved.
//

import Foundation
import os.log

class Score: NSObject, NSCoding {
    
    // MARK: Properties
    
    var user: String
    var score: Int
    
    // MARK Initialization
    
    init?(user: String, score: Int) {
        
        // Initialization should fail if there is no user or if the score is negative.
        if user.isEmpty || score < 0  {
            return nil
        }
        
        // Initialize stored properties.
        self.user = user
        self.score = score
    }
    
    // MARK: Types
    
    struct PropertyKey {
        static let user = "user"
        static let score = "score"
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(user, forKey: PropertyKey.user)
        aCoder.encode(score, forKey: PropertyKey.score)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The user is required. If we cannot decode a user string, the initializer should fail.
        guard let user = aDecoder.decodeObject(forKey: PropertyKey.user) as? String else {
            os_log("Unable to decode the user for a Score object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let score = aDecoder.decodeObject(forKey: PropertyKey.score)
        
        
        // Must call designated initializer.
        self.init(user: user, score: score as! Int)
    }
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("scores")
}
