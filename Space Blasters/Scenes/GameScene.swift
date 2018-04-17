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
var enemyLetThroughCount = 0 // Counter that tracks how many enemies got passed you
var enemyBossesKilled = 0 // count for enemy bosses killed

//var gameSceneClassInstance = GameScene()


class GameScene: SKScene {
    
    ////////////////////////////
    ///////
    var playerClass: Player?
//    var enemyBossClass: EnemyBoss?
//    var enemyShipsClass: EnemyShips?
    var collisionDetectionClass: CollisionDetection?
    ///////
    ////////////////////////////
    
    // Declare Objects globally to be accessed by any func in class
    var lastUpdateTime: TimeInterval = 0 // store time of last frame
    var deltaTime: TimeInterval = 0 // store the difference in time
    let amountToMovePerSecond: CGFloat = 300.0 // movement of bakcground per second
    
    let scoreText = SKLabelNode (fontNamed: "Heavy Font") // UIFont(name: "moon_get-Heavy", size: 10)
    
    var livesCount = 5 // player starts with 5 lives
    let livesText = SKLabelNode (fontNamed: "Heavy Font")
    
    let enemyLetThroughText = SKLabelNode (fontNamed: "Heavy Font")
    
    let tapToPlayText = SKLabelNode(fontNamed: "Heavy Font")
    
    var levelNumber = 0 // variable starts at level 0
    
    
    
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
    
    let gameSpace : CGRect
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0 / 9.0 // How wide the game are should be
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameSpace = CGRect (x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
        
        
        playerClass = Player()
        playerClass?.gameSceneClass = self
        //playerClassInstance.gameSceneClass = self
//        enemyShipsClass = EnemyShips()
//        enemyBossClass = EnemyBoss()
        collisionDetectionClass = CollisionDetection() // Set Up Physics to be delegated to this class
        collisionDetectionClass?.gameSceneClass = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove (to view: SKView) {
        
        
        
        gameScore = 0 // Reset game score back to zero
        enemyBossesKilled = 0 // Reset Enemy Bosses Killed Count back to zero
        enemyLetThroughCount = 0 // Reset Enemy Let Through Count back to zero
        
        //self.physicsWorld.contactDelegate = self // Set Up Physics to be delegated to this class
        physicsWorld.contactDelegate = collisionDetectionClass

        // Call laserAnimate from Player Class
        playerClass!.laserAnimate()
        
        // Call laserAnimate from Enemy Boss Class
        enemyBossClassInstance.laserAnimate()
        
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
        
        // Call playerSetUp func from Player Class
        playerClass!.objectSetUp()
        //self.addChild(Player())
        
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
        let moveOnToScreen = SKAction.moveTo(y: self.size.height * 0.95, duration: 0.5)
        scoreText.run(moveOnToScreen)
        livesText.run(moveOnToScreen)
        
        // Count For Enemies Passed Text Settings
        enemyLetThroughText.text = "0" // Text for score to display at start of game
        enemyLetThroughText.fontSize = 70 // Size of Score Text
        enemyLetThroughText.fontColor = SKColor.white // Colour of Score text
        enemyLetThroughText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right // Make sure that if score increases that text is stuck to the left of screen
        enemyLetThroughText.position = CGPoint(x: self.size.width * 0.2, y: -self.size.height + enemyLetThroughText.frame.size.height) // position of score text
        enemyLetThroughText.zPosition = 50 // High z position to gurantee that score is always on top of gameplay
        self.addChild(enemyLetThroughText) // add score text to scene
        
        // Move Socre Text and Lives Text into view of Screen
        let moveOnToTopTextScreen = SKAction.moveTo(y: self.size.height * 0.05, duration: 0.5)
        enemyLetThroughText.run(moveOnToTopTextScreen)
        
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
        playerClass!.playerNode.run(startGameSequence)
    }
    
    func addScore () {
        
        gameScore += 10
        scoreText.text = "Score: \(gameScore)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.3)
        let scaleDown = SKAction.scale(to: 1, duration: 0.3)
        let changeColor = SKAction.colorize(with: UIColor.blue, colorBlendFactor: 1, duration: 0)
        let returnColor = SKAction.colorize(with: UIColor.white, colorBlendFactor: 1, duration: 0)
        let scaleTextSequence = SKAction.sequence([changeColor, scaleUp, scaleDown, returnColor])
        scoreText.run(scaleTextSequence)
        
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
    
    func countForEnemiesPassed () {
        
        enemyLetThroughCount += 1
        enemyLetThroughText.text = "\(enemyLetThroughCount)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.3)
        let scaleDown = SKAction.scale(to: 1, duration: 0.3)
        let changeColor = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0)
        let returnColor = SKAction.colorize(with: UIColor.white, colorBlendFactor: 1, duration: 0)
        let scaleTextSequence = SKAction.sequence([changeColor, scaleUp, scaleDown, returnColor])
        enemyLetThroughText.run(scaleTextSequence)
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
        
        if self.action(forKey: "spawningEnemies") != nil && !enemyBossClassInstance.yesSpawnEnemyBoss{ // if we are already spawning enemies then stop and change for the next level
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var spawnEnemyDuration = TimeInterval()
        
        switch levelNumber {
        case 1: // Level 1
            spawnEnemyDuration = 3
            enemyShipsClassInstance.enemyShipSpeed = 5
        case 2: // Level 2
            spawnEnemyDuration = 2.7
            enemyShipsClassInstance.enemyShipSpeed = 4.7
            enemyBossClassInstance.yesSpawnEnemyBoss = true // flag for spawning enemyBoss
        case 3: // Level 3
            spawnEnemyDuration = 2.3
            enemyShipsClassInstance.enemyShipSpeed = 4.3
        case 4: // Level 4
            spawnEnemyDuration = 2.0
            enemyShipsClassInstance.enemyShipSpeed = 4.0
            enemyBossClassInstance.enemyBossXSpeed = 4
            //enemyBossYSpeed = 25
            enemyBossClassInstance.enemBossLives = 5 // reset enemy boss lives to 5
            enemyBossClassInstance.yesSpawnEnemyBoss = true // flag for spawning enemyBoss
        case 5: // Level 5
            spawnEnemyDuration = 1.8
            enemyShipsClassInstance.enemyShipSpeed = 3.5
        case 6: // Level 6
            spawnEnemyDuration = 1.5
            enemyShipsClassInstance.enemyShipSpeed = 3.3
            enemyBossClassInstance.enemyBossXSpeed = 3
            //enemyBossYSpeed = 20
            enemyBossClassInstance.enemBossLives = 7 // reset enemy boss lives to 7
            enemyBossClassInstance.yesSpawnEnemyBoss = true // flag for spawning enemyBoss
        case 7: // Level 7
            spawnEnemyDuration = 1.3
            enemyShipsClassInstance.enemyShipSpeed = 3.0
        case 8: // Level 8
            spawnEnemyDuration = 1
            enemyShipsClassInstance.enemyShipSpeed = 2.8
            enemyBossClassInstance.enemyBossXSpeed = 2
            enemyBossClassInstance.enemBossLives = 9 // reset enemy boss lives to 9
            //enemyBossYSpeed = 15
            enemyBossClassInstance.yesSpawnEnemyBoss = true // flag for spawning enemyBoss
        case 9: // Level 9
            spawnEnemyDuration = 0.8
            enemyShipsClassInstance.enemyShipSpeed = 2.5
        case 10: // Level 10
            spawnEnemyDuration = 0.5
            enemyShipsClassInstance.enemyShipSpeed = 2
            enemyBossClassInstance.enemyBossXSpeed = 1
            enemyBossClassInstance.enemBossLives = 12 // reset enemy boss lives to 12
            //enemyBossYSpeed = 12
            enemyBossClassInstance.yesSpawnEnemyBoss = true // flag for spawning enemyBoss
        default:
            spawnEnemyDuration = 3
            print("Spawn Enemy for each level ERROR!")
        }
        
        let spawn = SKAction.run(enemyShipsClassInstance.objectSetUp)
        let spawnEnemyBosses = SKAction.run(enemyBossClassInstance.objectSetUp)
        let waitToSpawn = SKAction.wait(forDuration: spawnEnemyDuration)
        
        if enemyBossClassInstance.yesSpawnEnemyBoss {
            let spawnEnemyBossSequence = SKAction.sequence([waitToSpawn, spawnEnemyBosses])
            self.run(spawnEnemyBossSequence)
        } else {
            
        }
        let spawnEnemyShipSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnEnemyShipSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == GameState.preGame { // if the game state is pre game start the game
            startGame()
        } else if currentGameState == GameState.inGame { // only allow player to shoot laser if the Current Game State is duringGame
            playerClass!.fireLaser()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self) // where player is touching the screen now
            let previousPointOfTouch = touch.previousLocation(in: self) // where player was touching the screen
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x // get the difference
            
            if  currentGameState == GameState.inGame { // only allow player to move ship if the Current Game State is duringGame
                playerClass!.playerNode.position.x += amountDragged // add to the player ship position to move
            }
            
            if playerClass!.playerNode.position.x > gameSpace.maxX - playerClass!.playerNode.size.width / 2 { // If player moves to the maximum right, restrain position before that boarder
                playerClass!.playerNode.position.x = gameSpace.maxX - playerClass!.playerNode.size.width / 2
            }
            
            if playerClass!.playerNode.position.x < gameSpace.minX + playerClass!.playerNode.size.width / 2 { // If player moves to the minimum left, restrain position before that boarder
                playerClass!.playerNode.position.x = gameSpace.minX + playerClass!.playerNode.size.width / 2
            }
        }
    }
    
   
}
