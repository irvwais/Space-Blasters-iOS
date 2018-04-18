//
//  ItemFactory.swift
//  Space Blasters
//
//  Created by Irving Waisman on 2018-04-17.
//  Copyright © 2018 Irving Waisman. All rights reserved.
//

import Foundation
import SpriteKit

var itemFactoryInstance = ItemFactory()

class ItemFactory {
    
    let itemsArray = [2]
    
//    struct Items {
//
//        static let NoItem : Int = 0
//        static let DoubleLaser : Int = 1
//        static let PlusOneLife : Int = 2
//    }
    
//    enum Item : Int {
//        case noItem = itemsArray[0] // no item
//        case doubleLasers = 1 // double lasers
//        case plusOneLife = 2 // give player one extra life
//    }
    
    //var currentItem = Item.noItem // store current item with intial value of no item
    
    func makeItem () {
        
        //let rand = Int.random (min: Item.noItem.rawValue, max: Item.plusOneLife.rawValue)
        //let randItem = Int32.random(min: 1, max: Int32(itemsArray.count))
        //let rand : UInt32 = arc4random() % 3
        let randItem : UInt32 = arc4random_uniform(3)
        
        if randItem == 0 { // No Item Settings
            print("No Item Selected...\(randItem)")
        }
        
        if randItem == 1 { // Doulbe Laser Item Settings
            print("Double Lasers Item Selected...\(randItem)")
            let doubleLaserItem = SKSpriteNode (imageNamed: "DoubleLaserItem")
            doubleLaserItem.name = "DoubleLaserItemRef"
            doubleLaserItem.setScale(0.8)
            doubleLaserItem.position = (GameScene.self.childNode(withName: "EnemyBossRef")?.position)!
            doubleLaserItem.zPosition = 2
            doubleLaserItem.physicsBody = SKPhysicsBody(rectangleOf: doubleLaserItem.size)
            doubleLaserItem.physicsBody!.affectedByGravity = false
            doubleLaserItem.physicsBody!.categoryBitMask = GameScene.PhysicsLayers.DBLaserItemLayer
            doubleLaserItem.physicsBody!.collisionBitMask = GameScene.PhysicsLayers.None
            doubleLaserItem.physicsBody!.contactTestBitMask = GameScene.PhysicsLayers.Player
            
            //GameScene.addChild(doubleLaserItem)
            
            let moveEnemyDBItem = SKAction.moveTo(y: -self.size.height + doubleLaserItem.size.height, duration: 3) // move Laser down along Y axis for set duration
            let deleteDBItem = SKAction.removeFromParent() // delete after 1 sec
            
            let dbItemSequence = SKAction.sequence([moveEnemyDBItem, deleteDBItem]) // sequence of events for shooting player lasers
            doubleLaserItem.run(dbItemSequence)
        }
        
        if randItem == 2 { // One Plus Life Item Settings
            print("One Plus Life Item Selected...\(randItem)")
            let onePlusLifeItem = SKSpriteNode (imageNamed: "OnePlusLifeItem")
            onePlusLifeItem.name = "OnePlusLifeItemRef"
            onePlusLifeItem.setScale(0.8)
            onePlusLifeItem.position = (GameScene.self.childNode(withName: "EnemyBossRef")?.position)!
            onePlusLifeItem.zPosition = 2
            onePlusLifeItem.physicsBody = SKPhysicsBody(rectangleOf: onePlusLifeItem.size)
            onePlusLifeItem.physicsBody!.affectedByGravity = false
            onePlusLifeItem.physicsBody!.categoryBitMask = GameScene.PhysicsLayers.OPLifeItemLayer
            onePlusLifeItem.physicsBody!.collisionBitMask = GameScene.PhysicsLayers.None
            onePlusLifeItem.physicsBody!.contactTestBitMask = GameScene.PhysicsLayers.Player
            
            //GameScene.addChild(onePlusLifeItem)
            
            let moveEnemyDBItem = SKAction.moveTo(y: -self.size.height + onePlusLifeItem.size.height, duration: 3) // move Laser down along Y axis for set duration
            let deleteDBItem = SKAction.removeFromParent() // delete after 1 sec
            
            let dbItemSequence = SKAction.sequence([moveEnemyDBItem, deleteDBItem]) // sequence of events for shooting player lasers
            onePlusLifeItem.run(dbItemSequence)

        }
        
    }
}
