//
//  GameScene.swift
//  BallJuggler
//
//  Created by Popovich, Daniel (512413) on 4/21/25.
//

import SwiftUI
import SpriteKit


class BallJuggler: SKScene, SKPhysicsContactDelegate {
    var onGameOver: (() -> Void)?;
    
    //just some variables I made
    var ball = SKSpriteNode()
    @Published var seconds=0.0
    @Published var minutes=0
    var balls: [SKSpriteNode] = []

    var timer: Timer?
    var t = 10.0
    let label = SKLabelNode(text: "")
    let score = SKLabelNode(text: "")
    var scoreVal = 0
    var x = 0
        
    
    //these two variables are for the reset button and go home button
    var reset: SKNode! = nil
    let resetText = SKLabelNode(text: "")
    var leave: SKNode! = nil
    let leaveText = SKLabelNode(text: "")
    
    //when the scene loads the ball is made and added to the gamescene
    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self

        
        ball = SKSpriteNode(imageNamed:"soccer-ball-png-24")
        ball.size=CGSize(width: 100, height: 100)
        ball.position = CGPoint(x: size.width/2, y: 500)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.collisionBitMask = 1
        ball.physicsBody?.allowsRotation = true;
        
        ball.name="Ball"
        
        addChild(ball)
        balls.append(ball)
    }
    
    
    
    override func didMove(to view: SKView) {
        
        
        //this makes a timer which will be used to determine speed of the ball and score at the end
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.seconds+=1.0
            self.t+=1
            self.scoreVal+=1
            
            
            
            if self.seconds>=60{
                self.seconds=0.0
                self.minutes+=1
                self.x+=1
                if(self.x==3){
                    
                    self.ball = SKSpriteNode(imageNamed:"soccer-ball-png-24")
                    self.ball.size=CGSize(width: 100, height: 100)
                    self.ball.position = CGPoint(x: self.size.width/2, y: 500)
                    
                    self.ball.physicsBody = SKPhysicsBody(circleOfRadius: 50)
                    self.ball.physicsBody?.affectedByGravity = true
                    self.ball.physicsBody?.friction = 0
                    self.ball.physicsBody?.restitution = 0
                    self.ball.physicsBody?.angularDamping = 0
                    self.ball.physicsBody?.linearDamping = 0
                    self.ball.physicsBody?.collisionBitMask = 1
                    self.ball.physicsBody?.allowsRotation = true;
                    self.ball.name="Ball"

                    self.addChild(self.ball)
                    self.balls.append(self.ball)
                    
                    self.x=0
                }
            }
            if self.minutes>=60{
                self.minutes=0
            }
        }
        
        
        
        //This posts the timer
        label.position = CGPoint(x: size.width/2, y: size.height/2+100)
        label.fontSize = 60
        label.text="\(minutes):\(seconds)"
        addChild(label)
        

        
        //makes barriers all around
        let topLeft = CGPoint(x: frame.minX, y: frame.maxY)
        let topRight = CGPoint(x: frame.maxX, y: frame.maxY)
        let bottomLeft = CGPoint(x: frame.minX, y: frame.minY)
        let bottomRight = CGPoint(x: frame.maxX, y: frame.minY)


        
        let top = SKNode()
        top.physicsBody = SKPhysicsBody(edgeFrom: topLeft, to: topRight)
        top.physicsBody?.node?.name = "Top"
        top.physicsBody?.contactTestBitMask = 1
        top.physicsBody?.collisionBitMask = 1
        
        let left = SKNode()
        left.physicsBody = SKPhysicsBody(edgeFrom: topLeft, to: bottomLeft)
        left.physicsBody?.node?.name = "Left"
        left.physicsBody?.contactTestBitMask = 1
        left.physicsBody?.collisionBitMask = 1
        
        let right = SKNode()
        right.physicsBody = SKPhysicsBody(edgeFrom: topRight, to: bottomRight)
        right.physicsBody?.node?.name = "Right"
        right.physicsBody?.contactTestBitMask = 1
        right.physicsBody?.collisionBitMask = 1
        
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeFrom: bottomLeft, to: bottomRight)
        bottom.physicsBody?.node?.name = "Bottom"
        bottom.physicsBody?.contactTestBitMask = 1
        bottom.physicsBody?.collisionBitMask = 1
        
        
        addChild(bottom)
        addChild(top)
        addChild(right)
        addChild(left)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        //gravity increases via a square root function
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.75*(3*t).squareRoot())
        
        
        //makes the timer not get messed up
        if(seconds<10 && minutes<10){
            label.text="0\(minutes):0\(Int(seconds))"
        }
        else if(seconds>10 && minutes<10){
            label.text="0\(minutes):\(Int(seconds))"
        }
        if(seconds<10 && minutes>10){
            label.text="\(minutes):0\(Int(seconds))"
        }
        if(seconds>10 && minutes>10){
            label.text="\(minutes):\(Int(seconds))"
        }

    }
    
    
    
    //when you tap the ball it calculates where to send it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        
        
        for i in 0..<balls.count{
            let x = balls[i].position.x - location.x
            let y = balls[i].position.y - location.y
            let squareDist = x * x + y * y;
            if (squareDist <= 2500.0) {
                
                run(SKAction.playSoundFileNamed("ball-kick", waitForCompletion: false))

                
                
                
                balls[i].physicsBody?.applyTorque(0.5)
                
                
                balls[i].physicsBody?.applyImpulse(CGVector(dx: 43.3 * x * sqrt(t / squareDist), dy: 77.9 * y * sqrt(t / squareDist) + 100.0))
            }
            
        }
        
        
        
        //reset button is added
        if(reset != nil){
            if reset.frame.contains(location){
                removeAllChildren()
                var newScene: SKScene {
                    let scene = BallJuggler(size: self.size);
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
    
    
    //gets seconds and minutes
    func getSeconds() -> Double {
        return seconds
    }
    
    func getMinutes() -> Int {
        return minutes
    }
    
    
    
    //what happens if the ball hits a wall or ground
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "Bottom" {
            timer?.invalidate()
            removeAllChildren()
            addChild(label)
            score.position = CGPoint(x: size.width/2, y: size.height/2)
            score.fontSize = 60
            score.text="Score:\(scoreVal)"
            addChild(score)
            
            let defaults = UserDefaults.standard;
            defaults.set((defaults.object(forKey: "Money") as? Int ?? 0) + (10 * scoreVal), forKey: "Money");
            
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
        
        
        //makes kicking sounds if the ball hits the top or sides
        else if contact.bodyA.node?.name == "Top" || contact.bodyA.node?.name == "Left" || contact.bodyA.node?.name == "Right" {
            run(SKAction.playSoundFileNamed("ball-kick", waitForCompletion: false))
        }
    }
}
