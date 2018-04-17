//
//  EnemyShip.swift
//  Space Blasters
//
//  Created by Waisman Irving on 4/17/18.
//  Copyright © 2018 Irving Waisman. All rights reserved.
//

import Foundation
import SpriteKit

var enemyShipsClassInstance = EnemyShips()

class EnemyShips: Player {
    
    //weak var gameScene: GameScene?
    //weak var collisionDetection: CollisionDetection?

    var enemyShipSpeed: Double = 1000 // speed for enemy kamikaze ships

    override func objectSetUp() {
        
//        let randomXStart = CGFloat.random(min: (gameSceneClass?.gameSpace.minX)!, max: (gameSceneClass?.gameSpace.maxX)!) // Random Enemy Start X-Axis position (Spawn Position)
//        let randomXEnd = CGFloat.random(min: gameSceneClass!.gameSpace.minX, max: gameSceneClass!.gameSpace.maxX) // Random Enemy End X-Axis position
        let randomXStart = CGFloat.random(min: 0.1, max: 0.9) // Random Enemy Start X-Axis position (Spawn Position)
        let randomXEnd = CGFloat.random(min: 0.1, max: 0.9) // Random Enemy End X-Axis position
        
        let startPoint = CGPoint(x: randomXStart, y: gameSceneClass!.size.height * 1.2) // Spawn position is Random X Start Postion and just above screen space
        let endPoint = CGPoint (x: randomXEnd, y: -gameSceneClass!.size.height * 0.2) // End Postion is Random X End Position and just below screen space
        
        // Enemy Ship Settings
        let enemyShipNode = SKSpriteNode(imageNamed: "EnemyShip")
        enemyShipNode.name = "EnemyShipRef" // Reference for Enemy Boss
        enemyShipNode.setScale(0.3) // Set Scale of Enemy Ship (1) being Normal
        enemyShipNode.position = startPoint // set postion of enemy ship
        enemyShipNode.zPosition = 2 // zPostion of enemy
        enemyShipNode.physicsBody = SKPhysicsBody(rectangleOf: enemyShipNode.size) // add physicsBody (Collision Detection Box) to the size of enemy ship
        enemyShipNode.physicsBody!.affectedByGravity = false // make sure the attached physicsBody does not use gravity to pull enemy down
        enemyShipNode.physicsBody!.categoryBitMask = CollisionDetection.PhysicsLayers.EnemyShipLayer // assigned enemy ship to phyiscs layer Enemy
        enemyShipNode.physicsBody!.collisionBitMask = CollisionDetection.PhysicsLayers.NoneLayer // Collision cannot occur with any layer
        enemyShipNode.physicsBody!.contactTestBitMask = CollisionDetection.PhysicsLayers.PlayerShipLayer | CollisionDetection.PhysicsLayers.PlayerLaserLayer // enemy ship phyiscs layer can make contact with phyiscs layers of player or laser
        gameSceneClass!.addChild(enemyShipNode) // Add enemy ship to the scene
        
        let moveEnemy = SKAction.move(to: endPoint, duration: enemyShipSpeed) // Move enemy ship to endPoint in set seconds
        let deleteEnemy = SKAction.removeFromParent() // delete enemy
        let enemyPassedPlayer = SKAction.run(gameSceneClass!.countForEnemiesPassed) // if enemy ship flies past the player run method count for enemies passed
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, enemyPassedPlayer]) // sequence of enemy ship
        
        if gameSceneClass!.currentGameState == GameScene.GameState.inGame { // only this sequence if game is actually running
            enemyShipNode.run(enemySequence)
        }
        
        // Rotation of Enemy Ship
        let deltaX = endPoint.x - startPoint.x
        let deltaY = endPoint.y - startPoint.y
        let amountToRotate = atan2(deltaY, deltaX)
        enemyShipNode.zRotation = amountToRotate
    }
}
