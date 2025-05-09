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
    var paddle = SKShapeNode(rectOf: CGSize(width: 80, height: 15), cornerRadius: 10)
    var score: Int = 0
    var ballCount = 0
    var pulseTimer = 0
    var time = 0
    let blockSpeed = 0.2
    var row = 12
    var canMakeRow = true
    
    override func sceneDidLoad() {
        let ground = SKNode()
        w = (Int(size.width) - space * 2) / 8
        ball = SKShapeNode(circleOfRadius: ballSize)
        block = SKSpriteNode(color: .blue, size: CGSize(width: w, height: h))
        
        ground.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        ground.physicsBody?.collisionBitMask = mainCategory
        ground.physicsBody?.contactTestBitMask = mainCategory
        ground.physicsBody?.categoryBitMask = mainCategory
        ground.physicsBody?.node?.name = "ground"
        addChild(ground)
        
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
        paddle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 80, height: 15))
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        print(ballCount)
        time += 1
        pulseTimer += 1
        scoreLabel.zRotation = sin(CGFloat(time) / 50.0) * 0.1
        scoreLabel.fontSize = mapEase(val: CGFloat(pulseTimer), fromMin: 0.0, fromMax: 20.0, toMin: CGFloat(175.0 - (Double(score) * 0.5)), toMax: 250.0, exp: 0.25)
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50 - (scoreLabel.fontSize * 0.25))
        enumerateChildNodes(withName:"//*", using:
            { (node, stop) -> Void in
            if node.name?.prefix(5) == "block" && self.ballCount > 0 {
                    node.position.y -= self.blockSpeed
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
        
        else if (((contact.bodyB.node?.name == "ball" && contact.bodyA.node?.name == "ground") ||
                 (contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "ground")) && contact.bodyB.node?.position.y ?? size.height < ballSize * 2) {
            ballCount -= 1
            if (ballCount == 0) {
                label.text = "Dropped The Ball :("
                label.fontColor = UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 0.5)
                scoreLabel.fontColor = UIColor(red: 1, green: 0.3, blue: 0.3, alpha: 0.3)
                paddle.fillColor = .red
            }
            for i in 2...30 {
                randomSize = CGFloat.random(in: 2...7)
                particle = SKShapeNode(circleOfRadius: randomSize)
                particle.fillColor = .blue
                particle.physicsBody = SKPhysicsBody(circleOfRadius: randomSize)
                particle.physicsBody?.affectedByGravity = true
                particle.position = CGPoint(x: (contact.bodyB.node?.position.x)! + CGFloat.random(in: -5...5), y: (contact.bodyB.node?.position.y)! + CGFloat.random(in: -5...5))
                particle.physicsBody?.linearDamping = 0
                particle.physicsBody?.angularDamping = 0
                particle.physicsBody?.restitution = 0.7
                particle.physicsBody?.collisionBitMask = 1 << i
                particle.physicsBody?.categoryBitMask = 1 << i
                particle.physicsBody?.contactTestBitMask = 1 << i
                particle.physicsBody?.mass = 0.3 * randomSize
                addChild(particle)
                particle.physicsBody?.applyImpulse(CGVector(dx: CGFloat.random(in: -150 + (contact.bodyB.node?.physicsBody?.velocity.dx)! * 0.6...150 + (contact.bodyB.node?.physicsBody?.velocity.dx)! * 0.6), dy: 0))
                particle.physicsBody?.applyImpulse(CGVector(dx: 0, dy: CGFloat.random(in: (contact.bodyB.node?.physicsBody?.velocity.dy)! * 0.4...(contact.bodyB.node?.physicsBody?.velocity.dy)! * 1.1)))
            }
            contact.bodyB.node?.removeFromParent()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        
        paddle.position = CGPoint(x: location.x, y: paddle.position.y)
    }
    
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
            ball.physicsBody?.allowsRotation = true
            addChild(particle)
            particle.physicsBody?.applyImpulse(CGVector(dx: CGFloat.random(in: -310...310), dy: CGFloat.random(in: -300...300)))
            particle.physicsBody?.angularVelocity = CGFloat.random(in: -40...40)
        }
    }
}
