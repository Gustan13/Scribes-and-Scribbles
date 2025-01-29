import SpriteKit

class Keyboard: SKSpriteNode {
    var delegate: SymbolDelegate
    
    var keys: [Key] = []
    
    var deleteKey: Key!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Bunda")
    }
    
    init(delegate: SymbolDelegate) {
        self.delegate = delegate
        
        let tex = SKTexture(imageNamed: "Keyboard")
        super.init(texture: tex, color: .white, size: tex.size())
        
        self.position = CGPoint(x: 410, y: -230)
        self.zPosition = -1
        
        deleteKey = Key(symbol: .delete, pos: CGPoint(x: 295, y: 230), delegate: self.delegate)
        deleteKey.isUserInteractionEnabled = true
        addChild(deleteKey)
        deleteKey.run(SKAction.hide())
        deleteKey.run(SKAction.resize(toWidth: 99, height: 58, duration: 0))
    }
    
    func spawn() {
        let rise = SKAction.move(to: CGPoint(x: 410, y: 189), duration: 0.25)
        run(rise)
    }
    
    func hide() {
        let hide = SKAction.move(to: CGPoint(x: 410, y: -230), duration: 1)
        deleteKeys()
        run(hide)
    }
    
    func createCaveKeys() {
        let symbols: [Symbol] = [.man, .bison, .water, .food]
        for (i, symbol) in symbols.enumerated() {
            let key_node = Key(symbol: symbol, pos: CGPoint(x: -60 + ((i % 2) * 120), y: -60 + (i/2) * 120), delegate: delegate)
            key_node.isUserInteractionEnabled = true
            self.addChild(key_node)
            keys.append(key_node)
        }
    }
    
    func createEgyptKeys() {
        let symbols: [Symbol] = [.I, .see, .drink, .walk, .speak, .soul, .live, .to]
        var key_node: Key!
        
        for (i, symbol) in symbols.enumerated() {
            if (i < 4) {
                key_node = Key(symbol: symbol, pos: CGPoint(x: -300 + ((i % 4) * 120) + (i / 2) * 240, y: 60), delegate: delegate)
            } else {
                let point = CGPoint(x: -300 + (((i-4) % 4) * 120) + ((i-4) / 2) * 240, y: -60)
                key_node = Key(symbol: symbol, pos: point, delegate: delegate)
            }
            key_node.isUserInteractionEnabled = true
            self.addChild(key_node)
            keys.append(key_node)
        }
    }
    
    func createPhoeniciaKeys() {
        let symbols: [Symbol] = [.w, .d, .s, .r, .n, .t, .g, .k]
        
        for (i, symbol) in symbols.enumerated() {
            let position = CGPoint(x: -200 + (i % 4) * 130, y: -60 + (i / 4) * 120)
            let keyNode = Key(symbol: symbol, pos: position, delegate: delegate)
            keyNode.isUserInteractionEnabled = true
            self.addChild(keyNode)
            keys.append(keyNode)
        }
    }
    
    func deleteKeys() {
        let wait = SKAction.wait(forDuration: 3)
        var destroy: SKAction!
        var sequence: SKAction!
        
        for key in keys {
            let body = SKPhysicsBody(rectangleOf: CGSize(width: 120, height: 120))
            body.isDynamic = true
            body.collisionBitMask = 0
            body.affectedByGravity = true
            key.physicsBody = body
            body.applyImpulse(CGVector(dx: Double.random(in: -300...300), dy: Double.random(in: 300...400)))
            key.isUserInteractionEnabled = false
            
            destroy = SKAction.run {
                key.removeFromParent()
            }
            
            sequence = SKAction.sequence([wait, destroy])
            
            key.run(sequence)
        }
    }
}
