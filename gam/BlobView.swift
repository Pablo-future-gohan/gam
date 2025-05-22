//
//  GameScene.swift
//  TestForBlobGuy
//
//  Created by Scaife, Benjamin (512176) on 4/14/25.
//

import SwiftUI
import SpriteKit
import Foundation

class BlobView: SKScene, SKPhysicsContactDelegate {
    
    var blobSize: CGFloat = 25
    var eyeSize: CGFloat = 10
    
    var blob = SKShapeNode()
    var edge = SKSpriteNode()
    var eye = SKShapeNode()
    var eyeRoot = CGPoint(x: 0, y: 0)
    var eye2 = SKShapeNode()
    var eyeRoot2 = CGPoint(x: 0, y: 0)
    var pupil1 = SKShapeNode()
    var pupil2 = SKShapeNode()
    var k = 14.0
    var k2 = 50.0
    var swingPt1 = CGPoint(x: 0, y: 0)
    var swingPt2 = CGPoint(x: 0, y: 0)
    var swingLink1 = CGPoint(x: 0, y: 0)
    var swingLink2 = CGPoint(x: 0, y: 0)
    
    var hat = SKSpriteNode()
    var hatRoot = CGPoint(x: 0, y: 0)
    
    var hat2 = SKSpriteNode()
    var hatRoot2 = CGPoint(x: 0, y: 0)
    
    var eyeDist = 20.0
    var pupilFac = 0.5
    
    var swing1 = SKShapeNode()
//    var rope1 = SKShapeNode()
//    var rope2 = SKShapeNode()
    var ropePath = CGMutablePath()
    var line1 = SKShapeNode()
    var line2 = SKShapeNode()
    
    var heldDownPos = CGPoint(x: 0, y: 0)
    var holdingBlob = false
    var dragDist = 0.0
    var mousePos = CGPoint(x: 0, y: 0)
    
    var defaults = UserDefaults.standard
    let colorKey = [UIColor.blue, UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.cyan, UIColor.purple, UIColor(red: 1, green: 0.7, blue: 0.8, alpha: 1)]
    
    let pi = 3.14159265

    override func sceneDidLoad() {
        
        swingPt1 = CGPoint(x: size.width * 0.6, y: size.height)
        swingPt2 = CGPoint(x: size.width * 0.4, y: size.height)
        
        blob = SKShapeNode(circleOfRadius: blobSize)
        blob.fillColor = colorKey[((defaults.object(forKey: "IsEquipped") as? [[Bool]] ?? [[]])[0].firstIndex(of: true) ?? -1) + 1]
        blob.position = CGPoint(x: size.width / 2, y: size.height / 2)
        blob.physicsBody = SKPhysicsBody(circleOfRadius: blobSize)
        blob.physicsBody?.collisionBitMask = 1
        blob.physicsBody?.categoryBitMask = 1
        blob.physicsBody?.contactTestBitMask = 1
        blob.physicsBody?.angularDamping = 0.5
        blob.name = "blob"
        addChild(blob)

        
        eyeRoot = CGPoint(x: size.width / 2 + eyeDist, y: size.height / 2)
        eye = SKShapeNode(circleOfRadius: eyeSize)
        eye.fillColor = .white
        eye.position = eyeRoot
        eye.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: eyeSize * 2, height: eyeSize * 2))
        eye.physicsBody?.collisionBitMask = 2
        eye.physicsBody?.categoryBitMask = 2
        eye.physicsBody?.contactTestBitMask = 2
        eye.physicsBody?.linearDamping = 25
        eye.physicsBody?.allowsRotation = true
        eye.physicsBody?.affectedByGravity = true
        eye.name = "eye1"
        addChild(eye)
        
        eyeRoot2 = CGPoint(x: size.width / 2 - eyeDist, y: size.height / 2)
        eye2 = SKShapeNode(circleOfRadius: eyeSize)
        eye2.fillColor = .white
        eye2.position = eyeRoot2
        eye2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: eyeSize * 2, height: eyeSize * 2))
        eye2.physicsBody?.collisionBitMask = 2
        eye2.physicsBody?.categoryBitMask = 2
        eye2.physicsBody?.contactTestBitMask = 2
        eye2.physicsBody?.linearDamping = 30
        eye2.physicsBody?.allowsRotation = true
        eye2.physicsBody?.affectedByGravity = true
        eye2.name = "eye2"
        addChild(eye2)
        
        pupil1 = SKShapeNode(circleOfRadius: eyeSize * pupilFac)
        pupil1.fillColor = .black
        pupil1.position = eyeRoot
        pupil1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: eyeSize * 2 * pupilFac, height: eyeSize * 2 * pupilFac))
        pupil1.physicsBody?.collisionBitMask = 4
        pupil1.physicsBody?.categoryBitMask = 4
        pupil1.physicsBody?.contactTestBitMask = 4
        pupil1.physicsBody?.linearDamping = 25
        pupil1.physicsBody?.allowsRotation = true
        pupil1.physicsBody?.affectedByGravity = true
        pupil1.name = "pupil1"
        addChild(pupil1)
        
        pupil2 = SKShapeNode(circleOfRadius: eyeSize * pupilFac)
        pupil2.fillColor = .black
        pupil2.position = eyeRoot2
        pupil2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: eyeSize * 2 * pupilFac, height: eyeSize * 2 * pupilFac))
        pupil2.physicsBody?.collisionBitMask = 4
        pupil2.physicsBody?.categoryBitMask = 4
        pupil2.physicsBody?.contactTestBitMask = 4
        pupil2.physicsBody?.linearDamping = 30
        pupil2.physicsBody?.allowsRotation = true
        pupil2.physicsBody?.affectedByGravity = true
        pupil2.name = "pupil2"
        addChild(pupil2)
        
        
        hatRoot = CGPoint(x: size.width / 2, y: size.height / 2 + (blobSize - 10))
        hat = SKSpriteNode(imageNamed: "hat1")
        hat.xScale = 0.01
        hat.yScale = 0.01
        hat.position = hatRoot
        hat.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
        hat.physicsBody?.collisionBitMask = 16
        hat.physicsBody?.categoryBitMask = 16
        hat.physicsBody?.contactTestBitMask = 16
        hat.physicsBody?.linearDamping = 45
        hat.physicsBody?.allowsRotation = true
        hat.physicsBody?.affectedByGravity = true
        hat.name = "hat"
        addChild(hat)
        
        hatRoot2 = CGPoint(x: size.width / 2, y: size.height / 2 + (blobSize - 10))
        hat2 = SKSpriteNode(imageNamed: "hat2")
        hat2.xScale = 0.1
        hat2.yScale = 0.1
        hat2.position = hatRoot
        hat2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
        hat2.physicsBody?.collisionBitMask = 16
        hat2.physicsBody?.categoryBitMask = 16
        hat2.physicsBody?.contactTestBitMask = 16
        hat2.physicsBody?.linearDamping = 45
        hat2.physicsBody?.allowsRotation = true
        hat2.physicsBody?.affectedByGravity = true
        hat2.name = "hat"
        addChild(hat2)
        
        swing1 = SKShapeNode(rectOf: CGSize(width: 100, height: 10))
        swing1.fillColor = .brown
        swing1.position = CGPoint(x: 200, y: size.height - 500)
        swing1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 10))
        swing1.physicsBody?.collisionBitMask = 1
        swing1.physicsBody?.categoryBitMask = 1
        swing1.physicsBody?.contactTestBitMask = 1
        swing1.physicsBody?.linearDamping = 0.6
        swing1.physicsBody?.angularDamping = 2.5
        swing1.physicsBody?.mass = 2
        addChild(swing1)
        
        swingLink1 = swing1.convert(CGPoint(x: 40, y: 0), to: scene!)
        swingLink2 = swing1.convert(CGPoint(x: -40, y: 0), to: scene!)
        line1 = SKShapeNode(path: ropePath)
        line1.strokeColor = .brown
        line1.lineWidth = 5
        addChild(line1)
        
        line2 = SKShapeNode(path: ropePath)
        line2.strokeColor = .brown
        line2.lineWidth = 5
        addChild(line2)
        
        
        edge = SKSpriteNode()
        edge.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        edge.physicsBody?.collisionBitMask = 1
        edge.physicsBody?.categoryBitMask = 1
        edge.physicsBody?.contactTestBitMask = 1
        
        addChild(edge)
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        heldDownPos = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        mousePos = location
        dragDist = sqrt(pow(location.x - heldDownPos.x, 2) + pow(location.y - heldDownPos.y, 2))
        if dragDist > 30 && sqrt(pow(blob.position.x - heldDownPos.x, 2) + pow(blob.position.y - heldDownPos.y, 2)) < blobSize * 2 {
            holdingBlob = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let location = touch.location(in: self)
        
        if !holdingBlob {
            let nodes = nodes(at: heldDownPos)
            
            for node in nodes {
                if ["blob", "eye1", "eye2"].contains(node.name) {
                    blob.physicsBody?.applyImpulse(CGVector(dx: CGFloat.random(in: -100...100), dy: CGFloat.random(in: 50...200)))
                }
            }
        }
        else {
            holdingBlob = false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let xOffset = eyeDist * CGFloat(cos(blob.zRotation))
        let yOffset = eyeDist * CGFloat(sin(blob.zRotation))
        let xOffset2 = eyeDist * CGFloat(cos(blob.zRotation + (pi / 2)))
        let yOffset2 = eyeDist * CGFloat(sin(blob.zRotation + (pi / 2)))
        let j = k * 0.19
        let l = k * 0.67
        swingLink1 = swing1.convert(CGPoint(x: 40, y: 0), to: scene!)
        swingLink2 = swing1.convert(CGPoint(x: -40, y: 0), to: scene!)
        eye.physicsBody?.applyForce(CGVector(dx: k * -1.0 * (eye.position.x - blob.position.x - xOffset),
                                             dy: k * -1.0 * (eye.position.y - blob.position.y - yOffset)))
        eye2.physicsBody?.applyForce(CGVector(dx: k * -1.0 * (eye2.position.x - blob.position.x + xOffset),
                                             dy: k * -1.0 * (eye2.position.y - blob.position.y + yOffset)))
        pupil1.physicsBody?.applyForce(CGVector(dx: j * -1.0 * (pupil1.position.x - blob.position.x - xOffset * 0.935),
                                                dy: j * -1.0 * (pupil1.position.y - blob.position.y - yOffset)))
        pupil2.physicsBody?.applyForce(CGVector(dx: j * -1.0 * (pupil2.position.x - blob.position.x + xOffset * 0.935),
                                                dy: j * -1.0 * (pupil2.position.y - blob.position.y + yOffset)))
        hat.physicsBody?.applyForce(CGVector(dx: l * -1.0 * (hat.position.x - blob.position.x - xOffset2 * 2),
                                                dy: l * -1.0 * (hat.position.y - blob.position.y - yOffset2 * 2)))
        hat2.physicsBody?.applyForce(CGVector(dx: l * -1.0 * (hat.position.x - blob.position.x - xOffset2 * 2),
                                                dy: l * -1.0 * (hat.position.y - blob.position.y - yOffset2 * 2)))
        hat.zRotation = blob.zRotation
        hat2.zRotation = blob.zRotation
        // temporarily testing w/o exponent for the force so for now i just have it set as 1
        swing1.physicsBody?.applyForce(CGVector(dx: ((swingLink1.x - swingPt1.x)/distance(swingLink1, swingPt1)) * pow(500 - max(500,                                                 distance(swingLink1, swingPt1)), 1) * k2,
                                                dy: ((swingLink1.y - swingPt1.y)/distance(swingLink2, swingPt2)) * pow(500 - max(500, distance(swingLink1, swingPt1)), 1) * k2), at: swingLink1)
        swing1.physicsBody?.applyForce(CGVector(dx: ((swingLink2.x - swingPt2.x)/distance(swingLink2, swingPt2)) * pow(500 - max(500,                                                 distance(swingLink2, swingPt2)), 1) * k2,
                                                dy: ((swingLink2.y - swingPt2.y)/distance(swingLink2, swingPt2)) * pow(500 - max(500, distance(swingLink2, swingPt2)), 1) * k2), at: swingLink2)
//        print(distance(swingLink2, swingPt2))
//        print(((swingLink1.y - swingPt1.y)/distance(swingLink2, swingPt2)) * (500 - max(500, distance(swingLink1, swingPt1))))


//        drawLine(from: swingLink1, to: swingPt1)
//        drawLine(from: swingLink2, to: swingPt2)
        
        ropePath = CGMutablePath()
        ropePath.move(to: swingLink1)
        ropePath.addLine(to: swingPt1)
        line1.path = ropePath
        ropePath = CGMutablePath()
        ropePath.move(to: swingLink2)
        ropePath.addLine(to: swingPt2)
        line2.path = ropePath

//        ropePath.move(to: swingLink2)
//        ropePath.addLine(to: swingPt2)
//        addChild(line)
        
        
        if holdingBlob {
            blob.physicsBody?.velocity = CGVector(dx: (mousePos.x - blob.position.x) * 60, dy: (mousePos.y - blob.position.y) * 60)
        }
        
        // i could not for the life of me figure out how to have a reference to blobview and use onappear to call this only
        // when this view is switched to so for now we're calling it every frame lmfaoo
        updateColor()
        updateFurniture()
        updateHats()
    }
    
    func updateColor() {
        blob.fillColor = colorKey[((defaults.object(forKey: "IsEquipped") as? [[Bool]] ?? [[]])[0].firstIndex(of: true) ?? -1) + 1]
    }
    
    func updateFurniture() {
        let isSwingEquipped = (defaults.object(forKey: "IsEquipped") as? [[Bool]] ?? [[false]])[2][0]
        swing1.isHidden = !isSwingEquipped
        swing1.physicsBody?.collisionBitMask = isSwingEquipped ? 1 : 8
        swing1.physicsBody?.categoryBitMask = isSwingEquipped ? 1 : 8
        swing1.physicsBody?.contactTestBitMask = isSwingEquipped ? 1 : 8
        line1.isHidden = !isSwingEquipped
        line2.isHidden = !isSwingEquipped
    }
    
    func updateHats() {
        hat.isHidden = !(defaults.object(forKey: "IsEquipped") as? [[Bool]] ?? [[false]])[1][0]
        hat2.isHidden = !(defaults.object(forKey: "IsEquipped") as? [[Bool]] ?? [[false]])[1][1]
    }
    
    func distance(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        return sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2))
    }
    

    

}
