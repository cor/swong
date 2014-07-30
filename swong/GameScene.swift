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
    
    let ball             = SKSpriteNode(imageNamed: "ball")
    let gamenameLabel    = SKLabelNode(fontNamed: "Helvetica")
    let debugLabel       = SKLabelNode(fontNamed: "Helvetica")
    let movespeed        = 0.05
    var currentDirection = CGVectorMake(5, 5)

    
    override func didMoveToView(view: SKView) {

        self.backgroundColor = SKColor(red: 0.31, green: 0.39, blue: 0.4, alpha: 1)

        //NAME LABEL
        gamenameLabel.text = "Swong"
        gamenameLabel.fontSize = 65
        gamenameLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        gamenameLabel.zPosition = -10
        self.addChild(gamenameLabel)
        
        // BALL
        ball.size = CGSizeMake(50, 50)
        ball.position = CGPointMake(self.frame.midX, self.frame.midY)
        self.addChild(ball)
        
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

            println("TOUCH  x: \(taplocation.x) y: \(taplocation.y)")
            
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        
        for touch: AnyObject in touches {
            let taplocation = touch.locationInNode(self)
            self.ball.runAction(SKAction.moveTo(taplocation, duration: movespeed))
            println("CHANGE x: \(taplocation.x) y: \(taplocation.y)")

        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

        
        //bouncing effect at walls
        if self.ball.position.x > self.frame.width - 0.5 * self.ball.size.width {
            self.currentDirection.dx = self.currentDirection.dx * -1
            
            // to prevent it from getting "stuck" in the wall
            self.ball.runAction(SKAction.moveByX(-20, y: self.currentDirection.dy, duration: 0))
        }
        
        if self.ball.position.x < 0.5 * self.ball.size.width {
            self.currentDirection.dx = self.currentDirection.dx * -1
            
            self.ball.runAction(SKAction.moveByX(20, y: self.currentDirection.dy, duration: 0))
        }
        
        if self.ball.position.y > self.frame.height - 0.5 * self.ball.size.width {
            self.currentDirection.dy = self.currentDirection.dy * -1
            
            self.ball.runAction(SKAction.moveByX(self.currentDirection.dx, y: -20, duration: 0))
        }
        
        if self.ball.position.y < 0.5 * self.ball.size.height {
            self.currentDirection.dy = self.currentDirection.dy * -1
            
            self.ball.runAction(SKAction.moveByX(self.currentDirection.dx, y: 20, duration: 0))
        }
        
        
        let move =   SKAction.moveBy(currentDirection, duration: movespeed)
        
        self.ball.runAction(move)
        self.debugLabel.text = "x: \(Int(self.ball.position.x)) y: \(Int(self.ball.position.y))"

        
    }
}
