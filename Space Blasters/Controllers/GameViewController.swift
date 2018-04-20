//
//  GameViewController.swift
//  Space Blasters
//
//  Created by Waisman Irving on 4/9/18.
//  Copyright © 2018 Irving Waisman. All rights reserved.
//
// Is this Google Ad Attempt 1

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
import GoogleMobileAds

class GameViewController: UIViewController {
    
    var backgroundMusic = AVAudioPlayer()
    
    //@IBOutlet weak var bannerView: GADBannerView!
    
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
        
        // Find BannerView and SetUp Correctly
//        bannerView.isHidden = true
//        bannerView.delegate = self
//        bannerView.adUnitID = "ca-app-pub-5176335160186260/5577228846"
//        bannerView.adSize = kGADAdSizeSmartBannerPortrait
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
//        //request.testDevices = in @[ kGADSimulatorID ]
        
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
            
            var adBanner: GADBannerView!
            
            adBanner = GADBannerView(adSize:kGADAdSizeBanner)
            
            //banner id
            adBanner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            adBanner.rootViewController = self
            addBannerViewToView(adBanner)
            
            let request: GADRequest = GADRequest()
            request.testDevices = [kGADSimulatorID]
            adBanner.load(request)
            
            // Load the SKScene from 'GameScene.sks'
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
    
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//
//        bannerView.isHidden = false
//    }
//
//    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
//
//        bannerView.isHidden = true
//    }
    
    func addBannerViewToView(_ bannerView: GADBannerView){
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints([NSLayoutConstraint(item: bannerView,
                                                attribute: .bottom,
                                                relatedBy: .equal,
                                                toItem: bottomLayoutGuide,
                                                attribute: .top,
                                                multiplier: 1,
                                                constant: 0),
                             NSLayoutConstraint(item: bannerView,
                                                attribute: .centerX,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: .centerX,
                                                multiplier: 1,
                                                constant: 0)])
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
