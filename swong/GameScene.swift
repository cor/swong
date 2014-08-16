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
    
    let paddle1                                 = SKSpriteNode(imageNamed: "paddle")
    let paddle2                                 = SKSpriteNode(imageNamed: "paddle")
//    let paddle1                                 = SKShapeNode()
//    let paddle2                                 = SKShapeNode()
    
    
    let wall1                                   = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: 2, height: 768))
    let wall2                                   = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: 2, height: 768))
    
    let paddle1scoreLabel                       = SKLabelNode(fontNamed: "Helvetica")
    let paddle2scoreLabel                       = SKLabelNode(fontNamed: "Helvetica")
    let gamenameLabel                           = SKLabelNode(fontNamed: "Helvetica")
    let debugLabelPosition                      = SKLabelNode(fontNamed: "Helvetica")
    let debugLabelVelocity                      = SKLabelNode(fontNamed: "Helvetica")
    let debugLabelOther                         = SKLabelNode(fontNamed: "Helvetica")
    
    let movespeed: CGFloat                      = 500.0
    let movespeedMultiplier: CGFloat            = 30.0
    let verticalMoveSpeedAtStart: CGFloat       = 300.0
    
    let wallbounceAcceleration                  = 40
    let waitduration                            = NSTimeInterval(3)
    var waitAction: SKAction                    = SKAction()
    
    var paddle1score                            = 0
    var paddle2score                            = 0
    var paddleHitCount                          = 0
    var ballIsResetting                         = false
    var previousBallHitTimestamp: NSTimeInterval?
    
    var now: NSTimeInterval!
    
    
    enum ColliderType: UInt32 {
        case Ball = 1
        case Paddle = 2
        case Devbox = 3
        case Leveledge = 8
        
        case Wall1 = 10
        case Wall2 = 12
    }
    
    
    
    var fpsCount         = 0
    
    override func didMoveToView(view: SKView) {

        
        //SCENE (SELF)
        self.backgroundColor                            = SKColor(red: 0.31, green: 0.3, blue: 0.5, alpha: 1)
        self.scaleMode                                  = SKSceneScaleMode.Fill
        self.physicsWorld.gravity                       = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate               = self
        self.physicsBody                                = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody.dynamic                        = false
        self.physicsBody.friction                       = 0
        self.physicsBody.restitution                    = 1
        self.physicsBody.categoryBitMask                = ColliderType.Leveledge.toRaw()
        self.physicsBody.contactTestBitMask             = ColliderType.Ball.toRaw()
        
        
        // BALL
        ball.size                                       = CGSizeMake(50, 50)
        ball.position                                   = CGPointMake(self.frame.midX, self.frame.midY)
        ball.physicsBody                                = SKPhysicsBody(circleOfRadius: ball.size.height / 2)
        ball.physicsBody.dynamic                        = true
        ball.physicsBody.allowsRotation                 = true
        ball.physicsBody.linearDamping                  = 0
        ball.physicsBody.categoryBitMask                = ColliderType.Ball.toRaw()
        ball.physicsBody.contactTestBitMask             = ColliderType.Leveledge.toRaw() | ColliderType.Paddle.toRaw() | ColliderType.Devbox.toRaw() | ColliderType.Wall1.toRaw() | ColliderType.Wall2.toRaw()
        self.addChild(ball)
        

        // OLD PADDLES
        //PADDLE 1
        paddle1.size                                    = CGSizeMake(50, 150)
        paddle1.position                                = CGPointMake((self.frame.width - paddle1.size.width), self.frame.midY)
        paddle1.physicsBody                             = SKPhysicsBody(rectangleOfSize: paddle1.size)
        paddle1.physicsBody.dynamic                     = true
        paddle1.physicsBody.allowsRotation              = false
        paddle1.physicsBody.linearDamping               = 0
        paddle1.physicsBody.restitution                 = 1
        paddle1.physicsBody.mass                        = 10000000000
        paddle1.physicsBody.categoryBitMask             = ColliderType.Paddle.toRaw()
        paddle1.physicsBody.contactTestBitMask          = ColliderType.Ball.toRaw()
        self.addChild(paddle1)
        
        //PADDLE 2
        paddle2.size                                    = CGSizeMake(50, 150)
        paddle2.position                                = CGPointMake(paddle2.size.width, self.frame.midY)
        paddle2.physicsBody                             = SKPhysicsBody(rectangleOfSize: paddle2.size)
        paddle2.physicsBody.dynamic                     = true
        paddle2.physicsBody.allowsRotation              = false
        paddle2.physicsBody.linearDamping               = 0
        paddle2.physicsBody.restitution                 = 1
        paddle2.physicsBody.mass                        = 10000000000
        paddle2.physicsBody.categoryBitMask             = ColliderType.Paddle.toRaw()
        paddle2.physicsBody.contactTestBitMask          = ColliderType.Ball.toRaw()
        self.addChild(paddle2)

        //WALL 1 
        wall1.position                                  = CGPointMake(self.frame.width - (0.5 * wall2.size.width), self.frame.midY)
        wall1.physicsBody                               = SKPhysicsBody(rectangleOfSize: wall1.size)
        wall1.physicsBody.dynamic                       = false
        wall1.physicsBody.categoryBitMask               = ColliderType.Wall1.toRaw()
        self.addChild(wall1)
        
        //WALL 2
        wall2.position                                  = CGPointMake(0.5 * wall1.size.width, self.frame.midY)
        wall2.physicsBody                               = SKPhysicsBody(rectangleOfSize: wall2.size)
        wall2.physicsBody.dynamic                       = false
        wall2.physicsBody.categoryBitMask               = ColliderType.Wall2.toRaw()
        self.addChild(wall2)
        
        // PADDLE 1 SCORE LABEL
        paddle1scoreLabel.text                          = "\(self.paddle1score)"
        paddle1scoreLabel.fontSize                      = 60
        paddle1scoreLabel.position                      = CGPointMake(self.frame.midX + 100, self.frame.height - 100)
        paddle1scoreLabel.zPosition                     = -10
        self.addChild(paddle1scoreLabel)
        
        // PADDLE 2 SCORE LABEL
        paddle2scoreLabel.text                          = "\(self.paddle2score)"
        paddle2scoreLabel.fontSize                      = 60
        paddle2scoreLabel.position                      = CGPointMake(self.frame.midX - 100, self.frame.height - 100)
        paddle2scoreLabel.zPosition                     = -10
        self.addChild(paddle2scoreLabel)
        
        //NAME LABEL
        gamenameLabel.text                              = "Swong"
        gamenameLabel.fontSize                          = 60
        gamenameLabel.position                          = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        gamenameLabel.zPosition                         = -10
        self.addChild(gamenameLabel)
        
        //DEBUG LABEL POSITION
        debugLabelPosition.text                         = "POSITION x: \(Int(ball.position.x)) y: \(Int(ball.position.y))"
        debugLabelPosition.fontSize                     = 20
        debugLabelPosition.position                     = CGPoint(x: 0, y: 0)
        debugLabelPosition.horizontalAlignmentMode      = SKLabelHorizontalAlignmentMode.Left
        debugLabelPosition.verticalAlignmentMode        = SKLabelVerticalAlignmentMode.Bottom
        debugLabelPosition.zPosition                    = -10
        self.addChild(debugLabelPosition)
        
        //DEBUG LABEL VELOCITY
        debugLabelVelocity.text                         = "VELOCITY dx: \(Int(ball.physicsBody.velocity.dx)) dy: \(Int(ball.physicsBody.velocity.dy))"
        debugLabelVelocity.fontSize                     = 20
        debugLabelVelocity.position                     = CGPoint(x: 0, y: 20)
        debugLabelVelocity.horizontalAlignmentMode      = SKLabelHorizontalAlignmentMode.Left
        debugLabelVelocity.verticalAlignmentMode        = SKLabelVerticalAlignmentMode.Bottom
        debugLabelVelocity.zPosition                    = -10
        self.addChild(debugLabelVelocity)
        
        //DEBUG LABEL OTHER
        debugLabelOther.text                            = "RESETTING: \(self.ballIsResetting)"
        debugLabelOther.fontSize                        = 20
        debugLabelOther.position                        = CGPoint(x: 0, y: 42)
        debugLabelOther.horizontalAlignmentMode         = SKLabelHorizontalAlignmentMode.Left
        debugLabelOther.verticalAlignmentMode           = SKLabelVerticalAlignmentMode.Bottom
        debugLabelOther.zPosition                       = -10
        self.addChild(debugLabelOther)
        
        
        // RESET ANIMATION
        let wait1 = SKAction.moveTo(CGPointMake(self.frame.midX, self.frame.height - self.ball.size.height), duration: self.waitduration / 3)
        let wait2 = SKAction.moveTo(CGPointMake(self.frame.midX, self.ball.size.height), duration: self.waitduration / 3)
        let wait3 = SKAction.moveTo(CGPointMake(self.frame.midX, self.frame.midY), duration: self.waitduration / 3)
    
        
        self.waitAction = SKAction.sequence([wait1, wait2, wait3])
        
        ball.runAction(self.waitAction)
        ball.physicsBody.velocity                       = CGVectorMake(CGFloat(movespeed), CGFloat(verticalMoveSpeedAtStart))

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
       
        for touch: AnyObject in touches {

            if touch.locationInNode(self).x > self.frame.midX {
                paddle1.position.y = touch.locationInNode(self).y
            } else if touch.locationInNode(self).x < self.frame.midX {
                paddle2.position.y = touch.locationInNode(self).y
            }

        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        
        for touch: AnyObject in touches {
            if touch.locationInNode(self).x > self.frame.midX {
                paddle1.position.y = touch.locationInNode(self).y
            } else if touch.locationInNode(self).x < self.frame.midX {
                paddle2.position.y = touch.locationInNode(self).y
            }

        }
    }
   

    func ballPositionRelativeToPaddle(paddle: Int) -> CGFloat {
        assert(paddle == 1 || paddle == 2, "Invalid paddle parameter at ballPositionRelativeToPaddle()")

        switch paddle {
        case 1:
            return ball.position.x - paddle1.position.x
            
        case 2:
            return ball.position.x - paddle2.position.x
        
        default:
            println("this never happens because of the assert statement above")
            return 0
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact!)  {
        
        if contact.bodyA.categoryBitMask == ColliderType.Paddle.toRaw() && contact.bodyB.categoryBitMask == ColliderType.Ball.toRaw() {
            
            ballIsResetting = false
            ++paddleHitCount
            ball.physicsBody.velocity.dx *= 1.1

        }
        
        if contact.bodyA.categoryBitMask == ColliderType.Wall1.toRaw() && contact.bodyB.categoryBitMask == ColliderType.Ball.toRaw() && !ballIsResetting {
            ballIsResetting = true
            paddle2score++
            paddle2scoreLabel.text = "\(self.paddle2score)"
            resetBall()

        }
        
        if contact.bodyA.categoryBitMask == ColliderType.Wall2.toRaw() && contact.bodyB.categoryBitMask == ColliderType.Ball.toRaw() && !ballIsResetting {
            ballIsResetting = true
            paddle1score++
            paddle1scoreLabel.text = "\(self.paddle1score)"
            resetBall()
        }
        
        if contact.bodyA.categoryBitMask == ColliderType.Leveledge.toRaw() && contact.bodyB.categoryBitMask == ColliderType.Ball.toRaw() {
            if ball.position.y > self.frame.midY {
                ball.physicsBody.velocity.dy -= CGFloat(wallbounceAcceleration)
            } else if ball.position.y < self.frame.midY {
                ball.physicsBody.velocity.dy += CGFloat(wallbounceAcceleration)
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        debugLabelPosition.text = "POSITION x: \(Int(ball.position.x)) y: \(Int(ball.position.y))"
        debugLabelVelocity.text = "VELOCITY dx: \(Int(ball.physicsBody.velocity.dx)) dy: \(Int(ball.physicsBody.velocity.dy))"
        debugLabelOther.text    = "RESETTING: \(self.ballIsResetting) PADDLEHITCOUNT: \(self.paddleHitCount)"
        
        now = currentTime
        

    }
    
    func resetBall() {
        self.ball.position = CGPointMake(self.frame.midX, self.frame.midY)
        self.paddleHitCount = 0
    
        self.ball.physicsBody.velocity.dx = 0
        self.ball.physicsBody.velocity.dy = 0
        
        ball.runAction(self.waitAction)
        
        if ( self.paddle1score + self.paddle2score ) % 2 == 0 {
            self.ball.physicsBody.velocity.dx = CGFloat(self.movespeed * -1)
        } else {
            self.ball.physicsBody.velocity.dx = CGFloat(self.movespeed)
        }
        self.ball.physicsBody.velocity.dy = CGFloat(self.verticalMoveSpeedAtStart)
    }
}