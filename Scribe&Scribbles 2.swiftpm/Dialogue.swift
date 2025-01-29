//
//  Dialogue.swift
//  Zakuski
//
//  Created by Gustavo Binder on 10/04/23.
//

import SpriteKit

class Dialogue: SKNode {
    var numPhrases = 0
    var iter = 0
    var phrases: [SKSpriteNode] = []
    
    let continueText = SKLabelNode(text: "Touch to Continue")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Bro")
    }
    
    override init() {
        super.init()
    }
    
    func createDialogue(dialogues: [Int], _ prefix: String, _ pos: CGPoint) {
        continueText.position = CGPoint(x: pos.x, y: pos.y)
        continueText.fontSize = 24
        continueText.zPosition = -1
        continueText.fontName = "NHA"
        continueText.fontColor = .black
        continueText.run(SKAction.fadeOut(withDuration: 0))
        
        numPhrases = dialogues.count
        for i in dialogues {
            let texture = SKTexture(imageNamed: prefix + "_" + String(i))
            let dialogue = SKSpriteNode(texture: texture, size: texture.size())
            
            dialogue.position = CGPoint(x: pos.x, y: pos.y)
            dialogue.run(SKAction.resize(toWidth: texture.size().width/3, height: texture.size().height/3, duration: 0))
            
            phrases.append(dialogue)
        }
    }
    
    func deleteBalloon(balloon: SKSpriteNode) {
        let wait = SKAction.wait(forDuration: 3)
        let remove = SKAction.run {
            balloon.removeFromParent()
        }
        let sequence = SKAction.sequence([wait, remove])
        
        let body = SKPhysicsBody(rectangleOf: balloon.texture!.size())
        body.isDynamic = true
        body.affectedByGravity = true
        body.collisionBitMask = 0
        balloon.physicsBody = body
        
        body.applyImpulse(CGVector(dx: -1000, dy: 1000))
        
        balloon.zPosition = -2
        
        balloon.run(sequence)
    }
    
    func nextDialogue() -> Bool {
//        if (iter == 0) {
//            self.addChild(continueText)
//        }
        if (phrases.isEmpty) {
            return true
        }
        
        if (iter > numPhrases - 1) {
            deleteBalloon(balloon: phrases[iter - 1])
            return false
        }
        
        let textureSize = phrases[iter].texture?.size()
        
        if (iter != 0) {
            deleteBalloon(balloon: phrases[iter - 1])
            continueText.run(SKAction.fadeOut(withDuration: 0))
            continueText.removeFromParent()
        }
        
        phrases[iter].addChild(continueText)
        continueText.position = CGPoint(x: 0, y: -phrases[iter].size.height/2 - 35)
        let disappear = SKAction.run {
            self.continueText.run(SKAction.fadeOut(withDuration: 0))
        }
        let wait = SKAction.wait(forDuration: 1)
        let run = SKAction.run {
            self.continueText.run(SKAction.fadeIn(withDuration: 0))
        }
        
        let sequence2 = SKAction.sequence([disappear, wait, run])
        continueText.run(sequence2)
        
        let shrink = SKAction.resize(byWidth: 0, height: 0, duration: 0)
        let overgrow = SKAction.resize(toWidth: textureSize!.width + 50, height: textureSize!.height + 50, duration: 0.22)
        let rightSize = SKAction.resize(toWidth: textureSize!.width, height: textureSize!.height, duration: 0.22)
        
        let sound = SKAction.playSoundFileNamed("Pop.m4a", waitForCompletion: false)
        
        let sequence = SKAction.sequence([shrink, sound, overgrow, rightSize])
        
        phrases[iter].run(sequence)
        addChild(phrases[iter])
        
        iter += 1
        
        return true
    }
    
    func erase() {
        iter = 0
        numPhrases = 0
        continueText.removeFromParent()
        continueText.run(SKAction.fadeOut(withDuration: 0))
        if (!phrases.isEmpty) {
            phrases.removeAll()
        }
    }
}
