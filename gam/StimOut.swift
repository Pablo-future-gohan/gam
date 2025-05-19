//
//  GameScene.swift
//  Breakout
//
//  Created by Scaife, Benjamin (512176) on 3/11/25.
//

import SwiftUI
import SpriteKit
import Foundation

class StimOut: SKScene, SKPhysicsContactDelegate {
    var onGameOver: (() -> Void)?;
    
    //bunch of important variables
    var w = 40
    let h = 15
    let space = 2
    let ballSize = 15.0
    let mainCategory: UInt32 = 1
    let label = SKLabelNode()
    let scoreLabel = SKLabelNode()
    var ball = SKShapeNode(circleOfRadius: 15.0)
    var block = SKSpriteNode(color: .blue, size: CGSize(width: 40, height: 15))
    var particle = SKShapeNode(circleOfRadius: 5.0)
    var paddle = SKShapeNode(rectOf: CGSize(width: 100, height: 15), cornerRadius: 10)
    var score: Int = 0
    var ballCount = 0
    var pulseTimer = 0
    var time = 0
    let blockSpeed = 0.2
    var row = 12
    var canMakeRow = true
    var ground = SKNode()
    var particleGround = SKNode()
    var lose = false
    
    //these two variables are for the reset button and go home button
    var reset: SKNode! = nil
    let resetText = SKLabelNode(text: "")
    var leave: SKNode! = nil
    let leaveText = SKLabelNode(text: "")
    
    override func sceneDidLoad() {
        w = (Int(size.width) - space * 2) / 8
        ball = SKShapeNode(circleOfRadius: ballSize)
        block = SKSpriteNode(color: .blue, size: CGSize(width: w, height: h))
        
        
        
        
        //This makes all the edges
        let topLeft = CGPoint(x: frame.minX, y: frame.maxY)
        let topRight = CGPoint(x: frame.maxX, y: frame.maxY)
        let bottomLeft = CGPoint(x: frame.minX, y: frame.minY)
        let bottomRight = CGPoint(x: frame.maxX, y: frame.minY)
        
        

        let top = SKNode()
        top.physicsBody = SKPhysicsBody(edgeFrom: topLeft, to: topRight)
        top.physicsBody?.node?.name = "Top"
        top.physicsBody?.contactTestBitMask = 1
        top.physicsBody?.collisionBitMask = 1
        addChild(top)
        
        let left = SKNode()
        left.physicsBody = SKPhysicsBody(edgeFrom: topLeft, to: bottomLeft)
        left.physicsBody?.node?.name = "Left"
        left.physicsBody?.contactTestBitMask = 1
        left.physicsBody?.collisionBitMask = 1
        addChild(left)
        
        let right = SKNode()
        right.physicsBody = SKPhysicsBody(edgeFrom: topRight, to: bottomRight)
        right.physicsBody?.node?.name = "Right"
        right.physicsBody?.contactTestBitMask = 1
        right.physicsBody?.collisionBitMask = 1
        addChild(right)
        
        
        ground.physicsBody=SKPhysicsBody(edgeFrom: bottomLeft, to: bottomRight)
        ground.physicsBody?.collisionBitMask = mainCategory
        ground.physicsBody?.contactTestBitMask = mainCategory
        ground.physicsBody?.categoryBitMask = mainCategory
        ground.physicsBody?.node?.name = "ground"
        addChild(ground)
        
        
        
        
        //this ground is used to delete the particles to not have a bunch of them falling and slowing the game down
        particleGround.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX-1000, y: frame.minY-100), to: CGPoint(x: frame.maxX+1000, y: frame.minY-100))
        particleGround.physicsBody?.collisionBitMask = 0b1111111111111111111111111111111
        particleGround.physicsBody?.contactTestBitMask = 0b1111111111111111111111111111111
        particleGround.physicsBody?.categoryBitMask = 0b1111111111111111111111111111111
        particleGround.physicsBody?.node?.name = "particleGround"
        addChild(particleGround)
        
        self.physicsWorld.contactDelegate = self
        
        
        label.position = CGPoint(x: size.width / 2, y: size.height / 2 - 180)
        label.fontSize = 27
        label.fontName = "PingFangTC-Regular"
        label.fontColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 135)
        scoreLabel.fontSize = 250
        scoreLabel.fontName = "PingFangTC-Semibold"
        scoreLabel.fontColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        scoreLabel.text = "0"
        addChild(label)
        addChild(scoreLabel)
        
        for j in 0...row {
            makeRowOfBlocks(j, j)
        }
        
        makeBall()
        

        paddle.position = CGPoint(x: size.width / 2, y: 100)
        paddle.fillColor = .green
        paddle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 15))
        paddle.physicsBody?.affectedByGravity = false
        paddle.physicsBody?.collisionBitMask = mainCategory
        paddle.physicsBody?.contactTestBitMask = mainCategory
        paddle.physicsBody?.categoryBitMask = mainCategory
        paddle.physicsBody?.linearDamping = 0
        paddle.physicsBody?.angularDamping = 0
        paddle.physicsBody?.restitution = 1
        paddle.physicsBody?.node?.name = "paddle"
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)
        
        ball.physicsBody?.applyImpulse(CGVector(dx: -200 * CGFloat(ball.physicsBody?.mass ?? 1), dy: 450 * CGFloat(ball.physicsBody?.mass ?? 1)))
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
        
        time += 1
        pulseTimer += 1
        scoreLabel.zRotation = sin(CGFloat(time) / 50.0) * 0.1
        scoreLabel.fontSize = mapEase(val: CGFloat(pulseTimer), fromMin: 0.0, fromMax: 20.0, toMin: CGFloat(175.0 - (Double(score) * 0.5)), toMax: 250.0, exp: 0.25)
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50 - (scoreLabel.fontSize * 0.25))
        
        enumerateChildNodes(withName:"//*", using:
            { (node, stop) -> Void in
            if (node.name ?? "notblock").prefix(5) == "block" && self.ballCount > 0 && !self.lose {
                    node.position.y -= self.blockSpeed
                if (node.position.y < self.frame.minY - 20 && node.position.x > self.frame.minX && node.position.x < self.frame.maxX) {
                    self.lose = true
                    self.label.text = "Block Escaped :("
                    self.label.fontColor = UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 0.5)
                    self.scoreLabel.fontColor = UIColor(red: 1, green: 0.3, blue: 0.3, alpha: 0.3)
                    
                    let defaults = UserDefaults.standard;
                    defaults.set((defaults.object(forKey: "Money") as? Int ?? 0) + (5 * self.score), forKey: "Money");
                    
                    //makes the two buttons at the bottom to reset the game to go to the home screen
                    self.reset = SKSpriteNode(color: .red, size: CGSize(width: 140, height: 44))
                    self.reset.position = CGPoint(x:self.frame.midX-100, y:self.frame.midY-150);
                    self.resetText.text="Restart"
                    self.resetText.fontSize=23
                    self.resetText.position = CGPoint(x:self.frame.midX-100, y:self.frame.midY-156);
                    self.resetText.fontColor = .white
                    self.resetText.fontName="PixelEmulator"
                    
                    
                    self.leave = SKSpriteNode(color: .red, size: CGSize(width: 140, height: 44))
                    self.leave.position = CGPoint(x:self.frame.midX+100, y:self.frame.midY-150);
                    self.leaveText.text="Home"
                    self.leaveText.fontSize=23
                    self.leaveText.position = CGPoint(x:self.frame.midX+100, y:self.frame.midY-156);
                    self.leaveText.fontColor = .white
                    self.leaveText.fontName="PixelEmulator"
                    
                    self.addChild(self.leave)
                    self.addChild(self.leaveText)
                    self.addChild(self.reset)
                    self.addChild(self.resetText)
                    
                    self.children.forEach { (node) in
                        if node.name == "ball" {
                            for i in 2...30 {
                                let randomSize = CGFloat.random(in: 2...7)
                                self.particle = SKShapeNode(circleOfRadius: randomSize)
                                self.particle.fillColor = .blue
                                self.particle.physicsBody = SKPhysicsBody(circleOfRadius: randomSize)
                                self.particle.physicsBody?.affectedByGravity = true
                                self.particle.position = CGPoint(x: (node.position.x) + CGFloat.random(in: -5...5), y: (node.position.y) + CGFloat.random(in: -5...5))
                                self.particle.physicsBody?.linearDamping = 0
                                self.particle.physicsBody?.angularDamping = 0
                                
                                self.particle.physicsBody?.node?.name = "particle"

                                self.particle.physicsBody?.restitution = 0.7
                                self.particle.physicsBody?.collisionBitMask = 1 << i
                                self.particle.physicsBody?.categoryBitMask = 1 << i
                                self.particle.physicsBody?.contactTestBitMask = 1 << i
                                
                                self.particle.physicsBody?.mass = 0.3 * randomSize
                                self.addChild(self.particle)
                                
                                self.particle.physicsBody?.applyImpulse(CGVector(dx: CGFloat.random(in: -150 + (node.physicsBody?.velocity.dx ?? CGFloat(0.0)) * 0.6...150 + (node.physicsBody?.velocity.dx ?? CGFloat(0.0)) * 0.6), dy: 0))
                                self.particle.physicsBody?.applyImpulse(CGVector(dx: 0, dy: CGFloat.random(in: (abs((node.physicsBody?.velocity.dy)!)) * 0.4...(abs((node.physicsBody?.velocity.dy)!)) * 1.1)))
                            }
                            node.removeFromParent()
                        }
                    }
                }
                }
            })

        
        if (Int(Double(time) * blockSpeed) % (h + space)) == 0 {
            if canMakeRow {
                row += 1
                makeRowOfBlocks(row, 0)
                canMakeRow = false
            }
        }
        else {
            canMakeRow = true
        }
        
                    
                    
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var randomSize: CGFloat
        
        //what happens if the ball hits a block
        if (contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name?.prefix(5) == "block") {
            
            
            makeBlockParticles(childNode(withName: (contact.bodyB.node?.name)!)! as! SKSpriteNode)
            contact.bodyB.node?.removeFromParent()
            score += 1
            scoreLabel.text = "\(score)"
            pulseTimer = 0
            
            if (score % 6 == 0) {
                makeBall()
            }
        }

        else if (contact.bodyB.node?.name == "ball" && contact.bodyA.node?.name?.prefix(5) == "block") {
            makeBlockParticles(childNode(withName: (contact.bodyA.node?.name)!)! as! SKSpriteNode)
            contact.bodyA.node?.removeFromParent()
            score += 1
            scoreLabel.text = "\(score)"
            pulseTimer = 0
            
            if (score % 6 == 0) {
                makeBall()
            }
        }
        
        
        //what happens if a ball hits the ground
        else if ((contact.bodyB.node?.name == "ball" && contact.bodyA.node?.name == "ground")) {
                ballCount -= 1
                
                
                if (ballCount == 0 && !lose) {
                    label.text = "Dropped The Ball :("
                    label.fontColor = UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 0.5)
                    scoreLabel.fontColor = UIColor(red: 1, green: 0.3, blue: 0.3, alpha: 0.3)
                    
                    let defaults = UserDefaults.standard;
                    defaults.set((defaults.object(forKey: "Money") as? Int ?? 0) + (5 * score), forKey: "Money");
                    
                    //makes the two buttons at the bottom to reset the game to go to the home screen
                    reset = SKSpriteNode(color: .red, size: CGSize(width: 140, height: 44))
                    reset.position = CGPoint(x:self.frame.midX-100, y:self.frame.midY-150);
                    resetText.text="Restart"
                    resetText.fontSize=23
                    resetText.position = CGPoint(x:self.frame.midX-100, y:self.frame.midY-156);
                    resetText.fontColor = .white
                    resetText.fontName="PixelEmulator"
                    
                    
                    leave = SKSpriteNode(color: .red, size: CGSize(width: 140, height: 44))
                    leave.position = CGPoint(x:self.frame.midX+100, y:self.frame.midY-150);
                    leaveText.text="Home"
                    leaveText.fontSize=23
                    leaveText.position = CGPoint(x:self.frame.midX+100, y:self.frame.midY-156);
                    leaveText.fontColor = .white
                    leaveText.fontName="PixelEmulator"
                    
                    self.addChild(leave)
                    self.addChild(leaveText)
                    self.addChild(reset)
                    self.addChild(resetText)

                }
                
                for i in 2...30 {
                    randomSize = CGFloat.random(in: 2...7)
                    particle = SKShapeNode(circleOfRadius: randomSize)
                    particle.fillColor = .blue
                    particle.physicsBody = SKPhysicsBody(circleOfRadius: randomSize)
                    particle.physicsBody?.affectedByGravity = true
                    particle.position = CGPoint(x: (contact.bodyB.node?.position.x) ?? 0 + CGFloat.random(in: -5...5), y: (contact.bodyB.node?.position.y) ?? 0 + CGFloat.random(in: -5...5))
                    particle.physicsBody?.linearDamping = 0
                    particle.physicsBody?.angularDamping = 0
                    
                    particle.physicsBody?.node?.name = "particle"

                    particle.physicsBody?.restitution = 0.7
                    particle.physicsBody?.collisionBitMask = 1 << i
                    particle.physicsBody?.categoryBitMask = 1 << i
                    particle.physicsBody?.contactTestBitMask = 1 << i
                    
                    particle.physicsBody?.mass = 0.3 * randomSize
                    addChild(particle)
                    
                    particle.physicsBody?.applyImpulse(CGVector(dx: CGFloat.random(in: -150 + (contact.bodyB.node?.physicsBody?.velocity.dx ?? CGFloat(0.0)) * 0.6...150 + (contact.bodyB.node?.physicsBody?.velocity.dx ?? CGFloat(0.0)) * 0.6), dy: 0))
                    particle.physicsBody?.applyImpulse(CGVector(dx: 0, dy: CGFloat.random(in: (abs((contact.bodyB.node?.physicsBody?.velocity.dy)!)) * 0.4...(abs((contact.bodyB.node?.physicsBody?.velocity.dy)!)) * 1.1)))
                }
                contact.bodyB.node?.removeFromParent()
            
            
        }
        
        
        //if the block hits the ground in order to prevent goofy stuff from happening
        else if (contact.bodyB.node?.name?.prefix(5) == "block" && contact.bodyA.node?.name == "ground"){
            removeAllChildren()
            
            label.text = "Block hit the ground :("
            label.fontColor = UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 0.5)
            scoreLabel.fontColor = UIColor(red: 1, green: 0.3, blue: 0.3, alpha: 0.3)
            addChild(label)
            addChild(scoreLabel)
            
            lose = true
        }
        
   
        
        
        //what happens if a particle hits the lower ground
        if (contact.bodyA.node?.name=="particle" && contact.bodyB.node?.name=="particleGround"){
            contact.bodyA.node?.removeFromParent()
        } else if (contact.bodyB.node?.name=="particle" && contact.bodyA.node?.name=="particleGround"){
            contact.bodyB.node?.removeFromParent()

        } else {
            
        }
    }
    
    
    //lets you move the paddle
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        
        paddle.position = CGPoint(x: location.x, y: paddle.position.y)
    }
    
    
    
    //makes the ball
    func makeBall() {

        let ball = SKShapeNode(circleOfRadius: 15.0)
        ball.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ballSize * 2, height: ballSize * 2))
        ball.fillColor = .blue
        ball.position = CGPoint(x: size.width / 2, y: size.height / 2)

        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.restitution = 1.01
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.mass = 99999
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.collisionBitMask = mainCategory
        ball.physicsBody?.contactTestBitMask = mainCategory
        ball.physicsBody?.categoryBitMask = mainCategory
        ball.physicsBody?.node?.name = "ball"
        
        addChild(ball)
        ballCount += 1
        
        ball.physicsBody?.applyImpulse(CGVector(dx: CGFloat.random(in: -250.0 ... -150.0) * CGFloat(ball.physicsBody?.mass ?? 1), dy: 450 * CGFloat(ball.physicsBody?.mass ?? 1)))

    }
    
    func mapEase(val: CGFloat, fromMin: CGFloat, fromMax: CGFloat, toMin: CGFloat, toMax: CGFloat, exp: Double) -> CGFloat {
        return (((toMax - toMin) * (pow((min(max(val, fromMin), fromMax) - fromMin) / (fromMax - fromMin), exp))) + toMin)
    
    }
    
    func makeRowOfBlocks(_ numRow: Int, _ SpawnAt: Int) {
        for i in 0...9 {
            block = SKSpriteNode(color: UIColor(hue: CGFloat.random(in: 0.5...0.58) + CGFloat(numRow) / 18.0, saturation: 1, brightness: 0.2 + CGFloat(numRow) / 10.0, alpha: 1), size: CGSize(width: w, height: h))
            block.position.x = CGFloat((w + space) * i - (w + space) / 2)
            block.position.y = size.height - CGFloat((h + space) * min(SpawnAt, 12) - (h + space) / 2)
            block.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: w, height: h))
            block.physicsBody?.restitution = 1
            block.physicsBody?.linearDamping = 0
            block.physicsBody?.angularDamping = 0
            block.physicsBody?.friction = 0
            block.physicsBody?.affectedByGravity = false
            block.physicsBody?.isDynamic = false
            block.physicsBody?.collisionBitMask = mainCategory
            block.physicsBody?.contactTestBitMask = mainCategory
            block.physicsBody?.categoryBitMask = mainCategory
            block.physicsBody?.node?.name = "block\((numRow + 1) * 9 + i)"
            
            addChild(block)
        }
    }
    
    func makeBlockParticles(_ body: SKSpriteNode) {
        var randomSize: CGFloat
        for i in 2...5 {
            randomSize = CGFloat.random(in: 2...20)
            particle = SKShapeNode(rectOf: CGSize(width: randomSize, height: randomSize))
//            particle.fillColor = body.color
//            particle.fillColor.setFill()
            particle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: randomSize, height: randomSize))
            particle.physicsBody?.affectedByGravity = true
            particle.position = CGPoint(x: (body.position.x) + CGFloat.random(in: -5...5), y: (body.position.y) + CGFloat.random(in: -5...5))
            particle.physicsBody?.linearDamping = 0
            particle.physicsBody?.angularDamping = 0
            particle.physicsBody?.restitution = 0.3
            particle.physicsBody?.collisionBitMask = 1 << i
            particle.physicsBody?.categoryBitMask = 1 << i
            particle.physicsBody?.contactTestBitMask = 1 << i
            particle.physicsBody?.mass = 0.3 * randomSize
            particle.name = "particle";
            ball.physicsBody?.allowsRotation = true
            addChild(particle)
            particle.physicsBody?.applyImpulse(CGVector(dx: CGFloat.random(in: -310...310), dy: CGFloat.random(in: -300...300)))
            particle.physicsBody?.angularVelocity = CGFloat.random(in: -40...40)
        }
    }
    
    // for losing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        if(reset != nil){
            if reset.frame.contains(location){
                removeAllChildren()
                var newScene: SKScene {
                    let scene = StimOut(size: self.size);
                    scene.onGameOver = {
                        self.onGameOver?();
                    }
                    return scene;
                } // thanks chatgpt
                newScene.scaleMode = self.scaleMode
                self.view?.presentScene(newScene)
            }
        }
        
        if(leave != nil){
            if leave.frame.contains(location){
                onGameOver?();
            }
        }
    }
}
