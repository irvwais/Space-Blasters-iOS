//
//  IntRandom.swift
//  Space Blasters
//
//  Created by Irving Waisman on 2018-04-17.
//  Copyright © 2018 Irving Waisman. All rights reserved.
//

import Foundation
import SpriteKit

extension Int {
    static func random() -> Int {
        return Int(Int(arc4random()) / Int(UInt32.max))
        
    }
    
    static func random(min: Int, max: Int) -> Int {
        assert(min < max)
        return Int.random() * (max - min) + min
        
    }
    
}
