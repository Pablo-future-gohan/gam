//
//  GameScene.swift
//  DuckHunt
//
//  Created by Popovich, Daniel (512413) on 4/30/25.
//

import SwiftUI
import SpriteKit


class DuckHunt: SKScene, SKPhysicsContactDelegate {
    var onGameOver: (() -> Void)?
    
    //Variables for the ball
    var ball = SKSpriteNode()
    @Published var seconds=0.0
    @Published var minutes=0
    var balls: [SKSpriteNode] = []
    
    var midX = 0.0
    var midY = 0.0
    var startDistance = 0.0
    
    var ranNum = 0
    var angle = 0.0
    var rot = CGFloat()
    
    
    
    let score = SKLabelNode(text: "")
    var scoreVal = 0

    //these two variables are for the reset button and go home button
    var reset: SKNode! = nil
    let resetText = SKLabelNode(text: "")
    var leave: SKNode! = nil
    let leaveText = SKLabelNode(text: "")
    
    
    override func didMove(to view: SKView) {
        
        
        //This posts the score
        score.position = CGPoint(x: size.width/2, y: size.height/2+230)

        
        score.fontSize = 60
        score.text="\(scoreVal)"
        addChild(score)
        
        makeBall()
        
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        score.text="\(scoreVal)"

        
        
        //This checks to see if the ball reaches the other side in order to show a "game over" screen
        if((pow(ball.position.x-midX, 2)+pow(ball.position.y-midY,2)).squareRoot()>startDistance+2){
            removeAllChildren()
            score.position = CGPoint(x: size.width/2, y: size.height/2)

            
            score.fontSize = 60
            score.text="Score: \(scoreVal)"
            addChild(score)
            
            //makes the two buttons at the bottom to reset the game to go to the home screen
            reset = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 44))
            reset.position = CGPoint(x:self.frame.midX-100, y:self.frame.midY-150);
            resetText.text="Restart"
            resetText.fontSize=23
            resetText.position = CGPoint(x:self.frame.midX-100, y:self.frame.midY-156);
            resetText.fontColor = .white
            resetText.fontName="PixelEmulator"
            
            
            leave = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 44))
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
        

    }
    
    
    
    //This is what happens when the person touches the duck
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)

        
        
        if(ball.frame.contains(location))
        {
            run(SKAction.playSoundFileNamed("duckSound", waitForCompletion: false))

            ball.removeFromParent()
            scoreVal+=1
            makeBall()
        }
        
        //reset button is added
        if(reset != nil){
            if reset.frame.contains(location){
                removeAllChildren()
                var newScene: SKScene {
                    let scene = DuckHunt(size: self.size);
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
    
    
    
    
    //this make the duck on a random part of the outside and then shoots it towards the middle
    func makeBall(){
        ball = SKSpriteNode(imageNamed:"imageedit_1_4661589677")
        ball.size=CGSize(width: 100, height: 100)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        ball.physicsBody?.affectedByGravity = false

        var startX=0.0
        var startY=0.0

        ranNum = Int.random(in: 0..<4)
        
        if ranNum == 0 {
            startX=Double.random(in: -60...size.width+60)
            startY = -60
            
        } else if ranNum==1{
            startX=Double.random(in: -60...size.width+60)
            startY = size.height+60

        } else if ranNum==2{
            startX = -60
            startY = Double.random(in: -60...size.height+60)
        }
        else if ranNum == 3{
            startX = size.width+60
            startY = Double.random(in: -60...size.height+60)

        }
        
        ball.position = CGPoint(x: startX, y: startY)
        addChild(ball)
        
        
        //This decides where the middle spot the duck will go is and calculates the speed the duck will travel
        midX = Double.random(in: 100...frame.maxX-100)
        midY = Double.random(in: 200...325)
        
        angle=atan2((midY - startY), (midX - startX))
        
        
        
        ball.zRotation = CGFloat((CGFloat(angle)))

        ball.physicsBody?.applyImpulse(CGVector(dx: 0.1*(midX-ball.position.x), dy: 0.1*(midY-ball.position.y)))

        
        
        
        startDistance = (pow(startX-midX, 2)+pow(startY-midY,2)).squareRoot()
        
        
        if(scoreVal > 0){
            ball.physicsBody?.applyImpulse(CGVector(dx: 0.5*pow(Double(scoreVal), Double(1/3))*(midX-ball.position.x), dy: 0.3*pow(Double(scoreVal), Double(1/4))*(midY-ball.position.y)))
        } else{
            ball.physicsBody?.applyImpulse(CGVector(dx: 0.1*(midX-ball.position.x), dy: 0.1*(midY-ball.position.y)))

        }
        
        
        
        
    }
    
    
    

    
    
    
}
