//
//  GameViewController.swift
//  swong
//
//  Created by Cor Pruijs on 29-07-14.
//  Copyright (c) 2014 Cor Pruijs. All rights reserved.
//

import UIKit
import SpriteKit


extension SKNode {
   class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
            
            var sceneData: NSData? = nil
            do {
                sceneData = try NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            } catch {
                sceneData = nil
            }
            
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData!)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {

    //true  -> show fps and node count,
    //false -> don't show fps and node count
    let showdata = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView =  self.view as! SKView
            skView.showsFPS = showdata
            skView.showsNodeCount = showdata
            skView.multipleTouchEnabled = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = SKSceneScaleMode.ResizeFill
            scene.size = CGSize(width: skView.bounds.size.width * 2, height: skView.bounds.size.height * 2)
            
            skView.presentScene(scene)
        }

    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
