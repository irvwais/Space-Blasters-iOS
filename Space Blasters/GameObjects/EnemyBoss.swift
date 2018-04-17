//
//  EnemyBoss.swift
//  Space Blasters
//
//  Created by Waisman Irving on 4/17/18.
//  Copyright © 2018 Irving Waisman. All rights reserved.
//

import Foundation
import SpriteKit

class EnemyBoss: Player {
    
    // Enemy Boss Stats
    var enemyBossXSpeed: Double = 5 // speed for enemy boss along X-Axis
    //var enemyBossYSpeed: Double = 30 // speed for enemy boss along Y-Axis
    var yesSpawnEnemyBoss : Bool = false // flag for spawning enemyBoss
    var enemBossLives = 3 // amount lives for the enemy boss
    
    // Images
    var enemyLaserImageAtlas = SKTextureAtlas()
    var enemyLaserImageArray = [SKTexture]()
    
    override func objectSetUp() {
        
        let randomXPos = CGFloat.random(min: 0.4, max: 0.8)
        
        let leftEndPoint = CGPoint (x: gameSceneClass!.self.size.width * 0.23, y: gameSceneClass!.self.size.height * randomXPos) // leftPoint of travel for enemyBoss
        let rightEndPoint = CGPoint (x: gameSceneClass!.self.size.width * 0.77, y: gameSceneClass!.self.size.height * randomXPos) // rightPoint of travel for enemyBoss
        
        //let randomFireLaser = CGFloat.random(min: 1, max:3) // random time for firing lasers
        
        // Enemy Boss Settings
        let enemyBossNode = SKSpriteNode(imageNamed: "BossShip")
        enemyBossNode.name = "EnemyBossRef" // Reference for Enemy Boss
        enemyBossNode.setScale(1.5) // Set scale of enemy Boss (1) being normal
        enemyBossNode.position = CGPoint (x: gameSceneClass!.self.size.width / 2, y: gameSceneClass!.self.size.height * 1.2) // spawn enemy boss just above top of screen
        enemyBossNode.zPosition = 2 // zPosition of enemy boss
        enemyBossNode.physicsBody = SKPhysicsBody(rectangleOf: enemyBossNode.size) // add physicsBody (Collision Detection Box) to the size of enemy boss
        enemyBossNode.physicsBody!.affectedByGravity = false // make sure the attached physicsBody does not use gravity to pull enemyBoss down
        enemyBossNode.physicsBody!.categoryBitMask = CollisionDetection.PhysicsLayers.EnemyBoss // assigned enemyBoss to phyiscs layer Enemy
        enemyBossNode.physicsBody!.collisionBitMask = CollisionDetection.PhysicsLayers.None // Collision cannot occur with any layer
        enemyBossNode.physicsBody!.contactTestBitMask = CollisionDetection.PhysicsLayers.PlayerLaser // enemy ship phyiscs layer can make contact with phyiscs layers of laser
        gameSceneClass!.self.addChild(enemyBossNode) // Add enemyBoss to the scene
        
        let moveEnemyBossOntoScreen = SKAction.moveTo(y: gameSceneClass!.self.size.height * 0.8 , duration: 0.5)
        let moveEnemyBossLeft = SKAction.move(to: leftEndPoint, duration: enemyBossXSpeed) // move enemyBoss to left end point
        let moveEnemyBossRight = SKAction.move(to: rightEndPoint, duration: enemyBossXSpeed) // move enemyBoss to right end point
        //let moveEnemyBossTowardsButtom = SKAction.move(to: player.position, duration: enemyBossYSpeed) // move towards the player
        let fireEnemyLaser = SKAction.run(fireLaser) // variable for running method firEnemyLaser
        let deleteEnemyBoss = SKAction.removeFromParent() // delete enemyBoss
        
        if !yesSpawnEnemyBoss {
            enemyBossNode.run(deleteEnemyBoss)
        } else {
            let enemyBossSequence = SKAction.sequence([moveEnemyBossOntoScreen, moveEnemyBossLeft, moveEnemyBossRight]) // sequence of enemy boss movment
            let moveEnemyBossWhileAlive = SKAction.repeatForever(enemyBossSequence) // move enemy boss while it has lives
            
            // Fire Enemy Laser at Random Time Intervals
            let waitToShootEnemyLaser = SKAction.wait(forDuration: 3, withRange: 1) //wait(forDuration: randomFireLaser)
            let spawnSequenceEnemyLaser = SKAction.sequence([fireEnemyLaser, waitToShootEnemyLaser])
            let spawnForeverEnemyLaser = SKAction.repeatForever(spawnSequenceEnemyLaser)
            
            if gameSceneClass!.currentGameState == GameScene.GameState.inGame { // only this sequence if game is actually running
                enemyBossNode.run(moveEnemyBossWhileAlive)
                if enemyBossNode.position.y > gameSceneClass!.self.size.height * 0.8 { // only when in correct position start firing enemy laser
                    enemyBossNode.run(spawnForeverEnemyLaser)
                }
            }
        }
    }
    
    override func laserAnimate() {
        
        enemyLaserImageAtlas = SKTextureAtlas(named: "EnemyLasersImages")
        
        for i in 1...enemyLaserImageAtlas.textureNames.count {
            let imageEnemyLaserName = "EnemyLasers_\(i).png"
            enemyLaserImageArray.append(SKTexture(imageNamed: imageEnemyLaserName))
        }
    }
    
    override func fireLaser() {
        
        // Enemy Laser Settings
        let enemyLaserNode = SKSpriteNode (imageNamed: enemyLaserImageAtlas.textureNames[0])
        enemyLaserNode.name = "EnemyLaserRef" // Reference name for Enemy Laser
        enemyLaserNode.setScale(1)
        enemyLaserNode.position = (gameSceneClass!.childNode(withName: "EnemyBossRef")?.position)! // Spawn enemy laser at postion of the enemy
        enemyLaserNode.zPosition = 1 // Spawn under player ship
        enemyLaserNode.physicsBody = SKPhysicsBody(rectangleOf: enemyLaserNode.size) // add physicsBody (Collision Detection Box) to the size of enemyLaser
        enemyLaserNode.physicsBody!.affectedByGravity = false // make sure the attached physicsBody does not use gravity to pull enemyLaser down
        enemyLaserNode.physicsBody!.categoryBitMask = CollisionDetection.PhysicsLayers.EnemyLaser // assigned enemyLaser to phyiscs layer Laser
        enemyLaserNode.physicsBody!.collisionBitMask = CollisionDetection.PhysicsLayers.None // Collision cannot occur with any layer
        enemyLaserNode.physicsBody!.contactTestBitMask = CollisionDetection.PhysicsLayers.Player // enemyLaser phyiscs layer can make contact with phyiscs layers of enemy
        gameSceneClass!.self.addChild(enemyLaserNode) // add enemyLaser to scene
        
        let moveEnemyLaser = SKAction.moveTo(y: -gameSceneClass!.self.size.height + enemyLaserNode.size.height, duration: 1.5) // move Laser down along Y axis for set duration
        let deleteEnemyLaser = SKAction.removeFromParent() // delete after 1 sec
        
        let laserSequence = SKAction.sequence([gameSceneClass!.laserSound, moveEnemyLaser, deleteEnemyLaser]) // sequence of events for shooting player lasers
        enemyLaserNode.run(laserSequence)
        
        enemyLaserNode.run(SKAction.repeatForever(SKAction.animate(with: enemyLaserImageArray, timePerFrame: 0.1))) // Animate Laser
    }
}
