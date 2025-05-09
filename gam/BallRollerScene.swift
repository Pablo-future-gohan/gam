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
    
    override func sceneDidLoad() {
        manager.startAccelerometerUpdates();
        ball.position = CGPoint(x: bounds.midX, y: 20);
        addChild(ball);
        timeText.position = CGPoint(x: bounds.minX + 30, y: bounds.maxY - 40);
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
                } else if (child.intersects(ball) && (
                    ball.contains(CGPoint(x: child.bounds.minX + child.position.x, y: child.bounds.maxY + child.position.y)) || // ball contains square topleft
                    ball.contains(CGPoint(x: child.bounds.maxX + child.position.x, y: child.bounds.maxY + child.position.y)) || // ball contains square topright
                    ball.contains(CGPoint(x: child.bounds.minX + child.position.x, y: child.bounds.minY + child.position.y)) || // ball contains square bottomleft
                    ball.contains(CGPoint(x: child.bounds.maxX + child.position.x, y: child.bounds.minY + child.position.y)) || // ball contains square bottomright
                    child.contains(CGPoint(x: ball.bounds.midX + ball.position.x, y: ball.bounds.maxY + ball.position.y)) || // square contains ball top
                    child.contains(CGPoint(x: ball.bounds.minX + ball.position.x, y: ball.bounds.midY + ball.position.y)) || // square contains ball left
                    child.contains(CGPoint(x: ball.bounds.maxX + ball.position.x, y: ball.bounds.midY + ball.position.y))    // square contains ball right
                )) {
                    /// TODO: make losing work, scoring system, etc.
                    backgroundColor = .red;
                    startTime = timeElapsed; // how long you lasted
                    lose = true;
                    onGameOver?();
                }
            }
        }
        
        // for deltaTime purposes
        time = currentTime;
    }
    
    /// Creates a wall of obstacles.
    /// - Parameter halfScreens: how many half-widths of the screen away from the center the obstacles can spawn.
    func createObstacle(halfScreens: Double) {
        let minX: CGFloat = bounds.midX + halfScreens * (bounds.minX - bounds.midX);
        let maxX: CGFloat = bounds.midX + halfScreens * (bounds.maxX - bounds.midX);
        /// TODO: add spawn patterns to obstacles
        for _ in 0..<Int.random(in: Int(halfScreens * 2)...Int(halfScreens * 3)) {
            let obstacle: SKShapeNode = SKShapeNode(rectOf: CGSize(width: 50, height: 50));
            obstacle.position = CGPoint(x: CGFloat.random(in: minX...maxX), y: bounds.maxY + 50 + CGFloat.random(in: 0...30));
            obstacle.name = "obstacle";
            addChild(obstacle);
        }
    }
}
