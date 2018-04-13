//
//  GameOverScene.swift
//  Space Blasters
//
//  Created by Waisman Irving on 4/13/18.
//  Copyright © 2018 Irving Waisman. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    let playAgainText = SKLabelNode (fontNamed: "Heavy Font")
    
    override func didMove(to view: SKView) {
        
        // Background Settings
        let background = SKSpriteNode (imageNamed: "Background1")
        background.size = self.size // Set Size of Background as the same size of the scene
        background.position = CGPoint (x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0 // Put Background furthur back
        self.addChild(background) // Add Background to the scene
        
        // Game Over Text Settings
        let gameOverText = SKLabelNode(fontNamed: "Heavy Font")
        gameOverText.text = "Game Over"
        gameOverText.fontSize = 200
        gameOverText.fontColor = SKColor.white
        gameOverText.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.75)
        gameOverText.zPosition = 1
        self.addChild(gameOverText)
        
        // Score Text Settings
        let scoreText = SKLabelNode(fontNamed: "Heavy Font")
        scoreText.text = "Score: \(gameScore)"
        scoreText.fontSize = 125
        scoreText.fontColor = SKColor.white
        scoreText.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.5)
        scoreText.zPosition = 1
        self.addChild(scoreText)
        
        // High Score Settings
        let defaults = UserDefaults ()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber { // if current score is greater than the high score
            highScoreNumber = gameScore // set new high score
            defaults.set(highScoreNumber, forKey: "highScoreSaved") // save as new high score
        }
        
        let highScoreText = SKLabelNode(fontNamed: "Heavy Font")
        highScoreText.text = "High Score: \(highScoreNumber)" // update high score text with high score number
        highScoreText.fontSize = 125
        highScoreText.fontColor = SKColor.white
        highScoreText.zPosition = 1
        highScoreText.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.4)
        self.addChild(highScoreText)
        
        // Play Again Settings
        playAgainText.text = "Play Again"
        playAgainText.fontSize = 90
        playAgainText.fontColor = SKColor.white
        playAgainText.zPosition = 1
        playAgainText.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.25)
        self.addChild(playAgainText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches { // check all touches that were made
            
            let pointOfTouch = touch.location(in: self) // check where the touch was made
            
            if playAgainText.contains(pointOfTouch) { // see if the touch was the test play again
                
                let callScene = GameScene(size: self.size) // make sure game scene is the same size as game scene
                callScene.scaleMode = self.scaleMode // same goes for the scale
                let sceneTransition = SKTransition.fade(withDuration: 0.5) // transition to scene in set duration
                self.view!.presentScene(callScene, transition: sceneTransition) // call scene
                
            }
        }
    }
}
