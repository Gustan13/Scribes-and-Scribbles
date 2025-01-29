//
//  FlexibleDialogue.swift
//  Zakuski
//
//  Created by Gustavo Binder on 15/04/23.
//

import SpriteKit

class FlexibleDialogue: SKNode {

    var balloonSprites: [SKSpriteNode] = []
    var iterable = 0
    
    var balloonAmount = 0

    required init?(coder aDecoder: NSCoder) {
        fatalError("Hello")
    }
    
    override init() {
        super.init()
    }
    
    func create(positions: [CGPoint], balloons: [Int], _ type: String) {
        for (i, actualNumber) in balloons.enumerated() {
            let sprite = SKSpriteNode(imageNamed: type + "_" + String(actualNumber))
            sprite.position = positions[i]
            sprite.run(SKAction.resize(toWidth: 0, height: 0, duration: 0))
            balloonSprites.append(sprite)
        }
        balloonAmount = balloons.count
        spawnNextBalloon()
    }
    
    func spawnNextBalloon() {
        if (iterable >= balloonAmount) {
            destroy()
            return
        }
        
        print(iterable)
        addChild(balloonSprites[self.iterable])
        balloonGrow(sprite: balloonSprites[self.iterable])
        iterable += 1
    }
    
    func balloonGrow(sprite: SKSpriteNode) {
        let size = sprite.texture?.size()
        let grow = SKAction.resize(toWidth: size!.width + 50, height: size!.height + 50, duration: 0.22)
        let shrink = SKAction.resize(toWidth: size!.width, height: size!.height, duration: 0.22)
        let sequence = SKAction.sequence([grow,shrink])
        
        run(SKAction.playSoundFileNamed("Pop.m4a", waitForCompletion: false))
        
        sprite.run(sequence)
    }

    func destroyBalloon(sprite: SKSpriteNode) {
        let body = SKPhysicsBody(rectangleOf: sprite.size)
        
        let wait = SKAction.wait(forDuration: 3)
        let destroySelf = SKAction.run {
            sprite.removeFromParent()
        }
        let sequence = SKAction.sequence([wait, destroySelf])
        
        body.affectedByGravity = true
        body.isDynamic = true
        
        sprite.physicsBody = body
        
        body.applyImpulse(CGVector(dx: Double.random(in: -100...100) * 10, dy: 400))
        body.collisionBitMask = 0
        body.applyTorque(CGFloat.random(in: -100...100))
        
        run(SKAction.playSoundFileNamed("Poofy.m4a", waitForCompletion: false))
        
        sprite.run(sequence)
    }
    
    func destroy() {
        for sprite in balloonSprites {
            destroyBalloon(sprite: sprite)
            sprite.zPosition -= 1
        }
        balloonSprites.removeAll()
        iterable = 0
        balloonAmount = 0
    }
}
