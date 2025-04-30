//
//  GameScene.swift
//  TestForBlobGuy
//
//  Created by Scaife, Benjamin (512176) on 4/14/25.
//

import SwiftUI
import SpriteKit
import Foundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
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
    var eyeDist = 20.0
    var pupilFac = 0.5

    override func sceneDidLoad() {
        blob = SKShapeNode(circleOfRadius: blobSize)
        blob.fillColor = .blue
        blob.position = CGPoint(x: size.width / 2, y: size.height / 2)
        blob.physicsBody = SKPhysicsBody(circleOfRadius: blobSize)
        blob.physicsBody?.collisionBitMask = 1
        blob.physicsBody?.categoryBitMask = 1
        blob.physicsBody?.contactTestBitMask = 1
        blob.physicsBody?.angularDamping = 0.5
        blob.name = "blob"
        addChild(blob)
        
        eyeRoot = CGPoint(x: size.width / 2 - 20, y: size.height / 2)
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
        
        eyeRoot2 = CGPoint(x: size.width / 2 + 20, y: size.height / 2)
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
        
        
        edge = SKSpriteNode()
        edge.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        addChild(edge)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let nodes = nodes(at: location)
        
        for node in nodes {
            if ["blob", "eye1", "eye2"].contains(node.name) {
                blob.physicsBody?.applyImpulse(CGVector(dx: CGFloat.random(in: -100...100), dy: CGFloat.random(in: 50...200)))
//                blob.physicsBody?.applyTorque(CGFloat.random(in: -10...10))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let xOffset = eyeDist * CGFloat(cos(blob.zRotation))
        let yOffset = eyeDist * CGFloat(sin(blob.zRotation))
        let j = k * 0.19
        eye.physicsBody?.applyForce(CGVector(dx: k * -1.0 * (eye.position.x - blob.position.x - xOffset),
                                             dy: k * -1.0 * (eye.position.y - blob.position.y - yOffset)))
        eye2.physicsBody?.applyForce(CGVector(dx: k * -1.0 * (eye2.position.x - blob.position.x + xOffset),
                                             dy: k * -1.0 * (eye2.position.y - blob.position.y + yOffset)))
        pupil1.physicsBody?.applyForce(CGVector(dx: j * -1.0 * (pupil1.position.x - blob.position.x - xOffset),
                                                dy: j * -1.0 * (pupil1.position.y - blob.position.y - yOffset)))
        pupil2.physicsBody?.applyForce(CGVector(dx: j * -1.0 * (pupil2.position.x - blob.position.x + xOffset),
                                                dy: j * -1.0 * (pupil2.position.y - blob.position.y + yOffset)))
    }

}
