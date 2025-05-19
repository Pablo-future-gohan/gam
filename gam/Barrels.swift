//
//  GameScene.swift
//  BarrelRoll2
//
//  Created by 3 Kings on 5/2/25.
//

import SwiftUI
import SpriteKit



class Barrels: SKScene, SKPhysicsContactDelegate {
    var onGameOver: (() -> Void)?;
    
    //various variables
    var ball = SKSpriteNode()
    var barrel1 = SKSpriteNode()
    var barrel2 = SKSpriteNode()
    var score = 0
    var bottom = Int.random(in: 50 ... 60)
    var top = Int.random(in: -60 ... -50)
    var edge = SKSpriteNode()
    var timer: Timer?
    var seconds = 0.0
    let label = SKLabelNode(text: "")
    var balls: [SKSpriteNode] = []
    



    
    
    
    override func didMove(to view: SKView) {
        //makes the sludgeball
        
        
        self.scene?.physicsWorld.contactDelegate = self
        
        
        ball = SKSpriteNode(imageNamed:"Adobe Express - file")
        ball.size=CGSize(width: 40, height: 50)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 22.5)
        ball.physicsBody?.affectedByGravity = false
        ball.name = "ball"
        ball.physicsBody?.collisionBitMask = 1
        ball.physicsBody?.contactTestBitMask = 1
        ball.physicsBody?.categoryBitMask = 1
        
        
        
        
        
        //makes the bottom barrel
        barrel1 = SKSpriteNode(imageNamed: "barrels-with-toxic-waste-png")
        barrel1.size=CGSize(width: 110, height: 120)
        barrel1.position = CGPoint(x: size.width/2, y: 100)
        barrel1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 120))
        barrel1.physicsBody?.affectedByGravity = false
        barrel1.physicsBody?.restitution = 1.1
        barrel1.name = "barrel1"
        barrel1.physicsBody?.collisionBitMask = 0b10
        barrel1.physicsBody?.contactTestBitMask = 0b10
        barrel1.physicsBody?.categoryBitMask = 0b10
        
        
        
        
        
        //makes the bottom barrel
        barrel2 = SKSpriteNode(imageNamed: "barrels-with-toxic-waste-png")
        barrel2.size=CGSize(width: 110, height: 120)
        barrel2.position = CGPoint(x: size.width/2, y: frame.maxY - 100.0)
        barrel2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 120))
        barrel2.physicsBody?.affectedByGravity = false
        barrel2.physicsBody?.restitution = 1.1
        barrel2.name = "barrel2"
        barrel2.physicsBody?.collisionBitMask = 1
        barrel2.physicsBody?.contactTestBitMask = 1
        barrel2.physicsBody?.categoryBitMask = 1
        barrel2.physicsBody?.allowsRotation = false
        
        
        addChild(barrel2)
        
        
        //makes the edge of the screen
        edge = SKSpriteNode()
        edge.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        edge.physicsBody?.collisionBitMask = 0b11
        edge.physicsBody?.contactTestBitMask = 0b11
        edge.name = "edge"
        edge.physicsBody?.categoryBitMask = 0b11
        
        
        
        addChild(edge)
        
        
        
        
        addChild(barrel1)
        barrel1.physicsBody?.applyImpulse(CGVector(dx:bottom, dy:0))
        barrel2.physicsBody?.applyImpulse(CGVector(dx:top, dy:0))
        
        
        
        
        //adds the score counter
        label.position = CGPoint(x: frame.minX+50, y: frame.maxY-50)
        label.fontSize = 20
        label.text="\(score)"
        addChild(label)

        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        
        
        //Checks if barrel is touched and if it is then the ball is spawned and shoots.
        if barrel1.frame.contains(location) {
            
            if(balls.count<1){
                ball = SKSpriteNode(imageNamed:"Adobe Express - file")
                ball.size=CGSize(width: 40, height: 50)
                ball.physicsBody = SKPhysicsBody(circleOfRadius: 22.5)
                ball.physicsBody?.affectedByGravity = false
                ball.name = "ball"
                ball.physicsBody?.collisionBitMask = 1
                ball.physicsBody?.contactTestBitMask = 1
                ball.physicsBody?.categoryBitMask = 1
                
                ball.position = CGPoint(x: barrel1.position.x, y: barrel1.position.y+10)
                
                addChild(ball)
                
                
                balls.append(ball)
            } else{
                
            }
            
            //The ball decreases speed as time goes on so this caps it at a minimum so the speed doesn't decrease too much.
            if(score<90){
                ball.physicsBody?.applyImpulse(CGVector(dx:0, dy:200-score*2))
            } else {
                ball.physicsBody?.applyImpulse(CGVector(dx:0, dy:20))
                
            }
            
        }
    }
    
    
    
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        //If the ball hits the top barrel
        if contact.bodyB.node?.name == "ball" {
            
            if(contact.bodyA.node?.name == "barrel2")
            {
                score+=1
                label.text="\(score)"

                //removes the ball and replaces the top barrel with barrel1
                balls.removeAll()
                ball.removeFromParent()
                barrel2.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                barrel1.removeFromParent()
                barrel1.position = CGPoint(x: barrel2.position.x, y: barrel2.position.y)
                addChild(barrel1)
                barrel2.removeFromParent()
                
                
                //Shifts the barrel down until it reaches the right spot
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    self.seconds+=1.0
                    
                    if(self.seconds<3.0){
                        self.barrel1.physicsBody?.velocity = CGVector(dx: 0, dy: -300)
                    } else {
                        self.seconds=0.0
                        self.bottom = Int.random(in: 50...60)
                        self.top = Int.random(in: -60 ... -50)

                        self.timer?.invalidate()
                        self.barrel1.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        self.addChild(self.barrel2)
                        self.barrel1.physicsBody?.applyImpulse(CGVector(dx:self.bottom+(self.score*4), dy:0))
                        self.barrel2.physicsBody?.applyImpulse(CGVector(dx:self.top+(self.score*4), dy:0))

                        
                    }
                }
                

                
            }
            else if (contact.bodyB.node?.name == "ball"){
                if (contact.bodyA.node?.name == "edge"){
                    removeAllChildren()
                    label.position = CGPoint(x: frame.maxX/2, y: frame.maxY/2)
                    label.fontSize = 100
                    label.text="Score: \(score)"
                    addChild(label)
                    onGameOver?();
                }
            }
            
            
            
        }
        
        
        
        
    }
}
