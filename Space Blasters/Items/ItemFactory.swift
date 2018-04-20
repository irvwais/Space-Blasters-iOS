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
var doubleLaserAdded : Bool = false // flag for wither double laser item has been added or not
var onePLusLifeAdded : Bool = false // flag for wither one plus life item had been added or not

class ItemFactory {
    
    let itemsArray = [1]
    
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
    
    func selectRandItem () {
        
        //let rand = Int.random (min: Item.noItem.rawValue, max: Item.plusOneLife.rawValue)
        //let randItem = Int32.random(min: 1, max: Int32(itemsArray.count))
        //let rand : UInt32 = arc4random() % 3
        let randItem : UInt32 = arc4random_uniform(2)
        
        if randItem == 0 { // No Item Settings
            print("No Item Selected...\(randItem)")
            onePLusLifeAdded = false
            doubleLaserAdded = false
        }
        
        if randItem == 1 { // One Plus Life Item Settings
            print("One Plus Life Item Selected...\(randItem)")
            onePLusLifeAdded = true
            doubleLaserAdded = false

        }
        
//        if randItem == 2 { // Doulbe Laser Item Settings
//            print("Double Lasers Item Selected...\(randItem)")
//            onePLusLifeAdded = false
//            doubleLaserAdded = true
//        }
        
    }
}
