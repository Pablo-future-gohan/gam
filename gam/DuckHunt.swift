//
//  GameScene.swift
//  DuckHunt
//
//  Created by Popovich, Daniel (512413) on 4/30/25.
//

import SwiftUI
import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var ball = SKSpriteNode()
    @Published var seconds=0.0
    @Published var minutes=0
    var balls: [SKSpriteNode] = []
    
    var midX = 0.0
    var midY = 0.0
    
    
    
    let score = SKLabelNode(text: "")
    var scoreVal = 0


    
    
    override func didMove(to view: SKView) {
        
        
        //This posts the score
        score.position = CGPoint(x: size.width/2, y: size.height/2+230)

        
        score.fontSize = 60
        score.text="\(scoreVal)"
        addChild(score)
        
        makeBall()
        
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        

    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)

        
        if(ball.frame.contains(location))
        {
            ball.removeFromParent()
            scoreVal+=1
            makeBall()
        }
        
        
        
        
    }
    
    
    
    
    func makeBall(){
        ball = SKSpriteNode(imageNamed:"RubberDuck")
        ball.size=CGSize(width: 100, height: 100)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        ball.physicsBody?.affectedByGravity = false

        var startX=0.0
        var startY=0.0

        let ranNum = Int.random(in: 0..<4)
        
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
        
        midX = Double.random(in: 100...frame.maxX-100)
        midY = Double.random(in: 200...325)
        
        
        ball.physicsBody?.applyImpulse(CGVector(dx: pow(Double(scoreVal), Double(1/7))*(midX-ball.position.x), dy: pow(Double(scoreVal), Double(1/7))*(midY-ball.position.y)))

        
        
        
        
    }
    
    
    

    
    
    
}
