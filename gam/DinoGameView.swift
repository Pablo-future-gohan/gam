//
//  DinoGameView.swift
//

import SwiftUI
import SpriteKit

// MARK: - SwiftUI Wrapper

struct DinoGameView: View {

    @Environment(\.dismiss) var dismiss

    var body: some View {
        SpriteView(scene: makeScene())
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
    }

    private func makeScene() -> DinoGameScene {
        let scene = DinoGameScene()
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .resizeFill
        scene.onLeave = { dismiss() }
        return scene
    }
}

// MARK: - Game Scene

class DinoGameScene: SKScene, SKPhysicsContactDelegate {

    // MARK: Callback
    var onLeave: (() -> Void)?

    // MARK: Physics Categories
    private let playerMask:   UInt32 = 0b001
    private let obstacleMask: UInt32 = 0b010
    private let groundMask:   UInt32 = 0b100

    // MARK: Nodes
    private var dino       = SKSpriteNode()
    private var scoreLabel = SKLabelNode()
    private var isOnGround = false

    // MARK: State
    private var score         = 0
    private var isOver        = false
    private var obstacleSpeed = 300.0  // obstacle pixels/sec — increases over time
    private var jumpStartTime: Date?   // tracks how long the screen is held

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(white: 0.97, alpha: 1)
        physicsWorld.gravity   = CGVector(dx: 0, dy: -28)
        physicsWorld.contactDelegate = self

        buildGround()
        buildDino()
        buildScoreLabel()
        startObstacleLoop()
        startScoreLoop()
        startSpeedLoop()
    }

    // MARK: - Scene Construction

    private func buildGround() {
        // Visible ground line
        let bar = SKShapeNode(rectOf: CGSize(width: size.width * 2, height: 4))
        bar.fillColor   = .black
        bar.strokeColor = .clear
        bar.position    = CGPoint(x: size.width / 2, y: groundY)
        addChild(bar)

        // Invisible physics ground
        let ground = SKNode()
        ground.position   = CGPoint(x: size.width / 2, y: groundY - 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * 2, height: 4))
        ground.physicsBody?.isDynamic       = false
        ground.physicsBody?.categoryBitMask = groundMask
        addChild(ground)
    }

    private func buildDino() {
        dino = SKSpriteNode(color: .systemGreen, size: CGSize(width: 44, height: 52))
        dino.position = CGPoint(x: 100, y: groundY + 26)

        let pb = SKPhysicsBody(rectangleOf: dino.size)
        pb.allowsRotation    = false
        pb.restitution       = 0
        pb.friction          = 1
        pb.categoryBitMask   = playerMask
        pb.contactTestBitMask = obstacleMask | groundMask
        pb.collisionBitMask  = obstacleMask | groundMask
        dino.physicsBody = pb

        addChild(dino)
    }

    private func buildScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Courier-Bold")
        scoreLabel.fontSize  = 36
        scoreLabel.fontColor = .black
        scoreLabel.text      = "0"
        scoreLabel.position  = CGPoint(x: size.width / 2, y: size.height - 70)
        addChild(scoreLabel)
    }

    // MARK: - Game Loops

    private func startScoreLoop() {
        run(.repeatForever(.sequence([
            .wait(forDuration: 0.1),
            .run { [weak self] in
                guard let self, !self.isOver else { return }
                self.score += 1
                self.scoreLabel.text = "\(self.score)"
            }
        ])), withKey: "score")
    }

    private func startObstacleLoop() {
        run(.repeatForever(.sequence([
            .run { [weak self] in self?.spawnObstacle() },
            .wait(forDuration: Double.random(in: 1...2.8))
        ])), withKey: "spawner")
    }

    private func startSpeedLoop() {
        // Every 5 seconds increase obstacle speed slightly
        run(.repeatForever(.sequence([
            .wait(forDuration: 5),
            .run { [weak self] in
                guard let self, !self.isOver else { return }
                self.obstacleSpeed = min(self.obstacleSpeed + 20, 600)
            }
        ])), withKey: "speedup")
    }

    // MARK: - Obstacle Spawning

    private func spawnObstacle() {
        guard !isOver else { return }

        let height   = CGFloat.random(in: 20...95)
        let obstacle = SKSpriteNode(color: .systemRed, size: CGSize(width: 30, height: height))
        obstacle.position = CGPoint(x: size.width + 40, y: groundY + height / 2)

        let pb = SKPhysicsBody(rectangleOf: obstacle.size)
        pb.isDynamic         = false
        pb.categoryBitMask   = obstacleMask
        pb.contactTestBitMask = playerMask
        pb.collisionBitMask  = playerMask
        obstacle.physicsBody = pb

        addChild(obstacle)

        let travel = size.width + 100
        let duration = travel / obstacleSpeed

        obstacle.run(.sequence([
            .moveBy(x: -travel, y: 0, duration: duration),
            .removeFromParent()
        ]))
    }

    // MARK: - Input

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        if isOver {
            handleGameOverTap(at: touch.location(in: self))
            return
        }

        if isOnGround {
            isOnGround    = false
            jumpStartTime = Date()
            // Start with the minimum jump velocity immediately
            dino.physicsBody?.velocity = CGVector(dx: 0, dy: 1100)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isOver, let start = jumpStartTime else { return }
        jumpStartTime = nil

        // Cap hold at 0.3s, map to a small extra velocity range (0–60)
        let held  = min(Date().timeIntervalSince(start), 0.3)
        let bonus = (held / 0.3) * 60.0

        // Only boost if still rising — clamp so we never exceed max velocity
        if let vy = dino.physicsBody?.velocity.dy, vy > 0 {
            dino.physicsBody?.velocity = CGVector(dx: 0, dy: min(vy + bonus, 440))
        }
    }

    private func handleGameOverTap(at point: CGPoint) {
        let tapped = nodes(at: point)
        for node in tapped {
            if node.name == "restart" { restartGame(); return }
            if node.name == "home"    { onLeave?();    return }
        }
    }

    // MARK: - Collision

    func didBegin(_ contact: SKPhysicsContact) {
        let masks = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        // Dino landed on ground
        if masks == playerMask | groundMask {
            isOnGround = true
            return
        }

        // Dino hit obstacle
        if masks == playerMask | obstacleMask, !isOver {
            triggerGameOver()
        }
    }

    // MARK: - Game Over

    private func triggerGameOver() {
        isOver = true

        // Stop all movement
        removeAction(forKey: "spawner")
        removeAction(forKey: "score")
        removeAction(forKey: "speedup")

        // Stop all obstacles
        children.forEach { node in
            if let s = node as? SKSpriteNode,
               s.physicsBody?.categoryBitMask == obstacleMask {
                s.removeAllActions()
            }
        }

        // Bank money
        let defaults = UserDefaults.standard;
        defaults.set((defaults.object(forKey: "Money") as? Int ?? 0) + (score), forKey: "Money");


        showGameOverUI()
    }

    private func showGameOverUI() {
        // Dim overlay
        let overlay = SKShapeNode(rectOf: size)
        overlay.fillColor   = SKColor(white: 0, alpha: 0.35)
        overlay.strokeColor = .clear
        overlay.position    = CGPoint(x: size.width / 2, y: size.height / 2)
        overlay.zPosition   = 10
        addChild(overlay)

        // "GAME OVER" title
        let title = SKLabelNode(fontNamed: "Courier-Bold")
        title.text      = "GAME OVER"
        title.fontSize  = 52
        title.fontColor = .white
        title.position  = CGPoint(x: size.width / 2, y: size.height / 2 + 60)
        title.zPosition = 11
        addChild(title)

        // Final score
        let finalScore = SKLabelNode(fontNamed: "Courier")
        finalScore.text      = "Score: \(score)   +\(score) dollars"
        
        
        
        finalScore.fontSize  = 26
        finalScore.fontColor = SKColor(white: 0.9, alpha: 1)
        finalScore.position  = CGPoint(x: size.width / 2, y: size.height / 2 + 10)
        finalScore.zPosition = 11
        addChild(finalScore)

        // Restart button
        addButton(
            label:    "Restart",
            name:     "restart",
            color:    .systemBlue,
            position: CGPoint(x: size.width / 2 - 100, y: size.height / 2 - 70)
        )

        // Home button
        addButton(
            label:    "Home",
            name:     "home",
            color:    .systemRed,
            position: CGPoint(x: size.width / 2 + 100, y: size.height / 2 - 70)
        )
    }

    private func addButton(label: String, name: String, color: SKColor, position: CGPoint) {
        let bg = SKSpriteNode(color: color, size: CGSize(width: 140, height: 50))
        bg.position  = position
        bg.zPosition = 11
        bg.name      = name
        addChild(bg)

        let text = SKLabelNode(fontNamed: "Courier-Bold")
        text.text            = label
        text.fontSize        = 22
        text.fontColor       = .white
        text.verticalAlignmentMode = .center
        text.position        = position
        text.zPosition       = 12
        text.name            = name
        addChild(text)
    }

    // MARK: - Restart

    private func restartGame() {
        removeAllChildren()
        removeAllActions()

        score      = 0
        isOver     = false
        isOnGround = false
        obstacleSpeed = 300

        buildGround()
        buildDino()
        buildScoreLabel()
        startObstacleLoop()
        startScoreLoop()
        startSpeedLoop()
    }

    // MARK: - Helpers

    private var groundY: CGFloat { 110 }
}

#Preview {
    DinoGameView()
}
