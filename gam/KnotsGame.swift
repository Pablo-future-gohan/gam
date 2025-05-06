//
//  KnotsGame.swift
//  Knots
//
//  Created by Meccia, Augustine (512128) on 4/21/25.
//

import SwiftUI
import SpriteKit

class KnotsGame: SKScene {
    let yarnRadius: Double = 25.0;
    var points: [SKNode] = [];
    var dragIdx: Int = -1;
    var lineys: [(Int, Int, SKNode)] = []; // Ints are indices from points[]
    var winning: Bool = false;
    var timeText: SKLabelNode = SKLabelNode(text: "30.00");
    var prevTime: Double = 0.0;
    var timeLeft: Double = 60.0;
    var startTime: Double = 0.0;
    var score: Int = 0;
    var lose: Bool = false;
    
    
    override func sceneDidLoad() {
        // timer label
        timeText.fontSize = 20;
        timeText.fontName = "Courier";
        timeText.position = CGPoint(x: frame.minX + 30, y: frame.maxY - 30);
        timeText.horizontalAlignmentMode = .left;
        addChild(timeText);
        
        createNewKnot();
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (startTime == 0.0) {
            startTime = currentTime;
            prevTime = currentTime;
        }
        
        let deltaTime: Double = currentTime - prevTime;
        timeLeft -= deltaTime;
        
        if (timeLeft <= 0.0) {
            timeLeft = 0.0;
            lose = true;
        }
            
        timeText.text = String(format: "%.2f", timeLeft);
        
        prevTime = currentTime;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return;}
        let location = touch.location(in: self);
        
        dragIdx = -1;
        for i in 0..<points.count {
            if (points[i].contains(location)) {
                dragIdx = i;
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return;}
        let location = touch.location(in: self);
        if (dragIdx >= 0) {
            points[dragIdx].position = location;
            for i in 0...lineys.count - 1 {
                if lineys[i].0 == dragIdx || lineys[i].1 == dragIdx{
                    // move the appropriate lines
                    lineys[i].2.removeFromParent();
                    var linePoints = [points[lineys[i].0].position, points[lineys[i].1].position];
                    lineys[i].2 = SKShapeNode(splinePoints: &linePoints, count: linePoints.count);
                    addChild(lineys[i].2);
                }
            }
        }
    }
    
    // custy func
    func isIntersecting(_ idxA1: Int, _ idxA2: Int, _ idxB1: Int, _ idxB2: Int, dist: Double) -> Bool {
        let A1: CGPoint = points[idxA1].position;
        let A2: CGPoint = points[idxA2].position;
        let B1: CGPoint = points[idxB1].position;
        let B2: CGPoint = points[idxB2].position;
        if (pointSegDist(A1, A2, B1) <= dist || pointSegDist(A1, A2, B2) <= dist || pointSegDist(B1, B2, A1) <= dist || pointSegDist(B1, B2, A2) <= dist) {
            return true;
        }
        let verticalA: Bool = A1.x == A2.x;
        let verticalB: Bool = B1.x == B2.x;
        let mA: Double = Double?((A2.y - A1.y) / (A2.x - A1.x)) ?? Double.nan;
        let mB: Double = Double?((B2.y - B1.y) / (B2.x - B1.x)) ?? Double.nan;
        if (verticalA && verticalB || mA == mB) {
            return false;
        }
        if (verticalA) {
            let xi: Double = mB * (A1.x - B1.x) + B1.y;
            return min(A1.y, A2.y) - dist <= xi && xi <= max(A1.y, A2.y) + dist;
        }
        if (verticalB) {
            let xi: Double = mA * (B1.x - A1.x) + A1.y;
            return min(B1.y, B2.y) - dist <= xi && xi <= max(B1.y, B2.y) + dist;
        }
        let xi: Double = (A1.y - B1.y + mB * B1.x - mA * A1.x) / (mB - mA);
        return max(min(A1.x, A2.x), min(B1.x, B2.x)) <= xi && xi <= min(max(A1.x, A2.x), max(B1.x, B2.x));
    }
    
    // custy func
    func pointSegDist(_ A1: CGPoint, _ A2: CGPoint, _ P: CGPoint) -> Double {
        var d: Double = Double.infinity;
        if (A1.y == A2.y) {
            if (min(A1.x, A2.x) < P.x && P.x < max(A1.x, A2.x)) {
                d = abs(P.y - A2.y);
            }
        } else if (A1.x == A2.x) {
            if (min(A1.y, A2.y) < P.y && P.y < max(A1.y, A2.y)) {
                d = abs(P.x - A2.x);
            }
        } else {
            let m: Double = (A2.y - A1.y) / (A2.x - A1.x);
            let xPerp: Double = (A1.y - P.y - P.x / m - m * A1.x) / (-1 / m - m);
            if (min(A1.x, A2.x) < xPerp && xPerp < max(A1.x, A2.x)) {
                let yPerp: Double = A1.y + m * (xPerp - A1.x);
                d = ((P.x - xPerp) * (P.x - xPerp) + (P.y - yPerp) * (P.y - yPerp)).squareRoot()
            }
        }
        return min(((A1.x - P.x) * (A1.x - P.x) + (A1.y - P.y) * (A1.y - P.y)).squareRoot() / 2,
        d, ((A2.x - P.x) * (A2.x - P.x) + (A2.y - P.y) * (A2.y - P.y)).squareRoot() / 2);
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dragIdx = -1;
        // win condition
        var win: Bool = true;
        for i in 0..<lineys.count {
            for j in (i+1)..<lineys.count {
                if lineys[i].0 == lineys[j].0 || lineys[i].1 == lineys[j].0 || lineys[i].0 == lineys[j].1 || lineys[i].1 == lineys[j].1 {
                    continue; // don't check lines that share an endpoint
                }
                if isIntersecting(lineys[i].0, lineys[i].1, lineys[j].0, lineys[j].1, dist: 1.0) {
                    win = false;
                }
            }
        }
        winning = win;
        if (winning) {
            // rerun code
            timeLeft += 30.0 / log(Double(score) + exp(1));
            score += 1;
            createNewKnot();
        }
    }
    
    // custy func
    func createNewKnot() {
        for i in stride(from: lineys.count - 1, to: -1, by: -1) {
            lineys[i].2.removeFromParent();
            lineys.remove(at: i);
        }
        for i in stride(from: points.count - 1, to: -1, by: -1) {
            points[i].removeFromParent();
            points.remove(at: i);
        }
        // make balls
        for _ in 0..<8 {
            points.append(SKShapeNode(circleOfRadius: yarnRadius));
        }
        for i in 0..<points.count {
            points[i].position = CGPoint(x: CGFloat.random(in: 15.0+frame.minX..<frame.maxX-15.0), y: CGFloat.random(in: frame.minY+15.0..<frame.maxY-50.0));
            addChild(points[i]);
        }
        
        // make lines
        // inner loop - idx 0 through 3
        for i in 0...3 {
            var linePoints = [points[i].position, points[i < 3 ? i+1 : 0].position];
            lineys.append((i, i < 3 ? i+1 : 0, SKShapeNode(splinePoints: &linePoints, count: linePoints.count)));
        }
        // outer loop - idx 4 through 7
        for i in 0...3 {
            var linePoints = [points[i + 4].position, points[i < 3 ? i+5 : 4].position];
            lineys.append((i + 4, i < 3 ? i+5 : 4, SKShapeNode(splinePoints: &linePoints, count: linePoints.count)));
        }
        // connections between inner and outer
        var outerIdx = 4;
        for i in 0...3 {
            for j in outerIdx...Int.random(in: outerIdx...7) {
                var linePoints = [points[i].position, points[j].position];
                lineys.append((i, j, SKShapeNode(splinePoints: &linePoints, count: linePoints.count)));
                outerIdx = j;
            }
        }
        // inner loop - maybe one extra connection?
        if (Bool.random()) {
            var linePoints = [points[0].position, points[2].position];
            lineys.append((0, 2, SKShapeNode(splinePoints: &linePoints, count: linePoints.count)));
        }
        // add the line nodes
        for i in 0..<lineys.count {
            addChild(lineys[i].2);
        }
    }
}
