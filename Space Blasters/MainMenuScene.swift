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
    
    override func didMove(to view: SKView) {
        
        // Background Settings
        let background = SKSpriteNode (imageNamed: "Background1")
        background.size = self.size // Set Size of Background as the same size of the scene
        background.position = CGPoint (x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0 // Put Background furthur back
        self.addChild(background) // Add Background to the scene
        
        // Title Text Settings
        let titleText = SKLabelNode(fontNamed: "Heavy Font")
        //titleText.numberOfLines = 2
        titleText.text = "Space \nBlasters 2D" // TODO: fix text to display on two lines
        titleText.fontSize = 200
        titleText.fontColor = SKColor.white
        titleText.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.75)
        titleText.zPosition = 1
        self.addChild(titleText)
        
        // Play Game Settings
        playGameText.text = "Play"
        playGameText.fontSize = 125
        playGameText.fontColor = SKColor.white
        playGameText.zPosition = 1
        playGameText.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.5)
        self.addChild(playGameText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
        
            let pointOfTouch = touch.location(in: self)
            
            if playGameText.contains(pointOfTouch) {
                
                let callScene = GameScene(size: self.size) // make sure game scene is the same size
                callScene.scaleMode = self.scaleMode // same goes for the scale
                let sceneTransition = SKTransition.fade(withDuration: 0.5) // transition to scene in set duration
                self.view!.presentScene(callScene, transition: sceneTransition) // call scene
            }
        }
    }
}
