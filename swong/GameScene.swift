//
//  GameScene.swift
//  swong
//
//  Created by Cor Pruijs on 29-07-14.
//  Copyright (c) 2014 Cor Pruijs. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    //for delta time
//    var lastUpdateTimeInterval: NSTimeInterval(NaN)
    
    let ball                                    = SKSpriteNode(imageNamed: "ball")
    let devbox                                  = SKSpriteNode(imageNamed: "devbox")
    let gamenameLabel                           = SKLabelNode(fontNamed: "Helvetica")
    let debugLabel                              = SKLabelNode(fontNamed: "Helvetica")
    let movespeed                               = 0.05
    var currentDirection                        = CGVectorMake(5, 5)
    var lastUpdateTimeInterval: CFTimeInterval  = 0
    
    
    var fpsCount         = 0
    
    override func didMoveToView(view: SKView) {

        
        //SCENE (SELF)
        self.backgroundColor        = SKColor(red: 0.31, green: 0.39, blue: 0.4, alpha: 1)
        self.scaleMode              = SKSceneScaleMode.Fill
        self.physicsBody            = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        //NAME LABEL
        gamenameLabel.text          = "Swong"
        gamenameLabel.fontSize      = 65
        gamenameLabel.position      = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        gamenameLabel.zPosition     = -10
        self.addChild(gamenameLabel)
        
        // BALL
        ball.size                   = CGSizeMake(50, 50)
        ball.position               = CGPointMake(self.frame.midX, self.frame.midY)
        ball.physicsBody            = SKPhysicsBody(circleOfRadius: ball.size.height / 2)
        ball.physicsBody.dynamic    = true
        
        
        self.addChild(ball)
        
        //DEVBOX
        devbox.size                 = CGSizeMake(150, 150)
        devbox.position             = CGPointMake(self.frame.midX + 0.25 * self.frame.width, self.frame.midY)
        devbox.physicsBody          = SKPhysicsBody(rectangleOfSize: devbox.size)
        devbox.physicsBody.dynamic  = false
        devbox.physicsBody.mass     = 0
        self.addChild(devbox)
        
        // DEBUG LABEL
        debugLabel.text = "x: \(ball.position.x), y: \(ball.position.y)"
        debugLabel.fontSize = 40
        debugLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:(CGRectGetMidY(self.frame) - 50 ))
        debugLabel.zPosition = -10
        self.addChild(debugLabel)
        
        println("SELF.FRAME H:\(self.frame.height), W: \(self.frame.width), S: \(self.size)")
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
       
        for touch: AnyObject in touches {
            let taplocation = touch.locationInNode(self)
            self.ball.runAction(SKAction.moveTo(taplocation, duration: movespeed))
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        
        for touch: AnyObject in touches {
            let taplocation = touch.locationInNode(self)
            self.ball.runAction(SKAction.moveTo(taplocation, duration: movespeed))
        }
    }
   

    override func update(currentTime: CFTimeInterval) {
        self.debugLabel.text = "x: \(Int(self.ball.position.x)) y: \(Int(self.ball.position.y))"

        
//        var delta: CFTimeInterval = currentTime - lastUpdateTimeInterval
//        
//        lastUpdateTimeInterval = currentTime;
//        
////        if (delta > 1.0) {
////            delta = minTimeInterval;
////        }
//        
//        updateWithTimeSinceLastUpdate(delta)
    }

    
    
    
    
//    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: CFTimeInterval) {
//        
//            if self.ball.position.x > self.frame.width - 0.5 * self.ball.size.width {
//                self.currentDirection.dx *= -1
//                
//                self.ball.runAction(SKAction.moveByX(-20, y: self.currentDirection.dy, duration: 0))
//                
//            }
//            
//            if self.ball.position.x < 0.5 * self.ball.size.width {
//                self.currentDirection.dx *= -1
//                
//                self.ball.runAction(SKAction.moveByX(20, y: self.currentDirection.dy, duration: 0))
//                
//            }
//            
//            if self.ball.position.y > self.frame.height - 0.5 * self.ball.size.width {
//                self.currentDirection.dy *= -1
//                
//                self.ball.runAction(SKAction.moveByX(self.currentDirection.dx, y: -20, duration: 0))
//                
//            }
//            
//            if self.ball.position.y < 0.5 * self.ball.size.height {
//                self.currentDirection.dy *= -1
//                
//                
//                
//                self.ball.runAction(SKAction.moveByX(self.currentDirection.dx, y: 20, duration: 0))
//            }
//            
//        
//            let move =   SKAction.moveBy(currentDirection, duration: movespeed * timeSinceLastUpdate)
//            self.ball.runAction(move)
//        
//        
//            self.debugLabel.text = "x: \(Int(self.ball.position.x)) y: \(Int(self.ball.position.y))"
//        
//    }
}








