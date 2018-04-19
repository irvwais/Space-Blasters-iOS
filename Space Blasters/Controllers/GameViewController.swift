//
//  GameViewController.swift
//  Space Blasters
//
//  Created by Waisman Irving on 4/9/18.
//  Copyright © 2018 Irving Waisman. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    var backgroundMusic = AVAudioPlayer()
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    } */
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Find music to laod correctly
        let filePathForBackgroundMusic = Bundle.main.path(forResource: "backgroundMusic", ofType: "wav")
        let audioNSURL = NSURL(fileURLWithPath: filePathForBackgroundMusic!)
        
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: audioNSURL as URL)
        } catch {
            return print("Audio not FOUND!")
        }
        
        backgroundMusic.numberOfLoops = -1 // loop bakcground music forever
        backgroundMusic.play() // play background music
        
        // Find Fonts to load Correctly
//        for family: String in UIFont.familyNames {
//            print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family) {
//                print("== \(names)")
//            }
//        }
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            //let scene = MainMenuScene(size: self.view.bounds.size)
            let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
