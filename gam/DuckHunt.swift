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
        
        midX = Double.random(in: 90...300)
        midY = Double.random(in: 100...550)
        
        
        ball.physicsBody?.applyImpulse(CGVector(dx: 0.1*(midX-ball.position.x), dy: 0.1*(midY-ball.position.y)))
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        

    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)

        
        if(ball.frame.contains(location))
        {
            
        }
        
        
        
        
    }
    
    
    
    
    func makeBall(){
        ball = SKSpriteNode(imageNamed:"RubberDuck")
        ball.size=CGSize(width: 100, height: 100)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 50)

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
        
        
    }
    
    
    

    
    
    
}
