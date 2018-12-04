//
//  level.swift
//  Ball Maze
//
//  Created by Braydon Hanson on 2018-12-03.
//  Copyright © 2018 Braydon Hanson. All rights reserved.
//

import Foundation

class level {
    
    let NUMOFLEVELS = 3
    
    var num: Int
    
    init() {
        self.num = 1
    }
    
    init?(num: Int) {
        self.num = num
    }
    
    func incrementLevel() {
        self.num = self.num + 1
    }
    
    func restartGame() {
        self.num = 1
    }
    
    func checkGameCompletion() -> Bool {
        if (NUMOFLEVELS <= self.num) {
            return true
        } else {
            return false
        }
    }
    
}
