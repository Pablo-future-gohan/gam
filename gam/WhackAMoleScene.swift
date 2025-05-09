//
//  WhackAMoleScene.swift
//  WhackAMole
//
//  Created by 3 Kings on 4/30/25.
//

import SwiftUI
import SpriteKit

class WhackAMoleScene: SKScene {
    var onGameOver: (() -> Void)?;
    let MOLE_ROWS: Int = 5;
    let MOLE_COLS: Int = 3;
    
    var time: Double = 0.0;
    var startTime: Double = 0.0;
    var timeLeft: Double = 30.0;
    var lose: Bool = false;
    var timeText: SKLabelNode = SKLabelNode(text: "30.00");
    var summonTime: Double = 2.0; // how long to wait to summon a new mole
    var score: Int = 0;
    var scoreText: SKLabelNode = SKLabelNode(text: "0");
    var timeElapsed: Double = 0.0;
    
    /* represents the grid of moles.
     0: no mole
     1: regular mole
     2: bomb mole
     */
    var moleStates: [[Int]] = [];
    var moleTimes: [[Double]] = [];
    var moles: [[SKShapeNode]] = [];
    
    override func sceneDidLoad() {
        timeText.position = CGPoint(x: bounds.minX + 30, y: bounds.maxY - 40);
        timeText.fontSize = 20;
        timeText.fontName = "Courier";
        timeText.horizontalAlignmentMode = .left;
        addChild(timeText);
        scoreText.position = CGPoint(x: bounds.maxX - 30, y: bounds.maxY - 40);
        scoreText.fontSize = 20;
        scoreText.fontName = "Courier";
        scoreText.horizontalAlignmentMode = .right;
        addChild(scoreText);
        moleStates = Array(repeating: Array(repeating: 0, count: MOLE_COLS), count: MOLE_ROWS);
        moleTimes = Array(repeating: Array(repeating: 0.0, count: MOLE_COLS), count: MOLE_ROWS);
        for i in 0...(MOLE_ROWS - 1) {
            moles.append([]);
            for j in 0...(MOLE_COLS - 1) {
                let mole: SKShapeNode = SKShapeNode(circleOfRadius: 40.0);
                mole.position = CGPoint(x: frame.midX + CGFloat(j) * 220.0 / (CGFloat(MOLE_COLS) - 1.0) - 110.0, y: frame.midY + 30.0 * CGFloat(j % 2) + CGFloat(i) * 400.0 / (CGFloat(MOLE_ROWS) - 1.0) - 210.0);
                mole.name = "mole";
                moles[i].append(mole);
                addChild(mole);
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // initialization stuff
        if (time == 0.0) {
            time = currentTime;
            startTime = currentTime;
        }
        
        // deltaTime: time since last update() call
        let deltaTime: Double = currentTime - time;
        
        // timeElapsed: time since startTime
        timeElapsed = currentTime - startTime;
        
        timeLeft -= deltaTime;
        if (timeLeft <= 0.0) {
            lose = true;
            timeLeft = 0.0;
            timeText.text = "00:00.00";
            
            // black out all moles
            for i in 0...(MOLE_ROWS - 1) {
                for j in 0...(MOLE_COLS - 1) {
                    moleStates[i][j] = 0;
                    moleTimes[i][j] = 0.0;
                    moles[i][j].fillColor = .black;
                }
            }
            
            onGameOver?();
        }
        
        if (!lose) {
            summonTime -= deltaTime;
            timeText.text = "\(Int(timeLeft) / 600)\(Int(timeLeft) % 600 / 60):\(Int(timeLeft) % 60 / 10)" + String(format: "%.2f", timeLeft.truncatingRemainder(dividingBy: 10.0));
            
            // mole decay logic
            for i in 0...(MOLE_ROWS - 1) {
                for j in 0...(MOLE_COLS - 1) {
                    if (moleTimes[i][j] > deltaTime) {
                        moleTimes[i][j] -= deltaTime;
                    } else {
                        if (moleStates[i][j] == 1) {
                            timeLeft -= pow(timeElapsed, 0.05);
                        }
                        moleStates[i][j] = 0;
                        moleTimes[i][j] = 0.0;
                        moles[i][j].fillColor = .black;
                    }
                }
            }
            
            // mole summon logic
            if (summonTime <= 0.0) {
                var keepSummoning: Bool = true;
                summonTime = pow(Double.random(in: 0.0..<1.0), 0.3) * 2.6 / pow(timeElapsed + 1.0, 0.05);
                while (keepSummoning) {
                    var moleRow: Int = Int.random(in: 0..<MOLE_ROWS);
                    var moleCol: Int = Int.random(in: 0..<MOLE_COLS);
                    var counter: Int = 0; // to ensure that we don't try to generate too many
                    /// TODO: check for zeroes directly after exceeding counter
                    while (moleStates[moleRow][moleCol] != 0 && counter < 100) {
                        moleRow = Int.random(in: 0..<MOLE_ROWS);
                        moleCol = Int.random(in: 0..<MOLE_COLS);
                        counter += 1;
                    }
                    if (counter < 100) {
                        if (Double.random(in: 0.0..<1.0) < 0.88) {
                            moleStates[moleRow][moleCol] = 1;
                            moleTimes[moleRow][moleCol] = Double.random(in: 0.75..<1.5) / pow(timeElapsed + 1.0, 0.05);
                            moles[moleRow][moleCol].fillColor = .red;
                        } else {
                            moleStates[moleRow][moleCol] = 2;
                            moleTimes[moleRow][moleCol] = Double.random(in: 3.0..<5.0) / pow(timeElapsed + 1.0, 0.05);
                            moles[moleRow][moleCol].fillColor = .blue;
                            summonTime *= 0.99;
                        }
                        keepSummoning = Double.random(in: 0.0..<1.0) < 1.0 - 1.0 / (0.06 * sqrt(timeElapsed) + 1.0);
                    } else {
                        keepSummoning = false;
                    }
                }
            }
        }
        
        // for deltaTime purposes
        time = currentTime;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let first = touches.first else {return}
        let location = first.location(in:self);
        
        for i in 0...(MOLE_ROWS - 1) {
            for j in 0...(MOLE_COLS - 1) {
                if (moles[i][j].contains(location) && moleStates[i][j] != 0) {
                    moleTimes[i][j] = 0.0;
                    moles[i][j].fillColor = .black;
                    if (moleStates[i][j] == 1) {
                        score += 1;
                        scoreText.text = "\(score)";
                        timeLeft += 2.0 / pow(timeElapsed + 1.0, 0.05);
                    } else {
                        timeLeft -= 4.0 * sqrt(timeElapsed);
                    }
                    moleStates[i][j] = 0;
                }
            }
        }
    }
}
