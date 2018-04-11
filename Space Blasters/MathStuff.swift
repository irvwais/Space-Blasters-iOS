//
//  MathStuff.swift
//  Space Blasters
//
//  Created by Waisman Irving on 4/9/18.
//  Copyright © 2018 Irving Waisman. All rights reserved.
//

import Foundation
import SpriteKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
        
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
        
    }
    
}
