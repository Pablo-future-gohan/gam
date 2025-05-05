//
//  GameScene.swift
//  DuckHunt
//
//  Created by Popovich, Daniel (512413) on 4/30/25.
//

import SwiftUI
import SpriteKit


class DuckHunt: SKScene, SKPhysicsContactDelegate {
    
    
    var ball = SKSpriteNode()
    @Published var seconds=0.0
    @Published var minutes=0
    var balls: [SKSpriteNode] = []
    
    
    
    var timer: Timer?
    var t = 10.0
    let label = SKLabelNode(text: "")
    let score = SKLabelNode(text: "")
    var scoreVal = 0


    
    
    override func didMove(to view: SKView) {
        //this makes a timer which will be used to determine speed of the ball and score at the end
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.seconds+=1.0
            self.t+=1
            self.scoreVal+=1
            
            
            
            if self.seconds>=60{
                self.seconds=0.0
                self.minutes+=1
                
            }
            if self.minutes>=60{
                self.minutes=0
            }
        }
        
        
        
        //This posts the timer
        label.position = CGPoint(x: size.width/2, y: size.height/2+230)
        label.fontSize = 60
        label.text="\(minutes):\(seconds)"
        addChild(label)
        
        makeBall()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        //gravity increases via a square root function
        
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
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)

        
        if(ball.frame.contains(location))
        {
            
        }
        
        
    }
    
    
    
    
    func makeBall(){
        ball = SKSpriteNode(imageNamed:"ducko")
        ball.size=CGSize(width: 100, height: 100)
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
