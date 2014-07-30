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
        
        
        
        
        
        
//        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
