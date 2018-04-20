//
//  CreditScene.swift
//  Space Blasters
//
//  Created by Irving Waisman on 2018-04-14.
//  Copyright © 2018 Irving Waisman. All rights reserved.
//

import Foundation
import SpriteKit

class CreditScene: SKScene {
    
    //let backToMainText = SKLabelNode (fontNamed: "Heavy Font")
    
    override func didMove(to view: SKView) {
        
        // Background Settings
        let background = SKSpriteNode (imageNamed: "Background1")
        background.size = self.size // Set Size of Background as the same size of the scene
        background.position = CGPoint (x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0 // Put Background furthur back
        self.addChild(background) // Add Background to the scene
        
        // Credits Text 1 Settings
//        let creditsText = SKLabelNode(fontNamed: "Heavy Font")
//        creditsText.text = "Credits"
//        creditsText.fontSize = 200
//        creditsText.fontColor = SKColor.white
//        creditsText.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.75)
//        creditsText.zPosition = 1
//        self.addChild(creditsText)
//        
//        // Text Settings
//        let firstLineText = SKLabelNode(fontNamed: "Heavy Font")
//        firstLineText.text = "Everything Done"
//        firstLineText.fontSize = 200
//        firstLineText.fontColor = SKColor.white
//        firstLineText.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.5)
//        firstLineText.zPosition = 1
//        self.addChild(creditsText)
//        
//        let secondLineText = SKLabelNode(fontNamed: "Heavy Font")
//        secondLineText.text = "By"
//        secondLineText.fontSize = 200
//        secondLineText.fontColor = SKColor.white
//        secondLineText.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.4)
//        secondLineText.zPosition = 1
//        self.addChild(secondLineText)
//        
//        let thirdLineText = SKLabelNode(fontNamed: "Heavy Font")
//        thirdLineText.text = "Irving Waisman"
//        thirdLineText.fontSize = 200
//        thirdLineText.fontColor = SKColor.white
//        thirdLineText.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.3)
//        thirdLineText.zPosition = 1
//        self.addChild(thirdLineText)
        
        // Back to Main Menu Settings
//        backToMainText.text = "Back"
//        backToMainText.fontSize = 125
//        backToMainText.fontColor = SKColor.white
//        backToMainText.zPosition = 1
//        backToMainText.position = CGPoint (x: self.size.width / 0.25, y: self.size.height * 0.1)
//        self.addChild(backToMainText)
    }
}
