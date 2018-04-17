//
//  Player.swift
//  Space Blasters
//
//  Created by Waisman Irving on 4/17/18.
//  Copyright © 2018 Irving Waisman. All rights reserved.
//

import Foundation
import SpriteKit

//var playerClassInstance = Player()

class Player: SKSpriteNode {
    
    weak var gameSceneClass: GameScene?
    //weak var collisionDetection: CollisionDetection?

    let playerNode = SKSpriteNode (imageNamed: "PlayerShip1")
    
    // Images
    var playerLaserImageAtlas = SKTextureAtlas()
    var playerLaserImageArray = [SKTexture]()
    
    func objectSetUp () {
        
        // Player Settings
        playerNode.setScale(0.2) // Size of Player Ship Image (1) being normal size
        playerNode.position = CGPoint (x: gameSceneClass!.size.width / 2, y: 0 - playerNode.size.height) // Start player just off the bottom of screen
        playerNode.zPosition = 2
        playerNode.physicsBody = SKPhysicsBody(rectangleOf: playerNode.size) // add physicsBody (Collision Detection Box) to the size of player ship
        playerNode.physicsBody!.affectedByGravity = false // make sure the attached physicsBody does not use gravity to pull player down
        playerNode.physicsBody!.categoryBitMask = CollisionDetection.PhysicsLayers.PlayerShipLayer // assigned player ship to phyiscs layer Player
        playerNode.physicsBody!.collisionBitMask = CollisionDetection.PhysicsLayers.NoneLayer // Collision cannot occur with any layer
        playerNode.physicsBody!.contactTestBitMask = CollisionDetection.PhysicsLayers.EnemyShipLayer //| PhysicsLayers.EnemyLaser // player phyiscs layer can make contact with phyiscs layers of enemy and enemyLaser
        gameSceneClass!.addChild(playerNode) // Add player to the scene
        
        // Jet Particle Effect Settings
        let jetPath = Bundle.main.path(forResource: "JetEmitter", ofType: "sks")!
        let jet = NSKeyedUnarchiver.unarchiveObject(withFile: jetPath) as! SKEmitterNode
        jet.xScale = 5
        jet.yScale = 5
        jet.position.y = playerNode.position.y - 30
        jet.zPosition = 0
        playerNode.addChild(jet)
    }
    
    func laserAnimate () {
        playerLaserImageAtlas = SKTextureAtlas(named: "PlayerLasersImages")
        
        for i in 1...playerLaserImageAtlas.textureNames.count {
            let imagePlayerLaserName = "PlayerLasers_\(i).png"
            playerLaserImageArray.append(SKTexture(imageNamed: imagePlayerLaserName))
        }
    }
    
    func fireLaser () {
        
        // Player Laser Settings
        let playerLaserNode = SKSpriteNode (imageNamed: playerLaserImageAtlas.textureNames[0])
        playerLaserNode.name = "PlayerLaserRef" // Reference name for Player Laser
        playerLaserNode.setScale(1)
        playerLaserNode.position = playerNode.position // Spawn player laser at postion of the player
        playerLaserNode.zPosition = 1 // Spawn under player ship
        playerLaserNode.physicsBody = SKPhysicsBody(rectangleOf: playerLaserNode.size) // add physicsBody (Collision Detection Box) to the size of playerLaser
        playerLaserNode.physicsBody!.affectedByGravity = false // make sure the attached physicsBody does not use gravity to pull playerLaser down
        playerLaserNode.physicsBody!.categoryBitMask = CollisionDetection.PhysicsLayers.PlayerLaserLayer // assigned playerLaser to phyiscs layer Laser
        playerLaserNode.physicsBody!.collisionBitMask = CollisionDetection.PhysicsLayers.NoneLayer // Collision cannot occur with any layer
        playerLaserNode.physicsBody!.contactTestBitMask = CollisionDetection.PhysicsLayers.EnemyShipLayer // playerLaser phyiscs layer can make contact with phyiscs layers of enemy
        gameSceneClass!.addChild(playerLaserNode) // add playerLaser to scene
        
        let movePlayerLaser = SKAction.moveTo(y: gameSceneClass!.size.height + playerLaserNode.size.height, duration: 1) // move Laser up along Y axis for 1 sec
        let deletePlayerLaser = SKAction.removeFromParent() // delete after 1 sec
        //let animateLaser = (SKAction.repeatForever(SKAction.animate(with: playerLaserImageArray, timePerFrame: 0.1))) // Animate Laser
        let laserSequence = SKAction.sequence([gameSceneClass!.laserSound, movePlayerLaser, deletePlayerLaser]) // sequence of events for shooting player lasers
        playerLaserNode.run(laserSequence)
        
        playerLaserNode.run(SKAction.repeatForever(SKAction.animate(with: playerLaserImageArray, timePerFrame: 0.1))) // Animate Laser
    }
}
