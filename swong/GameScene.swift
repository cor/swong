//
//  GameScene.swift
//  swong
//
//  Created by Cor Pruijs on 29-07-14.
//  Copyright (c) 2014 Cor Pruijs. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let ball = SKSpriteNode(imageNamed: "ball")
    let gamenameLabel = SKLabelNode(fontNamed:"Helvetica")
    let movespeed = 0.0005

    
    override func didMoveToView(view: SKView) {

        self.backgroundColor = SKColor(red: 0.31, green: 0.39, blue: 0.4, alpha: 1)

        gamenameLabel.text = "Swong";
        gamenameLabel.fontSize = 65;
        gamenameLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        gamenameLabel.zPosition = -10
        self.addChild(gamenameLabel)
        
        ball.size = CGSizeMake(50, 50)
        ball.position = CGPointMake(self.frame.midX, self.frame.midY)
        self.addChild(ball)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
       
        for touch: AnyObject in touches {
            let taplocaltion = touch.locationInNode(self)
            self.ball.runAction(SKAction.moveTo(taplocaltion, duration: movespeed))
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        for touch: AnyObject in touches {
            let taplocaltion = touch.locationInNode(self)
            self.ball.runAction(SKAction.moveTo(taplocaltion, duration: movespeed))
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
