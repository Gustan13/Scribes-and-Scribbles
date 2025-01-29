//
//  Richard.swift
//  Zakuski
//
//  Created by Gustavo Binder on 09/04/23.
//

import SpriteKit

enum RichardExpression: String {
    case normal = "Normal"
    case happy = "Happy"
    case think = "Think"
    
    var imageName: String {
        "Richard_" + rawValue
    }
}

class Richard: SKSpriteNode {
    
    var yPos = 0
    
    let t = SKTexture(imageNamed: RichardExpression.normal.imageName)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Richard is unavailable")
    }
    
    init() {
        super.init(texture: t, color: .white, size: t.size())
        position = CGPoint(x: 600, y: -t.size().height)
        
        zPosition = -3
        
        let goUp = SKAction.moveBy(x: 0, y: 2, duration: 0.2)
        let goDown = SKAction.moveBy(x: 0, y: -2, duration: 0.2)
        let rotateLeft = SKAction.rotate(byAngle: -0.025, duration: 1)
        let rotateRight = SKAction.rotate(byAngle: 0.025, duration: 1)
        let sequence = SKAction.sequence([goUp, rotateLeft, goDown, rotateRight])
        let repeatForever = SKAction.repeatForever(sequence)
        
        run(repeatForever)
    }
    
    func spawnRichard(expression: RichardExpression, yPos: Int) {
        self.yPos = yPos + 25
        
        texture = SKTexture(imageNamed: expression.imageName)
        
        let rise_1 = SKAction.move(to: CGPoint(x: 600, y: self.yPos), duration: 0.5)
        let sound = SKAction.playSoundFileNamed("Voosh.m4a", waitForCompletion: false)
        let rise_2 = SKAction.move(to: CGPoint(x: 600, y: yPos), duration: 0.1)
        let sequence = SKAction.sequence([sound, rise_1, rise_2])
        
        run(sequence)
    }
    
    func hideRichard() {
        let rise = SKAction.move(to: CGPoint(x: 600, y: self.yPos), duration: 0.1)
        let sound = SKAction.playSoundFileNamed("ExitVoosh.m4a", waitForCompletion: false)
        let down = SKAction.move(to: CGPoint(x: 600, y: -t.size().height), duration: 0.25)
        let sequence = SKAction.sequence([rise, sound ,down])
        
        run(sequence)
    }
    
    func switchRichard(_ nextExpression: RichardExpression, yPos: Int) {
        let hide = SKAction.run {
            self.hideRichard()
        }
        let wait = SKAction.wait(forDuration: 0.61)
        let spawn = SKAction.run {
            self.spawnRichard(expression: nextExpression, yPos: yPos)
        }
        let sequence = SKAction.sequence([hide, wait, spawn])
        
        run(sequence)
    }
}
