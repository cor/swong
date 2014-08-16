//
//  GameScene.swift
//  swong
//
//  Created by Cor Pruijs on 29-07-14.
//  Copyright (c) 2014 Cor Pruijs. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    let ball                                        = SKSpriteNode(imageNamed: "ball")
    let devbox                                      = SKSpriteNode(imageNamed: "devbox")
    
    let paddle1                                     = SKSpriteNode(imageNamed: "paddle1")
    let paddle2                                     = SKSpriteNode(imageNamed: "paddle2")
    
    let wall1                                       = SKSpriteNode(color: SKColor.clearColor(), size: CGSize(width: 2, height: 768))
    let wall2                                       = SKSpriteNode(color: SKColor.clearColor(), size: CGSize(width: 2, height: 768))
    
    let background                                  = SKSpriteNode(imageNamed: "smallBackground")
    
    let paddle1scoreLabel                           = SKLabelNode(fontNamed: "Helvetica")
    let paddle2scoreLabel                           = SKLabelNode(fontNamed: "Helvetica")
    
    let debugLabelPosition                          = SKLabelNode(fontNamed: "Helvetica")
    let debugLabelVelocity                          = SKLabelNode(fontNamed: "Helvetica")
    let debugLabelOther                             = SKLabelNode(fontNamed: "Helvetica")
    let debugLabelRunning                           = SKLabelNode(fontNamed: "Helvetica")
    let debugLabelsEnabled                          = true

    let gameEndLabel1                               = SKLabelNode(fontNamed: "Helvetica")
    let gameEndLabel2                               = SKLabelNode(fontNamed: "Helvetica")
    
    let minimumMovespeed: CGFloat                   = 300.0
    let movespeedMultiplier: CGFloat                = 1.1
    let movespeed: CGFloat                          = 500.0
    let verticalMoveSpeedAtStart: CGFloat           = 300.0
    
    let textColor                                   = UIColor(red: 0.4823529412, green: 0.4588235294, blue: 0.9254901961, alpha: 1) // Purple
    
    let wallbounceAcceleration                      = 40
    let waitduration                                = NSTimeInterval(3)
    var waitAction: SKAction                        = SKAction()
    
    
    var paddle1score                                = 0
    var paddle2score                                = 0
    
    var paddleHitCount                              = 0
    var previousBallHitTimestamp: NSTimeInterval?
    
    var gameIsRunning                               = true
    
    // Enumeration for categorybitmasks
    enum ColliderType: UInt32 {
        case Ball = 1
        case Paddle = 2
        case Devbox = 3
        case Leveledge = 8
        
        case Wall1 = 10
        case Wall2 = 12
    }
    
    
    //All configuration is done here (physics, colors, sizes etc)
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
        ball.physicsBody.velocity                       = CGVectorMake(CGFloat(movespeed), CGFloat(verticalMoveSpeedAtStart))
        ball.physicsBody.dynamic                        = true
        ball.physicsBody.allowsRotation                 = false
        ball.physicsBody.linearDamping                  = 0
        ball.physicsBody.categoryBitMask                = ColliderType.Ball.toRaw()
        ball.physicsBody.contactTestBitMask             = ColliderType.Leveledge.toRaw() | ColliderType.Paddle.toRaw() | ColliderType.Devbox.toRaw() | ColliderType.Wall1.toRaw() | ColliderType.Wall2.toRaw()
        self.addChild(ball)
        

        //PADDLE 1
        paddle1.size                                    = CGSizeMake(32, 150)
        paddle1.position                                = CGPointMake((self.frame.width - paddle1.size.width), self.frame.midY)
        paddle1.physicsBody                             = SKPhysicsBody(rectangleOfSize: paddle1.size)
        paddle1.physicsBody.dynamic                     = true
        paddle1.physicsBody.allowsRotation              = false
        paddle1.physicsBody.linearDamping               = 0
        paddle1.physicsBody.restitution                 = 1
        paddle1.physicsBody.friction                    = 0
        paddle1.physicsBody.mass                        = 10000000000
        paddle1.physicsBody.categoryBitMask             = ColliderType.Paddle.toRaw()
        paddle1.physicsBody.contactTestBitMask          = ColliderType.Ball.toRaw()
        self.addChild(paddle1)
        
        //PADDLE 2
        paddle2.size                                    = CGSizeMake(32, 150)
        paddle2.position                                = CGPointMake(paddle2.size.width, self.frame.midY)
        paddle2.physicsBody                             = SKPhysicsBody(rectangleOfSize: paddle2.size)
        paddle2.physicsBody.dynamic                     = true
        paddle2.physicsBody.allowsRotation              = false
        paddle2.physicsBody.linearDamping               = 0
        paddle2.physicsBody.restitution                 = 1
        paddle2.physicsBody.friction                    = 0
        paddle2.physicsBody.mass                        = 10000000000
        paddle2.physicsBody.categoryBitMask             = ColliderType.Paddle.toRaw()
        paddle2.physicsBody.contactTestBitMask          = ColliderType.Ball.toRaw()
        self.addChild(paddle2)

        
        //BACKGROUND
        background.position                             = CGPointMake(self.frame.midX, self.frame.midY)
        background.zPosition                            = -100
        background.size                                 = self.size
        self.addChild(background)
        
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
        paddle1scoreLabel.fontSize                      = 45
        paddle1scoreLabel.position                      = CGPointMake(self.frame.midX + 66, self.frame.height - 50)
        paddle1scoreLabel.zPosition                     = -10
        paddle1scoreLabel.fontColor                     = textColor
        self.addChild(paddle1scoreLabel)
        
        // PADDLE 2 SCORE LABEL
        paddle2scoreLabel.text                          = "\(self.paddle2score)"
        paddle2scoreLabel.fontSize                      = 45
        paddle2scoreLabel.position                      = CGPoint(x: self.frame.midX - 62, y: self.frame.height - 50)
        paddle2scoreLabel.zPosition                     = -10
        paddle2scoreLabel.fontColor                     = textColor
        self.addChild(paddle2scoreLabel)
        
        
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
        debugLabelOther.fontSize                        = 20
        debugLabelOther.position                        = CGPoint(x: 0, y: 42)
        debugLabelOther.horizontalAlignmentMode         = SKLabelHorizontalAlignmentMode.Left
        debugLabelOther.verticalAlignmentMode           = SKLabelVerticalAlignmentMode.Bottom
        debugLabelOther.zPosition                       = -10
        self.addChild(debugLabelOther)
        
        
        //DEBUG LABEL RUNNING
        debugLabelRunning.fontSize                      = 20
        debugLabelRunning.position                      = CGPoint(x: 0, y: 60)
        debugLabelRunning.horizontalAlignmentMode       = SKLabelHorizontalAlignmentMode.Left
        debugLabelRunning.verticalAlignmentMode         = SKLabelVerticalAlignmentMode.Bottom
        debugLabelRunning.zPosition                     = -10
        self.addChild(debugLabelRunning)

    }
    
    //Move paddles when user begins touch
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
    
    //Move paddles when user moves touch
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        
        for touch: AnyObject in touches {
            if touch.locationInNode(self).x > self.frame.midX {
                paddle1.position.y = touch.locationInNode(self).y
            } else if touch.locationInNode(self).x < self.frame.midX {
                paddle2.position.y = touch.locationInNode(self).y
            }

        }
    }
   
    
    func didBeginContact(contact: SKPhysicsContact!)  {
        
        //Increase horizontal speed when ball hits paddle
        if contact.bodyA.categoryBitMask == ColliderType.Paddle.toRaw() && contact.bodyB.categoryBitMask == ColliderType.Ball.toRaw() {
            
            ++paddleHitCount
            ball.physicsBody.velocity.dx *= movespeedMultiplier

        }
        
        //Increase paddle2 score when ball hits wall1
        if contact.bodyA.categoryBitMask == ColliderType.Wall1.toRaw() && contact.bodyB.categoryBitMask == ColliderType.Ball.toRaw() {
            
            paddle2score++
            paddle2scoreLabel.text = "\(paddle2score)"
            resetBall()

        }
        
        //Increase paddle1 score when ball hits wall2
        if contact.bodyA.categoryBitMask == ColliderType.Wall2.toRaw() && contact.bodyB.categoryBitMask == ColliderType.Ball.toRaw() {
            
            paddle1score++
            paddle1scoreLabel.text = "\(paddle1score)"
            resetBall()
            
        }
        
        // Increase ball.velocity.dx on wallbounce
        if contact.bodyA.categoryBitMask == ColliderType.Leveledge.toRaw() && contact.bodyB.categoryBitMask == ColliderType.Ball.toRaw() {
            
            if ball.position.y > self.frame.midY {
                ball.physicsBody.velocity.dy -= CGFloat(wallbounceAcceleration)
            } else if ball.position.y < self.frame.midY {
                ball.physicsBody.velocity.dy += CGFloat(wallbounceAcceleration)
            }
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        // Update debug labels
        
        if debugLabelsEnabled {
            debugLabelPosition.text = "POSITION x: \(Int(ball.position.x)) y: \(Int(ball.position.y))"
            debugLabelVelocity.text = "VELOCITY dx: \(Int(ball.physicsBody.velocity.dx)) dy: \(Int(ball.physicsBody.velocity.dy))"
            debugLabelOther.text    = "PADDLEHITCOUNT: \(paddleHitCount)"
            debugLabelRunning.text  = "RUNNING: \(gameIsRunning)"
        } else  {
            debugLabelPosition.text = ""
            debugLabelVelocity.text = ""
            debugLabelOther.text    = ""
            debugLabelRunning.text  = ""
        }
        
        // If the ball is moving too slow, increase speed
        if !((ball.physicsBody.velocity.dx > minimumMovespeed) || (ball.physicsBody.velocity.dx < -minimumMovespeed)) {
            println()
            println("ball moving too slow ( \(Int(ball.physicsBody.velocity.dx)) ), increasing speed")
            ball.physicsBody.velocity.dx *= 1.5
            println("New speed: \(Int(ball.physicsBody.velocity.dx))")
        }
        
        
        if paddle1score >= 7 {
            gameDidEnd(winner:1)
        } else if paddle2score >= 7 {
            gameDidEnd(winner: 2)
        }

    }
    
    func gameDidEnd(#winner: Int) {
        
        if gameIsRunning {
            gameIsRunning = false
            ball.removeFromParent()
            
            gameEndLabel1.fontSize                          = 60
            gameEndLabel1.position                          = CGPoint(x: self.frame.size.width * 0.75, y: self.frame.midY)
            gameEndLabel1.zPosition                         = 300
            gameEndLabel1.text                              = (winner == 1 ? "You win!" : "You lose...")
            self.addChild(gameEndLabel1)
            gameEndLabel1.runAction(SKAction.rotateToAngle(CGFloat(M_PI / 2.0), duration: 1))

            
            
            gameEndLabel2.fontSize                          = 60
            gameEndLabel2.position                          = CGPoint(x: self.frame.size.width * 0.25, y: self.frame.midY)
            gameEndLabel2.zPosition                         = 300
            gameEndLabel2.text                              = (winner == 2 ? "You win!" : "You lose...")
            self.addChild(gameEndLabel2)
            gameEndLabel2.runAction(SKAction.rotateToAngle(CGFloat(M_PI / -2.0), duration: 1))
        }


    }
    
    func resetBall() {
        
        //run reset action
        ball.runAction(SKAction.moveTo(CGPointMake(self.frame.midX, self.frame.midY), duration: 1))
        paddleHitCount = 0
        
        
        // taking turns on getting the ball first
        if ( paddle1score + paddle2score ) % 2 == 0 {
            ball.physicsBody.velocity.dx = CGFloat(movespeed * -1)
        } else {
            ball.physicsBody.velocity.dx = CGFloat(movespeed)
        }
        
        ball.physicsBody.velocity.dy = CGFloat(verticalMoveSpeedAtStart)
    }
}