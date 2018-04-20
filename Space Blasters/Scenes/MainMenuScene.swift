//
//  MainMenuScene.swift
//  Space Blasters
//
//  Created by Waisman Irving on 4/13/18.
//  Copyright © 2018 Irving Waisman. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    let playGameText = SKLabelNode (fontNamed: "Heavy Font")
    //let creditsText = SKLabelNode (fontNamed: "Heavy Font")
    
    override func didMove(to view: SKView) {
        
        // Background Settings
        let background = SKSpriteNode (imageNamed: "Background1")
        background.size = self.size // Set Size of Background as the same size of the scene
        background.position = CGPoint (x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0 // Put Background furthur back
        self.addChild(background) // Add Background to the scene
        
        // Title Text Line 1 Settings
        let titleTextLine1 = SKLabelNode(fontNamed: "Heavy Font")
        //titleText.numberOfLines = 2
        titleTextLine1.text = "Space"
        titleTextLine1.fontSize = 200
        titleTextLine1.fontColor = SKColor.white
        titleTextLine1.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.85)
        titleTextLine1.zPosition = 1
        self.addChild(titleTextLine1)
        
        // Title Text Line 2 Settings
        let titleTextLine2 = SKLabelNode(fontNamed: "Heavy Font")
        titleTextLine2.text = "Blasters 2D"
        titleTextLine2.fontSize = 200
        titleTextLine2.fontColor = SKColor.white
        titleTextLine2.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.75)
        titleTextLine2.zPosition = 1
        self.addChild(titleTextLine2)
        
        // Title Text Line 3 Settings
        let titleTextLine3 = SKLabelNode(fontNamed: "Heavy Font")
        titleTextLine3.text = "A Game by: Irving Waisman"
        titleTextLine3.fontSize = 50
        titleTextLine3.fontColor = SKColor.white
        titleTextLine3.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.7)
        titleTextLine3.zPosition = 1
        self.addChild(titleTextLine3)
        
        // Play Game Settings
        playGameText.text = "Play"
        playGameText.fontSize = 125
        playGameText.fontColor = SKColor.white
        playGameText.zPosition = 1
        playGameText.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.5)
        self.addChild(playGameText)
        
        // Top 3 Score Settings
        
        
        // Credits Settings
//        creditsText.text = "Credits"
//        creditsText.fontSize = 125
//        creditsText.fontColor = SKColor.white
//        creditsText.zPosition = 1
//        creditsText.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.1)
//        self.addChild(creditsText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
        
            let pointOfTouch = touch.location(in: self)
            
            if playGameText.contains(pointOfTouch) { // if player touches play game text load game scene
                
                // Green Text to Show the Player they Clicked the Text
                let changeTextColor = SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 0)
                playGameText.run(changeTextColor)
                
                let callScene = GameScene(size: self.size) // make sure game scene is the same size
                callScene.scaleMode = self.scaleMode // same goes for the scale
                let sceneTransition = SKTransition.fade(withDuration: 0.5) // transition to scene in set duration
                self.view!.presentScene(callScene, transition: sceneTransition) // call scene
            }
            
//            if creditsText.contains(pointOfTouch) { // if player touches credits text show credits
//
//                let callCreditsScene = CreditsScene(size: self.size) // make sure game scene is the same size
//                callCreditsScene.scaleMode = self.scaleMode // same goes for the scale
//                let sceneCreditsTransition = SKTransition.fade(withDuration: 0.5) // transition to scene in set duration
//                self.view!.presentScene(callCreditsScene, transition: sceneCreditsTransition) // call scene
//            }
        }
    }
}
