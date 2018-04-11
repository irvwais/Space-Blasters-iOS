//
//  GameScene.swift
//  Space Blasters
//
//  Created by Waisman Irving on 4/9/18.
//  Copyright © 2018 Irving Waisman. All rights reserved.
//

// Test Branch

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Declare Objects globally to be accessed by any func in class
    let player = SKSpriteNode (imageNamed: "PlayerShip")
    //let enemy = SKSpriteNode(imageNamed: "EnemyShip")
    let laserSound = SKAction.playSoundFileNamed("laserSound.wav", waitForCompletion: false)
    let boomSound = SKAction.playSoundFileNamed("boomSound.wav", waitForCompletion: false)
    
    struct PhysicsLayers {
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 // 1 in binary
        static let PlayerLaser : UInt32 = 0b10 // 2 in binary
        static let Enemy : UInt32 = 0b100 // 4 in binary
        //static let EnemyLaser : UInt32 = 0b111+0b1 // 8 in binary
    }
    
    let gameSpace : CGRect
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0 / 9.0 // How wide the game are should be
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameSpace = CGRect (x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove (to view: SKView) {
        
        self.physicsWorld.contactDelegate = self // Set Up Physics to be delegated to this class
        
        // Background Settings
        let background = SKSpriteNode (imageNamed: "Background1")
        background.size = self.size // Set Size of Background as the same size of the scene
        background.position = CGPoint (x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0 // Put Background furthur back
        self.addChild(background) // Add Background to the scene
        
        // Player Settings
        player.setScale(0.2) // Size of Player Ship Image (1) being normal size
        player.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.2) // Start player at 20% from the bottom of screen
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size) // add physicsBody (Collision Detection Box) to the size of player ship
        player.physicsBody!.affectedByGravity = false // make sure the attached physicsBody does not use gravity to pull player down
        player.physicsBody!.categoryBitMask = PhysicsLayers.Player // assigned player ship to phyiscs layer Player
        player.physicsBody!.collisionBitMask = PhysicsLayers.None // Collision cannot occur with any layer
        player.physicsBody!.contactTestBitMask = PhysicsLayers.Enemy //| PhysicsLayers.EnemyLaser // player phyiscs layer can make contact with phyiscs layers of enemy and enemyLaser
        self.addChild(player) // Add player to the scene
        
        startLevel()
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
        if body1.categoryBitMask == PhysicsLayers.Player && body2.categoryBitMask == PhysicsLayers.Enemy {
            
            if body1.node != nil {
                spawnExplosion(spawnPosition: body1.node!.position) // spawn explosion at the position of body1 (playerShip)
            }
            
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position) // spawn explosion at the position of body2 (enemy ship)
            }
            
            // ? (optional) because two bodies of the same layer might make contact at the same time which could crash the game
            body1.node?.removeFromParent() // find the node accosiated with the body1 and delete it
            body2.node?.removeFromParent() // find the node accosiated with the body2 and delete it
        }
        
        // if playerLaser and enemy have made contact and enemy is on the screen
        if body1.categoryBitMask == PhysicsLayers.PlayerLaser && body2.categoryBitMask == PhysicsLayers.Enemy && (body2.node?.position.y)! < self.size.height {
            
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position) // spawn explosion at the position of body2 (enemy ship)
            }

            // ? (optional) because two bodies of the same layer might make contact at the same time which could crash the game
            body1.node?.removeFromParent() // find the node accosiated with the body1 and delete it
            body2.node?.removeFromParent() // find the node accosiated with the body2 and delete it
        }
        
//        // if player and enemyLaser have made contact
//        if body1.categoryBitMask == PhysicsLayers.Player && body2.categoryBitMask == PhysicsLayers.EnemyLaser {
//
//            if body1.node != nil {
//                spawnExplosion(spawnPosition: body1.node!.position) // spawn explosion at the position of body1 (player ship)
//            }
//
//            // ? (optional) because two bodies of the same layer might make contact at the same time which could crash the game
//            body1.node?.removeFromParent() // find the node accosiated with the body1 and delete it
//            body2.node?.removeFromParent() // find the node accosiated with the body2 and delete it
//        }
    }
    
    func spawnExplosion (spawnPosition: CGPoint) {
        
        // Explosion Settings
        let explosion = SKSpriteNode (imageNamed: "Explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3 // spawn image of explosion on top of ship
        explosion.setScale(0) // set scale of explosion to not visable
        self.addChild(explosion) // add explosion to scene
        
        // Make explosion look like it goes from small to big and play explosion sound
        let scaleUp = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([boomSound, scaleUp, fadeOut, delete])
        explosion.run(explosionSequence)
    }
    
    func startLevel () {
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: 3)
        let spawnSequence = SKAction.sequence([spawn, waitToSpawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever)
    }
    
    func firePlayerLaser () {
        
        // Player Laser Settings
        let playerLaser = SKSpriteNode (imageNamed: "PlayerLaser")
        playerLaser.setScale(1)
        playerLaser.position = player.position // Spawn player laser at postion of the player
        playerLaser.zPosition = 1 // Spawn under player ship
        playerLaser.physicsBody = SKPhysicsBody(rectangleOf: playerLaser.size) // add physicsBody (Collision Detection Box) to the size of playerLaser
        playerLaser.physicsBody!.affectedByGravity = false // make sure the attached physicsBody does not use gravity to pull playerLaser down
        playerLaser.physicsBody!.categoryBitMask = PhysicsLayers.PlayerLaser // assigned playerLaser to phyiscs layer Laser
        playerLaser.physicsBody!.collisionBitMask = PhysicsLayers.None // Collision cannot occur with any layer
        playerLaser.physicsBody!.contactTestBitMask = PhysicsLayers.Enemy // playerLaser phyiscs layer can make contact with phyiscs layers of enemy
        self.addChild(playerLaser) // add playerLaser to scene
        
        let movePlayerLaser = SKAction.moveTo(y: self.size.height + playerLaser.size.height, duration: 1) // move Laser up along Y axis for 1 sec
        let deletePlayerLaser = SKAction.removeFromParent() // delete after 1 sec
        
        let laserSequence = SKAction.sequence([laserSound, movePlayerLaser, deletePlayerLaser]) // sequence of events for shooting player lasers
        playerLaser.run(laserSequence)
    }
    
//    func fireEnemyLaser () {
//
//        // Enemy Laser Settings
//        let enemyLaser = SKSpriteNode (imageNamed: "EnemyLaser")
//        enemyLaser.setScale(1)
//        enemyLaser.position = enemy.position // Spawn enemy laser at postion of the enemy
//        enemyLaser.zPosition = 1 // Spawn under player ship
//        enemyLaser.physicsBody = SKPhysicsBody(rectangleOf: enemyLaser.size) // add physicsBody (Collision Detection Box) to the size of enemyLaser
//        enemyLaser.physicsBody!.affectedByGravity = false // make sure the attached physicsBody does not use gravity to pull enemyLaser down
//        enemyLaser.physicsBody!.categoryBitMask = PhysicsLayers.EnemyLaser // assigned enemyLaser to phyiscs layer Laser
//        enemyLaser.physicsBody!.collisionBitMask = PhysicsLayers.None // Collision cannot occur with any layer
//        enemyLaser.physicsBody!.contactTestBitMask = PhysicsLayers.Player // enemyLaser phyiscs layer can make contact with phyiscs layers of enemy
//        self.addChild(enemyLaser) // add enemyLaser to scene
//
//        let moveEnemyLaser = SKAction.moveTo(y: self.size.height - enemyLaser.size.height, duration: 1) // move Laser down along Y axis for 1 sec
//        let deleteEnemyLaser = SKAction.removeFromParent() // delete after 1 sec
//
//        let laserSequence = SKAction.sequence([laserSound, moveEnemyLaser, deleteEnemyLaser]) // sequence of events for shooting player lasers
//        enemyLaser.run(laserSequence)
//    }
    
    func spawnEnemy () {
        
        let randomXStart = CGFloat.random(min: gameSpace.minX, max: gameSpace.maxX) // Random Enemy Start X-Axis position (Spawn Position)
        let randomXEnd = CGFloat.random(min: gameSpace.minX, max: gameSpace.maxX) // Random Enemy End X-Axis position
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2) // Spawn position is Random X Start Postion and just above screen space
        let endPoint = CGPoint (x: randomXEnd, y: -self.size.height * 0.2) // End Postion is Random X End Position and just below screen space
        
        // Enemy Ship Settings
        let enemy = SKSpriteNode(imageNamed: "EnemyShip")
        enemy.setScale(0.3) // Set Scale of Enemy Ship (1) being Normal
        enemy.position = startPoint // set postion of enemy ship
        enemy.zPosition = 2 // zPostion of enemy
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size) // add physicsBody (Collision Detection Box) to the size of enemy ship
        enemy.physicsBody!.affectedByGravity = false // make sure the attached physicsBody does not use gravity to pull enemy down
        enemy.physicsBody!.categoryBitMask = PhysicsLayers.Enemy // assigned enemy ship to phyiscs layer Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsLayers.None // Collision cannot occur with any layer
        enemy.physicsBody!.contactTestBitMask = PhysicsLayers.Player | PhysicsLayers.PlayerLaser // enemy ship phyiscs layer can make contact with phyiscs layers of player or laser
        self.addChild(enemy) // Add enemy ship to the scene
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 5) // Move enmy ship to endPoint in set seconds
        let deleteEnemy = SKAction.removeFromParent() // delete enemy
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy]) // sequence of enemy ship
        enemy.run(enemySequence)
        
        // Rotation of Enemy Ship
        let deltaX = endPoint.x - startPoint.x
        let deltaY = endPoint.y - startPoint.y
        let amountToRotate = atan2(deltaY, deltaX)
        enemy.zRotation = amountToRotate
        
        // Fire Enemy Laser at Random Time Intervals
//        let spawnEnemyLaser = SKAction.run(spawnEnemy)
//        let waitToSpawnEnemyLaser = SKAction.wait(forDuration: 3)
//        let spawnSequenceEnemyLaser = SKAction.sequence([spawnEnemyLaser, waitToSpawnEnemyLaser])
//        let spawnForeverEnemyLaser = SKAction.repeatForever(spawnSequenceEnemyLaser)
//        self.run(spawnForeverEnemyLaser)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        firePlayerLaser()
        //spawnEnemy() // Just for testing
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self) // where player is touching the screen now
            let previousPointOfTouch = touch.previousLocation(in: self) // where player was touching the screen
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x // get the difference
            
            player.position.x += amountDragged // add to the player ship position to move
            
            if player.position.x > gameSpace.maxX - player.size.width / 2 { // If player moves to the maximum right, restrain position before that boarder
                player.position.x = gameSpace.maxX - player.size.width / 2
            }
            
            if player.position.x < gameSpace.minX + player.size.width / 2 { // If player moves to the minimum left, restrain position before that boarder
                player.position.x = gameSpace.minX + player.size.width / 2
            }
        }
    }
   
}