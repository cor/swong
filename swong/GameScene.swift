//
//  GameScene.swift
//  swong
//
//  Created by Cor Pruijs on 29-07-14.
//  Copyright (c) 2014 Cor Pruijs. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // important gameplay objects
    let ball                                        = SKSpriteNode(imageNamed: "ball")
    let paddle1                                     = SKSpriteNode(imageNamed: "paddle1")
    let paddle2                                     = SKSpriteNode(imageNamed: "paddle2")
    
    let wall1                                       = SKSpriteNode(color: SKColor.clearColor(), size: CGSize(width: 2, height: 768))
    let wall2                                       = SKSpriteNode(color: SKColor.clearColor(), size: CGSize(width: 2, height: 768))
    
    // aesthetics
    let background                                  = SKSpriteNode(imageNamed: "background")
    let textColor                                   = UIColor(red: 0.4823529412, green: 0.4588235294, blue: 0.9254901961, alpha: 1) // Purple
    
    // score labels
    let paddle1scoreLabel                           = SKLabelNode(fontNamed: "Futura")
    let paddle2scoreLabel                           = SKLabelNode(fontNamed: "Futura")
    
    let gameEndLabel1                               = SKLabelNode(fontNamed: "Futura")
    let gameEndLabel2                               = SKLabelNode(fontNamed: "Futura")
   
    // "menu" labels
    let playLabel                                   = SKLabelNode(fontNamed: "Futura")
    let againLabel                                  = SKLabelNode(fontNamed: "Futura")
    
    // debug labels
    let debugLabelPosition                          = SKLabelNode(fontNamed: "Futura")
    let debugLabelVelocity                          = SKLabelNode(fontNamed: "Futura")
    let debugLabelOther                             = SKLabelNode(fontNamed: "Futura")
    let debugLabelRunning                           = SKLabelNode(fontNamed: "Futura")
    let debugLabelsAreEnabled                       = false
    
    // speeds
    let minimumHorizontalVelocity: CGFloat          = 300.0
    let minimumVerticalVelocity: CGFloat            = 100.0
    let horizontalVelocityMultiplier: CGFloat       = 1.05
    let verticalVelocityMultiplier: CGFloat         = 1.05
    let horizontalTooSlowMultiplier: CGFloat        = 1.5
    let verticalTooSlowMultiplier: CGFloat          = 1.5
    let possibleStartDy: [CGFloat]                  = [500, 400, 300, -300, -400, -500]
    let possibleStartDx: [CGFloat]                  = [500, 550, 600, 650, 700]
    
    let paddleDistanceFromSide: CGFloat             = 50
    let pointsNeededToWin                           = 7
    
    // values the game uses to keep track of things
    var gameIsRunning                               = false
    var ballIsResetting                             = true
    var paddle1score                                = 0
    var paddle2score                                = 0
    var paddleHitCount                              = 0
    
    // Enumeration for categorybitmasks (contact & collisions)
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
        
        println("LOG | Game booting up")
        
        // SCENE (SELF)
        self.backgroundColor                            = SKColor(red: 0.31, green: 0.3, blue: 0.5, alpha: 1)
        self.scaleMode                                  = SKSceneScaleMode.Fill
        self.physicsWorld.gravity                       = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate               = self
        self.physicsBody                                = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody!.dynamic                        = false
        self.physicsBody!.friction                       = 0
        self.physicsBody!.restitution                    = 1
        self.physicsBody!.categoryBitMask                = ColliderType.Leveledge.rawValue
        self.physicsBody!.contactTestBitMask             = ColliderType.Ball.rawValue
        
        // BALL
        ball.size                                       = CGSizeMake(45, 45)
        ball.position                                   = CGPointMake(self.frame.midX, self.frame.midY)
        ball.physicsBody                                = SKPhysicsBody(circleOfRadius: ball.size.height / 2)
        ball.physicsBody!.velocity                       = newBallVector(forPlayer: 1)
        ball.physicsBody!.dynamic                        = true
        ball.physicsBody!.allowsRotation                 = true
        ball.physicsBody!.linearDamping                  = 0
        ball.physicsBody!.categoryBitMask                = ColliderType.Ball.rawValue
        ball.physicsBody!.contactTestBitMask             = ColliderType.Leveledge.rawValue | ColliderType.Paddle.rawValue | ColliderType.Devbox.rawValue | ColliderType.Wall1.rawValue | ColliderType.Wall2.rawValue
        ball.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(1, duration: 0.25)))
        
        // BACKGROUND
        background.position                             = CGPointMake(self.frame.midX, self.frame.midY)
        background.zPosition                            = -100
        background.size                                 = self.size
        self.addChild(background)
        
        // PADDLE 1
        paddle1.size                                    = CGSizeMake(32, 150)
        paddle1.position                                = CGPoint(x: self.frame.width - paddleDistanceFromSide, y: self.frame.midY)
        paddle1.physicsBody                             = SKPhysicsBody(rectangleOfSize: paddle1.size)
        paddle1.physicsBody!.dynamic                     = true
        paddle1.physicsBody!.allowsRotation              = false
        paddle1.physicsBody!.linearDamping               = 0
        paddle1.physicsBody!.restitution                 = 1
        paddle1.physicsBody!.friction                    = 0
        paddle1.physicsBody!.mass                        = 10000000000
        paddle1.physicsBody!.categoryBitMask             = ColliderType.Paddle.rawValue
        paddle1.physicsBody!.contactTestBitMask          = ColliderType.Ball.rawValue
        self.addChild(paddle1)
        
        // PADDLE 2
        paddle2.size                                    = CGSizeMake(32, 150)
        paddle2.position                                = CGPoint(x: paddleDistanceFromSide, y: self.frame.midY)
        paddle2.physicsBody                             = SKPhysicsBody(rectangleOfSize: paddle2.size)
        paddle2.physicsBody!.dynamic                     = true
        paddle2.physicsBody!.allowsRotation              = false
        paddle2.physicsBody!.linearDamping               = 0
        paddle2.physicsBody!.restitution                 = 1
        paddle2.physicsBody!.friction                    = 0
        paddle2.physicsBody!.mass                        = 10000000000
        paddle2.physicsBody!.categoryBitMask             = ColliderType.Paddle.rawValue
        paddle2.physicsBody!.contactTestBitMask          = ColliderType.Ball.rawValue
        self.addChild(paddle2)
        
        // WALL 1
        wall1.position                                  = CGPointMake(self.frame.width - (0.5 * wall2.size.width), self.frame.midY)
        wall1.physicsBody                               = SKPhysicsBody(rectangleOfSize: wall1.size)
        wall1.physicsBody!.dynamic                       = false
        wall1.physicsBody!.categoryBitMask               = ColliderType.Wall1.rawValue
        self.addChild(wall1)
        
        // WALL 2
        wall2.position                                  = CGPointMake(0.5 * wall1.size.width, self.frame.midY)
        wall2.physicsBody                               = SKPhysicsBody(rectangleOfSize: wall2.size)
        wall2.physicsBody!.dynamic                       = false
        wall2.physicsBody!.categoryBitMask               = ColliderType.Wall2.rawValue
        self.addChild(wall2)
        
        // PADDLE 1 SCORE LABEL
        paddle1scoreLabel.text                          = "\(self.paddle1score)"
        paddle1scoreLabel.fontSize                      = 45
        paddle1scoreLabel.position                      = CGPointMake(self.frame.midX + 75, self.frame.height - 50)
        paddle1scoreLabel.horizontalAlignmentMode       = SKLabelHorizontalAlignmentMode.Center
        paddle1scoreLabel.zPosition                     = -10
        paddle1scoreLabel.fontColor                     = textColor
        self.addChild(paddle1scoreLabel)
        
        // PADDLE 2 SCORE LABEL
        paddle2scoreLabel.text                          = "\(self.paddle2score)"
        paddle2scoreLabel.fontSize                      = 45
        paddle2scoreLabel.position                      = CGPoint(x: self.frame.midX - 75, y: self.frame.height - 50)
        paddle2scoreLabel.horizontalAlignmentMode       = SKLabelHorizontalAlignmentMode.Center
        paddle2scoreLabel.zPosition                     = -10
        paddle2scoreLabel.fontColor                     = textColor
        self.addChild(paddle2scoreLabel)
        
        // PLAY LABEL
        playLabel.text                                  = "Play"
        playLabel.alpha                                 = 0
        playLabel.fontSize                              = 60
        playLabel.fontColor                             = textColor
        playLabel.position                              = CGPoint(x: self.frame.midX, y: self.frame.midY - 120)
        playLabel.verticalAlignmentMode                 = SKLabelVerticalAlignmentMode.Center
        playLabel.horizontalAlignmentMode               = SKLabelHorizontalAlignmentMode.Right
        playLabel.zPosition                             = -10
        playLabel.runAction(SKAction.rotateToAngle(CGFloat(M_PI / 2.0), duration: 0))
        self.addChild(playLabel)
        playLabel.runAction(SKAction.fadeInWithDuration(3))
        
        // AGAIN LABEL
        againLabel.text                                 = "again?"
        againLabel.alpha                                = 0
        againLabel.fontSize                             = 60
        againLabel.fontColor                            = textColor
        againLabel.position                             = CGPoint(x:self.frame.midX, y: self.frame.midY + 110)
        againLabel.verticalAlignmentMode                = SKLabelVerticalAlignmentMode.Center
        againLabel.horizontalAlignmentMode              = SKLabelHorizontalAlignmentMode.Left
        againLabel.zPosition                            = -10
        againLabel.runAction(SKAction.rotateToAngle(CGFloat(M_PI / 2.0), duration: 0))
        self.addChild(againLabel)
        
        // GAME END LABEL 1
        gameEndLabel1.fontSize                          = 60
        gameEndLabel1.fontColor                         = textColor
        gameEndLabel1.alpha                             = 0
        gameEndLabel1.position                          = CGPoint(x: self.frame.size.width * 0.75, y: self.frame.midY)
        gameEndLabel1.zPosition                         = 300
        gameEndLabel1.runAction(SKAction.rotateToAngle(CGFloat(M_PI / 2.0), duration: 0))
        self.addChild(gameEndLabel1)
        
        // GAME END LABEL 2
        gameEndLabel2.fontSize                          = 60
        gameEndLabel2.fontColor                         = textColor
        gameEndLabel2.alpha                             = 0
        gameEndLabel2.position                          = CGPoint(x: self.frame.size.width * 0.25, y: self.frame.midY)
        gameEndLabel2.zPosition                         = 300
        gameEndLabel2.runAction(SKAction.rotateToAngle(CGFloat(M_PI / -2.0), duration: 0))
        self.addChild(gameEndLabel2)
        
        //DEBUG LABEL POSITION
        debugLabelPosition.text                         = "POSITION x: \(Int(ball.position.x)) y: \(Int(ball.position.y))"
        debugLabelPosition.fontSize                     = 20
        debugLabelPosition.fontColor                    = textColor
        debugLabelPosition.position                     = CGPoint(x: 2, y: 0)
        debugLabelPosition.horizontalAlignmentMode      = SKLabelHorizontalAlignmentMode.Left
        debugLabelPosition.verticalAlignmentMode        = SKLabelVerticalAlignmentMode.Bottom
        debugLabelPosition.zPosition                    = -10
        self.addChild(debugLabelPosition)
        
        //DEBUG LABEL VELOCITY
        debugLabelVelocity.text                         = "VELOCITY dx: \(Int(ball.physicsBody!.velocity.dx)) dy: \(Int(ball.physicsBody!.velocity.dy))"
        debugLabelVelocity.fontSize                     = 20
        debugLabelVelocity.fontColor                    = textColor
        debugLabelVelocity.position                     = CGPoint(x: 2, y: 20)
        debugLabelVelocity.horizontalAlignmentMode      = SKLabelHorizontalAlignmentMode.Left
        debugLabelVelocity.verticalAlignmentMode        = SKLabelVerticalAlignmentMode.Bottom
        debugLabelVelocity.zPosition                    = -10
        self.addChild(debugLabelVelocity)
        
        //DEBUG LABEL OTHER
        debugLabelOther.fontSize                        = 20
        debugLabelOther.fontColor                       = textColor
        debugLabelOther.position                        = CGPoint(x: 2, y: 44)
        debugLabelOther.horizontalAlignmentMode         = SKLabelHorizontalAlignmentMode.Left
        debugLabelOther.verticalAlignmentMode           = SKLabelVerticalAlignmentMode.Bottom
        debugLabelOther.zPosition                       = -10
        self.addChild(debugLabelOther)
        
        //DEBUG LABEL RUNNING
        debugLabelRunning.fontSize                      = 20
        debugLabelRunning.fontColor                     = textColor
        debugLabelRunning.position                      = CGPoint(x: 2, y: 64)
        debugLabelRunning.horizontalAlignmentMode       = SKLabelHorizontalAlignmentMode.Left
        debugLabelRunning.verticalAlignmentMode         = SKLabelVerticalAlignmentMode.Bottom
        debugLabelRunning.zPosition                     = -10
        self.addChild(debugLabelRunning)
    }
    
    // the point.x determains wich paddle to move and the point.y determains on what height to move that paddle
    func movePaddleToPoint(point:CGPoint) {
        
        func movePaddle(paddle:Int, toY y: CGFloat) {
            if paddle == 1 {
                paddle1.position = CGPoint(x: self.frame.width - paddleDistanceFromSide, y: y)
            } else if paddle == 2 {
                paddle2.position = CGPoint(x: paddleDistanceFromSide, y: y)
            } else {
                println("ERR | Invalid parameter: paddle at movePaddle() call")
            }
        }
        
        if point.x > self.frame.midX {
            
            // prevent too high or too low paddle locations
            let maxHeight = self.frame.height - (paddle1.size.height / 2)
            let minHeight = paddle1.size.height / 2
            
            if point.y > maxHeight {
                movePaddle(1, toY: maxHeight)
            } else if point.y < minHeight {
                movePaddle(1, toY: minHeight)
            } else {
                movePaddle(1, toY: point.y)
            }
            
        } else if point.x < self.frame.midX {
            
            let maxHeight = self.frame.height - (paddle2.size.height / 2)
            let minHeight = paddle2.size.height / 2
            
            if point.y > maxHeight {
                movePaddle(2, toY: maxHeight)
            } else if point.y < minHeight {
                movePaddle(2, toY: minHeight)
            } else {
                movePaddle(2, toY: point.y)
            }
        }
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        if gameIsRunning {
            // move paddles
            for touch: AnyObject in touches {
                movePaddleToPoint(touch.locationInNode(self))
            }
        } else {
            for touch: AnyObject in touches  {
                // check if the user presses play
                if touch.locationInNode(self).x > ( self.frame.midX - 50 ) && touch.locationInNode(self).x < ( self.frame.midX + 50) {
                    println("LOG | Start Game Area pressed, starting game")
                    resetGame()
                    gameIsRunning = true
                    self.addChild(ball)
                    playLabel.runAction(SKAction.fadeOutWithDuration(1))
                    againLabel.runAction(SKAction.fadeOutWithDuration(1))
                }
            }
        }
    }
    
    //Move paddles when user moves touch
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        if gameIsRunning {
            // move paddles
            for touch: AnyObject in touches {
                movePaddleToPoint(touch.locationInNode(self))
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact!)  {
        
        //Increase horizontal speed when ball hits paddle
        if contact.bodyA.categoryBitMask == ColliderType.Paddle.rawValue && contact.bodyB.categoryBitMask == ColliderType.Ball.rawValue {
            
            if !ballIsResetting {
                print("LOG | Ball hit paddle, increasing horizontal speed: \(Int(ball.physicsBody!.velocity.dx))  --> ")
                ++paddleHitCount
                ball.physicsBody!.velocity.dx *= horizontalVelocityMultiplier
                println("new speed: \(Int(ball.physicsBody!.velocity.dx))")
            }
        }
        
        //Increase paddle2 score when ball hits wall1
        if contact.bodyA.categoryBitMask == ColliderType.Wall1.rawValue && contact.bodyB.categoryBitMask == ColliderType.Ball.rawValue {
            
            if !ballIsResetting {
                ballIsResetting = true
                println("LOG | Ball hit wall1, increasing paddle 2 score: \(paddle2score)  --> new score: \(paddle2score + 1)")
                paddle2score++
                paddle2scoreLabel.text = "\(paddle2score)"
                resetBall()
            }
        }
        
        //Increase paddle1 score when ball hits wall2
        if contact.bodyA.categoryBitMask == ColliderType.Wall2.rawValue && contact.bodyB.categoryBitMask == ColliderType.Ball.rawValue {
            if !ballIsResetting {
                ballIsResetting = true
                println("LOG | Ball hit wall2, increasing paddle 1 score: \(paddle1score) --> new score: \(paddle1score + 1)")
                paddle1score++
                paddle1scoreLabel.text = "\(paddle1score)"
                resetBall()
            }
        }
        
        // Increase ball.velocity.dx on wallbounce
        if contact.bodyA.categoryBitMask == ColliderType.Leveledge.rawValue && contact.bodyB.categoryBitMask == ColliderType.Ball.rawValue {

            if !ballIsResetting {
                print("LOG | Ball hit Leveledge, increasing vertical speed: \(Int(ball.physicsBody!.velocity.dy)) ")
               
                if ball.position.y > self.frame.midY {
                    ball.physicsBody!.velocity.dy *= verticalVelocityMultiplier
                } else if ball.position.y < self.frame.midY {
                    ball.physicsBody!.velocity.dy *= verticalVelocityMultiplier
                }
                
                println("--> new speed: \(Int(ball.physicsBody!.velocity.dy))")
            }
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {

        // If a player has enough points, end the game.
        if paddle1score >= pointsNeededToWin && gameIsRunning {
            println("LOG | paddle1score is \(paddle1score), he wins the game")
            gameDidEnd(winner:1)
        } else if paddle2score >= pointsNeededToWin && gameIsRunning {
            gameDidEnd(winner: 2)
        }
        
        // If the ball is not resetting, apply reset checks
        if !ballIsResetting {
        
            // If the ball is moving too slow horizontally, increase speed
            if !((ball.physicsBody!.velocity.dx > minimumHorizontalVelocity) || (ball.physicsBody!.velocity.dx < -minimumHorizontalVelocity)) {
                
                // If the ball isn't moving horizontal at all, increase speed by a fifth of the minimumspeed
                if !((ball.physicsBody!.velocity.dx > +(minimumHorizontalVelocity / 10)) || (ball.physicsBody!.velocity.dx < -(minimumHorizontalVelocity / 10))) {
                    println("LOG | Ball moving WAY TOO SLOW horizontally -> adding one fifth of minimumHorizontalVelocity")
                    ball.physicsBody!.velocity.dy += (ball.position.x > self.frame.midX ? -(minimumHorizontalVelocity / 5) : +(minimumHorizontalVelocity / 5))
                }
                
                print("LOG | ball moving too slow horizontally: \(Int(ball.physicsBody!.velocity.dx)), increasing speed --> ")
                ball.physicsBody!.velocity.dx *= horizontalTooSlowMultiplier
                println("new speed: \(Int(ball.physicsBody!.velocity.dx))")
            }
            
            // If the ball is moving too slow vertically, increase speed
            if !((ball.physicsBody!.velocity.dy > minimumVerticalVelocity) || (ball.physicsBody!.velocity.dy < -minimumVerticalVelocity)) {
                
                // If the ball isn't moving vertical at all, increase speed by a fifth of the minimumVerticalVelocity
                if !((ball.physicsBody!.velocity.dy > +(minimumVerticalVelocity / 10)) || (ball.physicsBody!.velocity.dy < -(minimumVerticalVelocity / 10))) {
                    println("LOG | Ball moving WAY TOO SLOW vertically -> adding a fifth of minimumVerticalVelocity")
                    ball.physicsBody!.velocity.dy += (ball.position.y > self.frame.midY ? -(minimumVerticalVelocity / 5) : +(minimumVerticalVelocity / 5))
                }
                
                print("LOG | ball moving too slow vertically: \(Int(ball.physicsBody!.velocity.dy)), increasing speed --> ")
                ball.physicsBody!.velocity.dy *= verticalTooSlowMultiplier
                println("new speed: \(Int(ball.physicsBody!.velocity.dy))")
            }
        }
        
        // Update debug labels
        if debugLabelsAreEnabled {
            debugLabelPosition.text = "POSITION x: \(Int(ball.position.x)) y: \(Int(ball.position.y))"
            debugLabelVelocity.text = "VELOCITY dx: \(Int(ball.physicsBody!.velocity.dx)) dy: \(Int(ball.physicsBody!.velocity.dy))"
            debugLabelOther.text    = "PADDLEHITCOUNT: \(paddleHitCount)"
            debugLabelRunning.text  = "RUNNING: \(gameIsRunning)"
        } else  {
            debugLabelPosition.text = ""
            debugLabelVelocity.text = ""
            debugLabelOther.text    = ""
            debugLabelRunning.text  = ""
        }
        
    }
    
    func gameDidEnd(#winner: Int) {
        println("LOG | gameDidEnd() now running")
        if gameIsRunning {
            gameIsRunning = false
            ball.removeFromParent()
            
            // Update game end labels to "You win! / You lose..."
            gameEndLabel1.text = (winner == 1 ? "You win!" : "You lose...")
            gameEndLabel1.runAction(SKAction.fadeInWithDuration(1), completion: { () -> Void in
                self.playLabel.runAction(SKAction.fadeInWithDuration(3))
            })
            
            gameEndLabel2.text = (winner == 2 ? "You win!" : "You lose...")
            gameEndLabel2.runAction(SKAction.fadeInWithDuration(1), completion: { () -> Void in
                self.againLabel.runAction(SKAction.fadeInWithDuration(3))
            })
        }
        
    }
    
    //get new vector for ball (used at resetBall)
    func newBallVector(var forPlayer player: Int) -> CGVector {
        
        if !(player == 1 || player == 2) {
            println("ERR | Invalid player argument at newBallVector() --> using player 1 instead")
            player = 1
        }
        
        var dx: CGFloat = possibleStartDx[Int(arc4random_uniform(UInt32(possibleStartDx.count)))] * (player == 1 ? +1 : -1)
        var dy: CGFloat = possibleStartDy[Int(arc4random_uniform(UInt32(possibleStartDy.count)))]
        
        println("LOG | new random ball vector --> dx: \(dx), dy: \(dy)")
        return CGVector(dx: dx, dy: dy)
    }
    
    func resetBall() {
        println("LOG | resetting ball")
        //run reset action
        
        
        let part1 = SKAction.moveTo(CGPoint(x: self.frame.midX, y: self.frame.height - ball.size.height ), duration: 1)
        let part2 = SKAction.moveTo(CGPoint(x: self.frame.midX, y: ball.size.height ), duration: 1)
        let part3 = SKAction.moveTo(CGPoint(x: self.frame.midX, y: self.frame.midY), duration: 2)
        let part4 = SKAction.moveTo(CGPoint(x: self.frame.midX, y: self.frame.midY), duration: 1)

        // apply easings for smooth movement
        part1.timingMode = SKActionTimingMode.EaseInEaseOut
        part2.timingMode = SKActionTimingMode.EaseInEaseOut
        part3.timingMode = SKActionTimingMode.EaseInEaseOut

        let sequence = SKAction.sequence([part1, part2, part3, part4])
        
        ball.physicsBody!.velocity = CGVector(dx:0, dy:0)
        
        ball.runAction(sequence, completion: { () -> Void in
            // taking turns on getting the ball first
            if ( self.paddle1score + self.paddle2score ) % 2 == 0 {
                self.ball.physicsBody!.velocity = self.newBallVector(forPlayer: 1)
            } else {
                self.ball.physicsBody!.velocity = self.newBallVector(forPlayer: 2)
            }
            self.ballIsResetting = false
        })
        
        paddleHitCount = 0
        
    }
    
    func resetGame() {
        println("LOG | game resetting")
        resetBall()
        
        paddle1score = 0
        paddle2score = 0
        
        paddle1scoreLabel.text = "\(paddle1score)"
        paddle2scoreLabel.text = "\(paddle2score)"
        
        gameEndLabel1.runAction(SKAction.fadeOutWithDuration(1))
        gameEndLabel2.runAction(SKAction.fadeOutWithDuration(1))
    }
}