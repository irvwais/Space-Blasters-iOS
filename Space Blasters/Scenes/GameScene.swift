//
//  GameScene.swift
//  Space Blasters
//
//  Created by Waisman Irving on 4/9/18.
//  Copyright © 2018 Irving Waisman. All rights reserved.
//

import SpriteKit
import GameplayKit

// Declare Objects Globally to be Accessed By any Class in the Project
var gameScore = 0 // score count starts at zero


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Declare Objects globally to be accessed by any func in class
    var lastUpdateTime: TimeInterval = 0 // store time of last frame
    var deltaTime: TimeInterval = 0 // store the difference in time
    let amountToMovePerSecond: CGFloat = 300.0 // movement of bakcground per second
    
    let scoreText = SKLabelNode (fontNamed: "Heavy Font") // UIFont(name: "moon_get-Heavy", size: 10)
    
    var livesCount = 5 // player starts with 5 lives
    let livesText = SKLabelNode (fontNamed: "Heavy Font")
    
    let tapToPlayText = SKLabelNode(fontNamed: "Heavy Font")
    
    var levelNumber = 0 // variable starts at level 0
    var enemyShipSpeed: Double = 5 // speed for enemy kamikaze ships
    
    // Enemy Boss Stats
    //let enemyBoss = SKSpriteNode(imageNamed: "BossShip")
    var enemyBossSpeed: Double = 5 // speed for enemy boss
    var yesSpawnEnemyBoss : Bool = false // flag for spawning enemyBoss
    var enemBossLives = 3 // amount lives for the enemy boss
    
    let player = SKSpriteNode (imageNamed: "PlayerShip1")
    //let enemy = SKSpriteNode(imageNamed: "EnemyShip")
    
    // Sound FX
    let laserSound = SKAction.playSoundFileNamed("laserSound.wav", waitForCompletion: false)
    let boomSound = SKAction.playSoundFileNamed("boomSound.wav", waitForCompletion: false)
    
    enum GameState: Int {
        
        case preGame = 0 // When Game State is before the start of the game
        case inGame = 1 // When Game State is running and we are in game
        case postGame = 2 // When Game State is after playing game (Game Over)
    }
    
    var currentGameState = GameState.preGame // store current game state, intial state is preGame (Main Menu)
    
    struct PhysicsLayers {
        
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 // 1 in binary
        static let PlayerLaser : UInt32 = 0b10 // 2 in binary
        static let Enemy : UInt32 = 0b100 // 4 in binary
        static let EnemyLaser : UInt32 = 0b1000 // 8 in binary
        static let EnemyBoss : UInt32 = 0b10000 // 16 in binary
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
        
        gameScore = 0 // Reset game score back to zero
        
        self.physicsWorld.contactDelegate = self // Set Up Physics to be delegated to this class
        
        for i in 0...1 { // Loop through background settings twice to create two backgrounds
            // Background Settings
            let background = SKSpriteNode (imageNamed: "Background1")
            background.name = "BackgroundRef" // Refernce name for Background
            background.size = self.size // Set Size of Background as the same size of the scene
            background.anchorPoint = CGPoint (x: 0.5, y: 0) // make anchor point of the background the bottom of the screen
            background.position = CGPoint (x: self.size.width / 2, y: self.size.height * CGFloat (i)) // first loop will make y position same as anchor point, second loop will make position at the top of the screen
            background.zPosition = 0 // Put Background furthur back
            self.addChild(background) // Add Background to the scene
        }
        
        // Player Settings
        player.setScale(0.2) // Size of Player Ship Image (1) being normal size
        player.position = CGPoint (x: self.size.width / 2, y: 0 - player.size.height) // Start player just off the bottom of screen
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size) // add physicsBody (Collision Detection Box) to the size of player ship
        player.physicsBody!.affectedByGravity = false // make sure the attached physicsBody does not use gravity to pull player down
        player.physicsBody!.categoryBitMask = PhysicsLayers.Player // assigned player ship to phyiscs layer Player
        player.physicsBody!.collisionBitMask = PhysicsLayers.None // Collision cannot occur with any layer
        player.physicsBody!.contactTestBitMask = PhysicsLayers.Enemy //| PhysicsLayers.EnemyLaser // player phyiscs layer can make contact with phyiscs layers of enemy and enemyLaser
        self.addChild(player) // Add player to the scene
        
        // Jet Particle Effect Settings
        let jetPath = Bundle.main.path(forResource: "JetEmitter", ofType: "sks")!
        let jet = NSKeyedUnarchiver.unarchiveObject(withFile: jetPath) as! SKEmitterNode
        jet.xScale = 5
        jet.yScale = 5
        jet.position.y = player.position.y - 30
        jet.zPosition = 0
        player.addChild(jet)
        
        // Score Text Settings
        scoreText.text = "Score: 0" // Text for score to display at start of game
        scoreText.fontSize = 70 // Size of Score Text
        scoreText.fontColor = SKColor.white // Colour of Score text
        scoreText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left // Make sure that if score increases that text is stuck to the left of screen
        scoreText.position = CGPoint(x: self.size.width * 0.15, y: self.size.height + scoreText.frame.size.height) // position of score text
        scoreText.zPosition = 50 // High z position to gurantee that score is always on top of gameplay
        self.addChild(scoreText) // add score text to scene
        
        // Lives Text Settings
        livesText.text = "Lives: 5"
        livesText.fontSize = 70
        livesText.fontColor = SKColor.white
        livesText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesText.position = CGPoint(x: self.size.width * 0.85, y: self.size.height + livesText.frame.size.height) // position of score text
        livesText.zPosition = 50 // High z position to gurantee that score is always on top of gameplay
        self.addChild(livesText) // add score text to scene
        
        // Move Socre Text and Lives Text into view of Screen
        let moveOnToScreen = SKAction.moveTo(y: self.size.height * 0.9, duration: 0.5)
        scoreText.run(moveOnToScreen)
        livesText.run(moveOnToScreen)
        
        // Tap to Play Text Settings
        tapToPlayText.text = "Tap to Play"
        tapToPlayText.fontSize = 100
        tapToPlayText.fontColor = SKColor.white
        tapToPlayText.zPosition = 1
        tapToPlayText.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        tapToPlayText.alpha = 0
        self.addChild(tapToPlayText)
        
        let fadeInTapToPlayText = SKAction.fadeIn(withDuration: 0.5)
        tapToPlayText.run(fadeInTapToPlayText)
        
        //startLevel()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime // make the intial time the same as current time
        } else {
            deltaTime = currentTime - lastUpdateTime // the change in time from intial frame to last frame
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaTime)
        
        // Paralax Background
        self.enumerateChildNodes(withName: "BackgroundRef") {
            background, stop in
            
            if self.currentGameState == GameState.inGame { // only move background if the game is in session
                background.position.y -= amountToMoveBackground
            }
            
            if background.position.y < -self.size.height {
                background.position.y += self.size.height * 2
            }
        }
    }
    
    func startGame () {
        
        currentGameState = GameState.inGame // change state of game to in game (playing game)
        
        // Run code to fade out Tap to Play Text
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let delete = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOut, delete])
        tapToPlayText.run(deleteSequence)
        
        // Run code to Move player ship onto the Screen and start the first level
        let movePlayerOntoScreen = SKAction.moveTo(y: self.size.height * 0.2 , duration: 0.5)
        let startLevelAction = SKAction.run(startLevel)
        let startGameSequence = SKAction.sequence([movePlayerOntoScreen, startLevelAction])
        player.run(startGameSequence)
    }
    
    func addScore () {
        
        gameScore += 10
        scoreText.text = "Score: \(gameScore)"
        
        if gameScore == 50 || // if score reaches 50 start level 2
            gameScore == 100 || // if score reaches 100 start level 3
            gameScore == 150 || // if score reaches 150 start level 4
            gameScore == 200 || // if score reaches 200 start level 5
            gameScore == 250 || // if score reaches 250 start level 6
            gameScore == 300 || // if score reaches 300 start level 7
            gameScore == 350 || // if score reaches 350 start level 8
            gameScore == 400 || // if score reaches 400 start level 9
            gameScore == 450 { // if score reaches 450 start level 10
                startLevel()
        }
    }
    
    func loseLives () {
        
        livesCount -= 1
        livesText.text = "Lives: \(livesCount)"
        
        // Animate lives text to make player pay attention to live count
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.3)
        let scaleDown = SKAction.scale(to: 1, duration: 0.3)
        let changeColor = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0)
        let returnColor = SKAction.colorize(with: UIColor.white, colorBlendFactor: 1, duration: 0)
        let scaleTextSequence = SKAction.sequence([changeColor, scaleUp, scaleDown, returnColor])
        livesText.run(scaleTextSequence)
        
        if livesCount == 0 {
            runGameOver()
        }
    }
    
    func runGameOver () {
        
        currentGameState = GameState.postGame
        
        self.removeAllActions() // stop all actions running on the scene
        
        self.enumerateChildNodes(withName: "PlayerLaserRef") { // find all nodes in scene with reference name PlayerLaserRef
            playerLaser, stop in // cycle through callin each playerLaser Node
            playerLaser.removeAllActions() // stop all actions of playerLaser
        }
        
        self.enumerateChildNodes(withName: "EnemyLaserRef") { // find all nodes in scene with reference name EnemyLaserRef
            enemyLaser, stop in // cycle through callin each enemyLaser Node
            enemyLaser.removeAllActions() // stop all actions of enemyLaser
        }
        
        self.enumerateChildNodes(withName: "EnemyBossRef") { // find all nodes in scene with reference name EnemyBossRef
            enemyBoss, stop in // cycle through callin each enemyBoss Node
            enemyBoss.removeAllActions() // stop all actions of enemyBoss
        }
        
        self.enumerateChildNodes(withName: "EnemyShipRef") { // find all nodes in scene with reference name EnemyShipRef
            enemy, stop in // cycle through callin each enemy Node
            enemy.removeAllActions() // stop all actions of enemy
        }
        
        let changeScene = SKAction.run(callGameOverScene)
        let waitToChancgeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChancgeScene, changeScene])
        self.run(changeSceneSequence)
    }
    
    func callGameOverScene() {
        
        let callScene = GameOverScene(size: self.size) // make sure game over scene is the same size as game scene
        callScene.scaleMode = self.scaleMode // same goes for the scale
        let sceneTransition = SKTransition.fade(withDuration: 0.5) // transition to scne in set duration
        self.view!.presentScene(callScene, transition: sceneTransition) // call scene
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
            
            runGameOver()
        }
        
        // if playerLaser and enemy have made contact and enemy is on the screen
        if body1.categoryBitMask == PhysicsLayers.PlayerLaser && body2.categoryBitMask == PhysicsLayers.Enemy && (body2.node?.position.y)! < self.size.height {
            
            addScore() // call add score method when player shoots enemy ship
            
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position) // spawn explosion at the position of body2 (enemy ship)
            }

            // ? (optional) because two bodies of the same layer might make contact at the same time which could crash the game
            body1.node?.removeFromParent() // find the node accosiated with the body1 and delete it
            body2.node?.removeFromParent() // find the node accosiated with the body2 and delete it
        }
        
        // if playerLaser and enemy boss have made contact and enemy is on the screen
        if body1.categoryBitMask == PhysicsLayers.PlayerLaser && body2.categoryBitMask == PhysicsLayers.EnemyBoss && (body2.node?.position.y)! < self.size.height {
            
            enemBossLives -= 1 // decrease enemy boss life
            
            if body2.node != nil && enemBossLives == 0 {
                addScore() // call add score method when player shoots enemy boss
                body2.node?.removeFromParent() // find the node accosiated with the body2 and delete it
                enemBossLives = 3 // reset enemy boss lives to 3
                yesSpawnEnemyBoss = false
                spawnExplosion(spawnPosition: body2.node!.position) // spawn explosion at the position of body2 (enemy boss)
            }
            
            // ? (optional) because two bodies of the same layer might make contact at the same time which could crash the game
            body1.node?.removeFromParent() // find the node accosiated with the body1 and delete it
            
        }
        
        // if player and enemyLaser have made contact
        if body1.categoryBitMask == PhysicsLayers.Player && body2.categoryBitMask == PhysicsLayers.EnemyLaser {

            if body1.node != nil {
                loseLives() // lose player lives with each hit from enemy laser
                if livesCount == 0 { // if player loses all lives from being shot spawn explosion
                    spawnExplosion(spawnPosition: body1.node!.position) // spawn explosion at the position of body1 (player ship)
                    body1.node?.removeFromParent() // find the node accosiated with the body1 and delete ii
                }
            }

            // ? (optional) because two bodies of the same layer might make contact at the same time which could crash the game
            body2.node?.removeFromParent() // find the node accosiated with the body2 and delete it
        }
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
        
        levelNumber += 1 // First time this method runs start at level 1
        
        if self.action(forKey: "spawningEnemies") != nil && !yesSpawnEnemyBoss{ // if we are already spawning enemies then stop and change for the next level
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var spawnEnemyDuration = TimeInterval()
        
        switch levelNumber {
        case 1: // Level 1
            spawnEnemyDuration = 3
            enemyShipSpeed = 5
        case 2: // Level 2
            spawnEnemyDuration = 2.7
            enemyShipSpeed = 4.7
            yesSpawnEnemyBoss = true // flag for spawning enemyBoss
        case 3: // Level 3
            spawnEnemyDuration = 2.3
            enemyShipSpeed = 4.3
        case 4: // Level 4
            spawnEnemyDuration = 2.0
            enemyShipSpeed = 4.0
            yesSpawnEnemyBoss = true // flag for spawning enemyBoss
        case 5: // Level 5
            spawnEnemyDuration = 1.8
            enemyShipSpeed = 3.5
        case 6: // Level 6
            spawnEnemyDuration = 1.5
            enemyShipSpeed = 3.3
            yesSpawnEnemyBoss = true // flag for spawning enemyBoss
        case 7: // Level 7
            spawnEnemyDuration = 1.3
            enemyShipSpeed = 3.0
        case 8: // Level 8
            spawnEnemyDuration = 1
            enemyShipSpeed = 2.8
            yesSpawnEnemyBoss = true // flag for spawning enemyBoss
        case 9: // Level 9
            spawnEnemyDuration = 0.8
            enemyShipSpeed = 2.5
        case 10: // Level 10
            spawnEnemyDuration = 0.5
            enemyShipSpeed = 2
            yesSpawnEnemyBoss = true // flag for spawning enemyBoss
        default:
            spawnEnemyDuration = 3
            print("Spawn Enemy for each level ERROR!")
        }
        
        let spawn = SKAction.run(spawnEnemy)
        let spawnEnemyBosses = SKAction.run(spawnEnemyBoss)
        let waitToSpawn = SKAction.wait(forDuration: spawnEnemyDuration)
        
        if yesSpawnEnemyBoss {
            let spawnEnemyBossSequence = SKAction.sequence([waitToSpawn, spawnEnemyBosses])
            self.run(spawnEnemyBossSequence)
        } else {
            
        }
        let spawnEnemyShipSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnEnemyShipSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
        
    }
    
    func firePlayerLaser () {
        
        // Player Laser Settings
        let playerLaser = SKSpriteNode (imageNamed: "PlayerLaser")
        playerLaser.name = "PlayerLaserRef" // Reference name for Player Laser
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
    
    func fireEnemyLaser () {

        // Enemy Laser Settings
        let enemyLaser = SKSpriteNode (imageNamed: "EnemyLaser")
        enemyLaser.name = "EnemyLaserRef" // Reference name for Enemy Laser
        enemyLaser.setScale(1)
        enemyLaser.position = (self.childNode(withName: "EnemyBossRef")?.position)! // Spawn enemy laser at postion of the enemy
        enemyLaser.zPosition = 1 // Spawn under player ship
        enemyLaser.physicsBody = SKPhysicsBody(rectangleOf: enemyLaser.size) // add physicsBody (Collision Detection Box) to the size of enemyLaser
        enemyLaser.physicsBody!.affectedByGravity = false // make sure the attached physicsBody does not use gravity to pull enemyLaser down
        enemyLaser.physicsBody!.categoryBitMask = PhysicsLayers.EnemyLaser // assigned enemyLaser to phyiscs layer Laser
        enemyLaser.physicsBody!.collisionBitMask = PhysicsLayers.None // Collision cannot occur with any layer
        enemyLaser.physicsBody!.contactTestBitMask = PhysicsLayers.Player // enemyLaser phyiscs layer can make contact with phyiscs layers of enemy
        self.addChild(enemyLaser) // add enemyLaser to scene

        let moveEnemyLaser = SKAction.moveTo(y: -self.size.height + enemyLaser.size.height, duration: 1.5) // move Laser down along Y axis for set duration
        let deleteEnemyLaser = SKAction.removeFromParent() // delete after 1 sec

        let laserSequence = SKAction.sequence([laserSound, moveEnemyLaser, deleteEnemyLaser]) // sequence of events for shooting player lasers
        enemyLaser.run(laserSequence)
    }
    
    func spawnEnemyBoss () {
        
        let leftEndPoint = CGPoint (x: self.size.width * 0.23, y: self.size.height * 0.8) // leftPoint of travel for enemyBoss
        let rightEndPoint = CGPoint (x: self.size.width * 0.77, y: self.size.height * 0.8) // rightPoint of travel for enemyBoss
        
        //let randomFireLaser = CGFloat.random(min: 1, max:3) // random time for firing lasers
        
        // Enemy Boss Settings
        let enemyBoss = SKSpriteNode(imageNamed: "BossShip")
        enemyBoss.name = "EnemyBossRef" // Reference for Enemy Boss
        enemyBoss.setScale(1.5) // Set scale of enemy Boss (1) being normal
        enemyBoss.position = CGPoint (x: self.size.width / 2, y: self.size.height * 1.2) // spawn enemy boss just above top of screen
        enemyBoss.zPosition = 2 // zPosition of enemy boss
        enemyBoss.physicsBody = SKPhysicsBody(rectangleOf: enemyBoss.size) // add physicsBody (Collision Detection Box) to the size of enemy boss
        enemyBoss.physicsBody!.affectedByGravity = false // make sure the attached physicsBody does not use gravity to pull enemyBoss down
        enemyBoss.physicsBody!.categoryBitMask = PhysicsLayers.EnemyBoss // assigned enemyBoss to phyiscs layer Enemy
        enemyBoss.physicsBody!.collisionBitMask = PhysicsLayers.None // Collision cannot occur with any layer
        enemyBoss.physicsBody!.contactTestBitMask = PhysicsLayers.PlayerLaser // enemy ship phyiscs layer can make contact with phyiscs layers of laser
        self.addChild(enemyBoss) // Add enemyBoss to the scene
        
        let moveEnemyBossLeft = SKAction.move(to: leftEndPoint, duration: enemyBossSpeed) // move enemyBoss to left end point
        let moveEnemyBossRight = SKAction.move(to: rightEndPoint, duration: enemyBossSpeed) // move enemyBoss to right end point
        let fireLaser = SKAction.run(fireEnemyLaser) // variable for running method firEnemyLaser
        let deleteEnemyBoss = SKAction.removeFromParent() // delete enemyBoss
        
        if !yesSpawnEnemyBoss {
            enemyBoss.run(deleteEnemyBoss)
        } else {
            let enemyBossSequence = SKAction.sequence([moveEnemyBossLeft, moveEnemyBossRight]) // sequence of enemy boss movment
            let moveEnemyBossWhileAlive = SKAction.repeatForever(enemyBossSequence) // move enemy boss while it has lives
            
            // Fire Enemy Laser at Random Time Intervals
            let waitToShootEnemyLaser = SKAction.wait(forDuration: 3, withRange: 1) //wait(forDuration: randomFireLaser)
            let spawnSequenceEnemyLaser = SKAction.sequence([fireLaser, waitToShootEnemyLaser])
            let spawnForeverEnemyLaser = SKAction.repeatForever(spawnSequenceEnemyLaser)
            
            if currentGameState == GameState.inGame { // only this sequence if game is actually running
                enemyBoss.run(moveEnemyBossWhileAlive)
                //if enemyBoss.position.y < self.size.height { // only when in correct position fire enemy laser
                    enemyBoss.run(spawnForeverEnemyLaser)
                //}
            }
        }
    }
    
    func spawnEnemy () {
        
        let randomXStart = CGFloat.random(min: gameSpace.minX, max: gameSpace.maxX) // Random Enemy Start X-Axis position (Spawn Position)
        let randomXEnd = CGFloat.random(min: gameSpace.minX, max: gameSpace.maxX) // Random Enemy End X-Axis position
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2) // Spawn position is Random X Start Postion and just above screen space
        let endPoint = CGPoint (x: randomXEnd, y: -self.size.height * 0.2) // End Postion is Random X End Position and just below screen space
        
        // Enemy Ship Settings
        let enemy = SKSpriteNode(imageNamed: "EnemyShip")
        enemy.name = "EnemyShipRef" // Reference for Enemy Boss
        enemy.setScale(0.3) // Set Scale of Enemy Ship (1) being Normal
        enemy.position = startPoint // set postion of enemy ship
        enemy.zPosition = 2 // zPostion of enemy
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size) // add physicsBody (Collision Detection Box) to the size of enemy ship
        enemy.physicsBody!.affectedByGravity = false // make sure the attached physicsBody does not use gravity to pull enemy down
        enemy.physicsBody!.categoryBitMask = PhysicsLayers.Enemy // assigned enemy ship to phyiscs layer Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsLayers.None // Collision cannot occur with any layer
        enemy.physicsBody!.contactTestBitMask = PhysicsLayers.Player | PhysicsLayers.PlayerLaser // enemy ship phyiscs layer can make contact with phyiscs layers of player or laser
        self.addChild(enemy) // Add enemy ship to the scene
        
        let moveEnemy = SKAction.move(to: endPoint, duration: enemyShipSpeed) // Move enemy ship to endPoint in set seconds
        let deleteEnemy = SKAction.removeFromParent() // delete enemy
        let enemyPassedPlayer = SKAction.run(loseLives) // if enemy ship flies past the player run method loseLives
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, enemyPassedPlayer]) // sequence of enemy ship
        
        if currentGameState == GameState.inGame { // only this sequence if game is actually running
            enemy.run(enemySequence)
        }
        
        // Rotation of Enemy Ship
        let deltaX = endPoint.x - startPoint.x
        let deltaY = endPoint.y - startPoint.y
        let amountToRotate = atan2(deltaY, deltaX)
        enemy.zRotation = amountToRotate
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == GameState.preGame { // if the game state is pre game start the game
            startGame()
        } else if currentGameState == GameState.inGame { // only allow player to shoot laser if the Current Game State is duringGame
            firePlayerLaser()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self) // where player is touching the screen now
            let previousPointOfTouch = touch.previousLocation(in: self) // where player was touching the screen
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x // get the difference
            
            if currentGameState == GameState.inGame { // only allow player to move ship if the Current Game State is duringGame
                player.position.x += amountDragged // add to the player ship position to move
            }
            
            if player.position.x > gameSpace.maxX - player.size.width / 2 { // If player moves to the maximum right, restrain position before that boarder
                player.position.x = gameSpace.maxX - player.size.width / 2
            }
            
            if player.position.x < gameSpace.minX + player.size.width / 2 { // If player moves to the minimum left, restrain position before that boarder
                player.position.x = gameSpace.minX + player.size.width / 2
            }
        }
    }
   
}
