//
//  BallRollerScene.swift
//  BallRoller
//
//  Created by 3 Kings on 4/26/25.
//

import SwiftUI
import SpriteKit
import CoreMotion

class BallRollerScene: SKScene {
    var onGameOver: (() -> Void)?;
    let manager: CMMotionManager = CMMotionManager();
    var accelX: Double = 0.0;
    var ball: SKShapeNode = SKShapeNode(circleOfRadius: 10);
    var ballVelX: Double = 0.0;
    var ballVelY: Double = 0.0;
    var time: Double = 0.0;
    var startTime: Double = 0.0;
    var summonTime: Double = 0.0;
    var lose: Bool = false;
    var timeText: SKLabelNode = SKLabelNode(text: "00:00.00");
    
    //these two variables are for the reset button and go home button
    var reset: SKNode! = nil
    let resetText = SKLabelNode(text: "")
    var leave: SKNode! = nil
    let leaveText = SKLabelNode(text: "")
    
    override func sceneDidLoad() {
        manager.startAccelerometerUpdates();
        ball.position = CGPoint(x: frame.midX, y: 20);
        addChild(ball);
        timeText.position = CGPoint(x: frame.minX + 30, y: frame.maxY - 40);
        timeText.fontSize = 20;
        timeText.fontName = "Courier";
        timeText.horizontalAlignmentMode = .left;
        addChild(timeText);
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (lose) {return;}
        // initialization stuff
        if (time == 0.0) {
            time = currentTime;
            startTime = currentTime;
        }
        
        // deltaTime: time since last update() call
        let deltaTime: Double = currentTime - time;
        
        // timeElapsed: time since startTime
        let timeElapsed: Double = currentTime - startTime;
        timeText.text = "\(Int(timeElapsed) / 600)\(Int(timeElapsed) % 600 / 60):\(Int(timeElapsed) % 60 / 10)" + String(format: "%.2f", timeElapsed.truncatingRemainder(dividingBy: 10.0));
        
        // get accelerometer readings (tilt controls)
        if let data = manager.accelerometerData {
            accelX = data.acceleration.x;
        }
        
        // ball movement
        ballVelX += accelX * 20.0 * deltaTime * sqrt(timeElapsed);
        if (ballVelX <= 0.0 && accelX > 0.0 || ballVelX >= 0.0 && accelX < 0.0) {
            ballVelX *= pow(0.3, deltaTime);
        }
        let maxVelX = 20.0 * sqrt(timeElapsed + 1);
        if (ballVelX > maxVelX) {
            ballVelX = maxVelX;
        } else if (ballVelX < -maxVelX) {
            ballVelX = -maxVelX;
        }
        ballVelY = 20.0 * sqrt(timeElapsed);
        
        // obstacle creation
        summonTime -= deltaTime;
        if (summonTime <= 0.0) {
            summonTime = Double.random(in: 0.0...1.0) + 12.5 / sqrt(timeElapsed + 1);
            createObstacle(halfScreens: 1.5 * sqrt(timeElapsed + 15.0));
        }
        
        // obstacle movement
        children.forEach { child in
            if (child.name == "obstacle") {
                child.position.x -= CGFloat(ballVelX) * deltaTime;
                child.position.y -= CGFloat(ballVelY) * deltaTime;
                if (child.position.y < -50.0) {
                    child.removeFromParent();
                } else if (child.intersects(ball) && !lose && (
                    ball.contains(CGPoint(x: child.frame.minX, y: child.frame.maxY)) || // ball contains square topleft
                    ball.contains(CGPoint(x: child.frame.maxX, y: child.frame.maxY)) || // ball contains square topright
                    ball.contains(CGPoint(x: child.frame.minX, y: child.frame.minY)) || // ball contains square bottomleft
                    ball.contains(CGPoint(x: child.frame.maxX, y: child.frame.minY)) || // ball contains square bottomright
                    child.contains(CGPoint(x: ball.frame.midX, y: ball.frame.maxY)) || // square contains ball top
                    child.contains(CGPoint(x: ball.frame.minX, y: ball.frame.midY)) || // square contains ball left
                    child.contains(CGPoint(x: ball.frame.maxX, y: ball.frame.midY))    // square contains ball right
                )) {
                    let defaults = UserDefaults.standard;
                    defaults.set((defaults.object(forKey: "Money") as? Int ?? 0) + (10 * Int(timeElapsed)), forKey: "Money");
                    
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
                    startTime = timeElapsed; // how long you lasted
                    lose = true;
                }
            }
        }
        
        // for deltaTime purposes
        time = currentTime;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        if(reset != nil){
            if reset.frame.contains(location){
                removeAllChildren()
                var newScene: SKScene {
                    let scene = BallRollerScene(size: self.size);
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
    
    /// Creates a wall of obstacles.
    /// - Parameter halfScreens: how many half-widths of the screen away from the center the obstacles can spawn.
    func createObstacle(halfScreens: Double) {
        let minX: CGFloat = frame.midX + halfScreens * (frame.minX - frame.midX);
        let maxX: CGFloat = frame.midX + halfScreens * (frame.maxX - frame.midX);
        /// TODO: add spawn patterns to obstacles
        for _ in 0..<Int.random(in: Int(halfScreens * 2)...Int(halfScreens * 3)) {
            let obstacle: SKShapeNode = SKShapeNode(rectOf: CGSize(width: 50, height: 50));
            obstacle.position = CGPoint(x: CGFloat.random(in: minX...maxX), y: frame.maxY + 50 + CGFloat.random(in: 0...30));
            obstacle.name = "obstacle";
            addChild(obstacle);
        }
    }
}
