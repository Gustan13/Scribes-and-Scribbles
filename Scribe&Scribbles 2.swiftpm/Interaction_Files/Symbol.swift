//
//  Symbol.swift
//  Zakuski
//
//  Created by Gustavo Binder on 06/04/23.
//

import SpriteKit

enum Symbol: String {
    case delete = "Delete"
    case restart = "Restart"
    
    case man = "Man"
    case food = "Food"
    case bison = "Bison"
    case water = "Water"
    
    case see = "See"
    case I = "I"
    case drink = "Drink"
    case walk = "Walk"
    case speak = "Speak"
    case soul = "Soul"
    case live = "Live"
    case to = "To"
    
    case w = "W"
    case r = "R"
    case t = "T"
    case n = "N"
    case g = "G"
    case k = "K"
    case s = "S"
    case d = "D"
    
    var imageName: String {
        "Key_" + rawValue
    }
}

protocol SymbolDelegate {
    func addSymbol(_ symbol: Symbol)
    func deleteLastSymbol()
    func deleteSymbol(node: SymbolNode)
    func hideDeleteKey()
}

class SymbolNode: SKSpriteNode {
    
    var image: SKTexture!
    var delegate: SymbolDelegate!
    var canTouch = true
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Richard LIVES!!!")
    }
    
    init(imageName: String, delegate: SymbolDelegate) {
        image = SKTexture(imageNamed: imageName)
        self.delegate = delegate
        
        super.init(texture: image, color: .white, size: image.size())
    }
    
    func spawn(pos: CGPoint, labelNode: SKLabelNode) {
        let small = SKAction.resize(toWidth: 0, height: 0, duration: 0)
        let big1 = SKAction.resize(toWidth: 140, height: 140, duration: 0.2)
        let big2 = SKAction.resize(toWidth: 120, height: 120, duration: 0.1)
        let add = SKAction.run { self.addChild(labelNode) }
        let sequence = SKAction.sequence([small, big1, big2, add])
        
        position = pos
        zPosition += 1
        run(sequence)
    }
    
    func remove() {
        let body = SKPhysicsBody(rectangleOf: CGSize(width: 120, height: 120))
        let wait = SKAction.wait(forDuration: 4)
        let remove = SKAction.run {
            self.removeFromParent()
        }
        let sequence = SKAction.sequence([wait, remove])
        
        body.isDynamic = true
        body.affectedByGravity = true
        body.collisionBitMask = .zero
        physicsBody = body
        
        let direction = Double.random(in: -150...150)
        
        body.applyImpulse(CGVector(dx: direction, dy: Double.random(in: 300...400)))
        body.applyTorque(CGFloat(direction)/150)
        
        run(sequence)
        
        zPosition -= 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (canTouch) {
            delegate.deleteSymbol(node: self)
            canTouch = false
        }
    }
}
