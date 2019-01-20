//
//  GameScene.swift
//  Spinny Circle
//
//  Created by Kevin Zhang on 1/18/19.
//  Copyright © 2019 Kevin Zhang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var midpoint = SKNode()
    private var block1 = SKSpriteNode(imageNamed: "semicircle")
    private var block2 = SKSpriteNode(imageNamed: "semicircle")
    private var block3 = SKSpriteNode(imageNamed: "semicircle")
    
    override func didMove(to view: SKView) {
        initStructures()
        runMainLoop()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func createPhysicsBodyBorder(border: SKSpriteNode) -> Void {
        let offsetX = border.frame.size.width *  border.anchorPoint.x
        let offsetY = border.frame.size.height * border.anchorPoint.y
        
        let path = CGMutablePath.init()
        path.move(   to: CGPoint(x: 0 -   offsetX, y: 41 - offsetY))
        path.addLine(to: CGPoint(x: 130 - offsetX, y: 41 - offsetY))
        path.addLine(to: CGPoint(x: 130 - offsetX, y: 14 - offsetY))
        path.addLine(to: CGPoint(x: 130 - offsetX, y: 1 -  offsetY))
        path.addLine(to: CGPoint(x: 0 -   offsetX, y: 1 -  offsetY))
        path.closeSubpath()
        
        border.physicsBody = SKPhysicsBody.init(polygonFrom: path)
        border.physicsBody?.affectedByGravity = false
    }
    
    func initStructures() -> Void {
        createPhysicsBodyBorder(border: block1)
        createPhysicsBodyBorder(border: block2)
        createPhysicsBodyBorder(border: block3)
        
        //let screenRect = UIScreen.main.bounds
        //self.midpoint.position = CGPoint(x: screenRect.width/2, y: screenRect.height/2)
        self.midpoint.position = CGPoint(x: 0, y: 0)
        self.block1.position = CGPoint(x: midpoint.position.x + 86.6, y: midpoint.position.y + 50)
        self.block1.zRotation = -(.pi / 4)
        self.block2.position = CGPoint(x: midpoint.position.x - 86.6, y: midpoint.position.y + 50)
        self.block2.zRotation = .pi / 4
        self.block3.position = CGPoint(x: midpoint.position.x,        y: midpoint.position.y - 100)
        
        self.midpoint.addChild(block1)
        self.midpoint.addChild(block2)
        self.midpoint.addChild(block3)
        self.addChild(midpoint)
    }
    
    func spawnCircles() -> Void {
        let screenBounds = UIScreen.main.bounds
        let circle = SKSpriteNode.init(imageNamed: "semicircle")
        circle.physicsBody = SKPhysicsBody.init(circleOfRadius: 10)
        circle.position = CGPoint(x: 0/*Int.random(in: 10...Int(screenBounds.width - 10))*/, y: Int(screenBounds.height/2))
        self.addChild(circle)
    }
    
    func runMainLoop() -> Void {
        print("here")
        self.midpoint.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        self.midpoint.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.spawnCircles()
        }, SKAction.wait(forDuration: 1.0)])))  
//        SKAction.run {
//            print("in run")
//            SKAction.repeatForever(SKAction.sequence([SKAction.run {
//                print("spawn circles")
//                self.spawnCircles()
//                }, SKAction.wait(forDuration: 1.0)]))
//        }
    }
}
