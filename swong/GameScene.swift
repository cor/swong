//
//  GameScene.swift
//  swong
//
//  Created by Cor Pruijs on 29-07-14.
//  Copyright (c) 2014 Cor Pruijs. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //for delta time
//    var lastUpdateTimeInterval: NSTimeInterval(NaN)
    
    let ball                                    = SKSpriteNode(imageNamed: "ball")
    let devbox                                  = SKSpriteNode(imageNamed: "devbox")
    let gamenameLabel                           = SKLabelNode(fontNamed: "Helvetica")
    let debugLabel                              = SKLabelNode(fontNamed: "Helvetica")
    let movespeed                               = 0.05
    var currentDirection                        = CGVectorMake(5, 5)
    var lastUpdateTimeInterval: CFTimeInterval  = 0
    
    enum ColliderType: UInt32 {
        case Ball = 1
        case Paddle = 2
        case Devbox = 3
        case Leveledge = 8
    }
    
    
    
    var fpsCount         = 0
    
    override func didMoveToView(view: SKView) {

        
        //SCENE (SELF)
        self.backgroundColor                = SKColor(red: 0.31, green: 0.39, blue: 0.4, alpha: 1)
        self.scaleMode                      = SKSceneScaleMode.Fill
        self.physicsWorld.gravity           = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate   = self
        self.physicsBody                    = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody.dynamic            = false
        self.physicsBody.friction           = 0
        self.physicsBody.categoryBitMask    = ColliderType.Leveledge.toRaw()
        self.physicsBody.contactTestBitMask = ColliderType.Ball.toRaw()
        
        
        // BALL
        ball.size                           = CGSizeMake(25, 25)
        ball.position                       = CGPointMake(self.frame.midX, self.frame.midY)
        ball.physicsBody                    = SKPhysicsBody(circleOfRadius: ball.size.height / 2)
        ball.physicsBody.dynamic            = true
        ball.physicsBody.allowsRotation     = false
        ball.physicsBody.linearDamping      = 0
        ball.physicsBody.velocity           = CGVectorMake(30, 0)
        ball.physicsBody.categoryBitMask    = ColliderType.Ball.toRaw()
        ball.physicsBody.contactTestBitMask = ColliderType.Leveledge.toRaw() | ColliderType.Paddle.toRaw() | ColliderType.Devbox.toRaw()
        
        self.addChild(ball)
        
        //DEVBOX
        devbox.size                         = CGSizeMake(75, 75)
        devbox.position                     = CGPointMake(self.frame.midX + 0.25 * self.frame.width, self.frame.midY)
        devbox.physicsBody                  = SKPhysicsBody(rectangleOfSize: devbox.size)
        devbox.physicsBody.dynamic          = false
        devbox.physicsBody.categoryBitMask  = ColliderType.Devbox.toRaw()
        devbox.physicsBody.contactTestBitMask = ColliderType.Ball.toRaw()
        self.addChild(devbox)
        
        
        //NAME LABEL
        gamenameLabel.text                  = "Swong"
        gamenameLabel.fontSize              = 30
        gamenameLabel.position              = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        gamenameLabel.zPosition             = -10
        self.addChild(gamenameLabel)
        
        // DEBUG LABEL
        debugLabel.text                 = "x: \(ball.position.x), y: \(ball.position.y)"
        debugLabel.fontSize             = 20
        debugLabel.position             = CGPoint(x:CGRectGetMidX(self.frame), y:(CGRectGetMidY(self.frame) - 25 ))
        debugLabel.zPosition            = -10
        self.addChild(debugLabel)
        
        println("SELF.FRAME H:\(self.frame.height), W: \(self.frame.width)")
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
       
        for touch: AnyObject in touches {
//            
//            let moveVector = CGVectorMake(20, 0)
//            let moveAction = SKAction.moveBy(moveVector, duration: 2)
////            ball.
//            ball.runAction(moveAction)
            
////            teleport ball to tap location:
//            self.ball.runAction(SKAction.moveTo(touch.locationInNode(self), duration: movespeed))
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        
        for touch: AnyObject in touches {
            let taplocation = touch.locationInNode(self)
            self.ball.runAction(SKAction.moveTo(taplocation, duration: movespeed))
        }
    }
   

    func didBeginContact(contact: SKPhysicsContact!)  {
        println("contact!")
        
        println(contact.description)
    }
    
    override func update(currentTime: CFTimeInterval) {
        self.debugLabel.text = "x: \(Int(self.ball.position.x)) y: \(Int(self.ball.position.y))"

    }
    

}