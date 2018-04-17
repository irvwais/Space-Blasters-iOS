//
//  CollisionDetection.swift
//  Space Blasters
//
//  Created by Waisman Irving on 4/10/18.
//  Copyright © 2018 Irving Waisman. All rights reserved.
//

import Foundation
import SpriteKit

class CollisionDetection: SKScene, SKPhysicsContactDelegate {
    
    weak var gameSceneClass: GameScene?
    //weak var enemyBossClass: EnemyBoss?
    
    struct PhysicsLayers {
        
        static let NoneLayer : UInt32 = 0
        static let PlayerShipLayer : UInt32 = 0b1 // 1 in binary
        static let PlayerLaserLayer : UInt32 = 0b10 // 2 in binary
        static let EnemyShipLayer : UInt32 = 0b100 // 4 in binary
        static let EnemyLaserLayer : UInt32 = 0b1000 // 8 in binary
        static let EnemyBossLayer : UInt32 = 0b10000 // 16 in binary
    }
    
    func didBegin(_ contact: SKPhysicsContact) { // did we contact between two phyiscs bodies (physic layers)
        
        var body1 = SKPhysicsBody ()
        var body2 = SKPhysicsBody ()
        
        // check and assign lowest physics layer (category number) to body1 and higher physics layer (category number) to body2
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask { // check if bodyA physics layer (category number) is less than bodyB
            body1 = contact.bodyA // then body1 and body2 is in numerical order
            body2 = contact.bodyB
        } else { // else make them into numerical order
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        // if player and enemy have made contact
        if body1.categoryBitMask == PhysicsLayers.PlayerShipLayer && body2.categoryBitMask == PhysicsLayers.EnemyShipLayer {
            
            if body1.node != nil {
                gameSceneClass!.spawnExplosion(spawnPosition: body1.node!.position) // spawn explosion at the position of body1 (playerShip)
            }
            
            if body2.node != nil {
                gameSceneClass!.spawnExplosion(spawnPosition: body2.node!.position) // spawn explosion at the position of body2 (enemy ship)
            }
            
            // ? (optional) because two bodies of the same layer might make contact at the same time which could crash the game
            body1.node?.removeFromParent() // find the node accosiated with the body1 and delete it
            body2.node?.removeFromParent() // find the node accosiated with the body2 and delete it
            
            gameSceneClass!.runGameOver()
        }
        
        // if player and enemy boss have made contact
        if body1.categoryBitMask == PhysicsLayers.PlayerShipLayer && body2.categoryBitMask == PhysicsLayers.EnemyBossLayer {
            
            if body1.node != nil {
                gameSceneClass!.spawnExplosion(spawnPosition: body1.node!.position) // spawn explosion at the position of body1 (playerShip)
            }
            
            if body2.node != nil {
                gameSceneClass!.spawnExplosion(spawnPosition: body2.node!.position) // spawn explosion at the position of body2 (enemy ship)
            }
            
            // ? (optional) because two bodies of the same layer might make contact at the same time which could crash the game
            body1.node?.removeFromParent() // find the node accosiated with the body1 and delete it
            body2.node?.removeFromParent() // find the node accosiated with the body2 and delete it
            
            gameSceneClass!.runGameOver()
        }
        
        // if playerLaser and enemy have made contact and enemy is on the screen
        if body1.categoryBitMask == PhysicsLayers.PlayerLaserLayer && body2.categoryBitMask == PhysicsLayers.EnemyShipLayer && (body2.node?.position.y)! < gameSceneClass!.self.size.height {
            
            gameSceneClass!.addScore() // call add score method when player shoots enemy ship
            
            if body2.node != nil {
                gameSceneClass!.spawnExplosion(spawnPosition: body2.node!.position) // spawn explosion at the position of body2 (enemy ship)
            }
            
            // ? (optional) because two bodies of the same layer might make contact at the same time which could crash the game
            body1.node?.removeFromParent() // find the node accosiated with the body1 and delete it
            body2.node?.removeFromParent() // find the node accosiated with the body2 and delete it
        }
        
        // if playerLaser and enemy boss have made contact and enemy is on the screen
        if body1.categoryBitMask == PhysicsLayers.PlayerLaserLayer && body2.categoryBitMask == PhysicsLayers.EnemyBossLayer && (body2.node?.position.y)! < gameSceneClass!.self.size.height {
            
            enemyBossClassInstance.enemBossLives -= 1 // decrease enemy boss life
            
            if body2.node != nil && enemyBossClassInstance.enemBossLives == 0 {
                gameSceneClass!.addScore() // call add score method when player shoots enemy boss
                body2.node?.removeFromParent() // find the node accosiated with the body2 and delete it
                enemyBossesKilled += 1 // increase count for enemy bosses killed
                enemyBossClassInstance.yesSpawnEnemyBoss = false
                gameSceneClass!.spawnExplosion(spawnPosition: body2.node!.position) // spawn explosion at the position of body2 (enemy boss)
            }
            
            // ? (optional) because two bodies of the same layer might make contact at the same time which could crash the game
            body1.node?.removeFromParent() // find the node accosiated with the body1 and delete it
            
        }
        
        // if player and enemyLaser have made contact
        if body1.categoryBitMask == PhysicsLayers.PlayerShipLayer && body2.categoryBitMask == PhysicsLayers.EnemyLaserLayer {
            
            if body1.node != nil {
                gameSceneClass!.loseLives() // lose player lives with each hit from enemy laser
                if gameSceneClass!.livesCount == 0 { // if player loses all lives from being shot spawn explosion
                    gameSceneClass!.spawnExplosion(spawnPosition: body1.node!.position) // spawn explosion at the position of body1 (player ship)
                    body1.node?.removeFromParent() // find the node accosiated with the body1 and delete ii
                }
            }
            
            // ? (optional) because two bodies of the same layer might make contact at the same time which could crash the game
            body2.node?.removeFromParent() // find the node accosiated with the body2 and delete it
        }
    }
}

