//
//  Key.swift
//  Zakuski
//
//  Created by Gustavo Binder on 06/04/23.
//

import SpriteKit

class Key: SKSpriteNode {
    var symbol: Symbol
    var delegate: SymbolDelegate
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(symbol: Symbol, pos: CGPoint, delegate: SymbolDelegate) {
        self.symbol = symbol
        self.delegate = delegate
        
        let texture = SKTexture(imageNamed: symbol.imageName)
        super.init(texture: texture, color: .white, size: texture.size())
        self.position = pos
        self.zPosition = 0
        
        var y: CGFloat = 120
        var x: CGFloat = 120
        
        if (symbol == .delete) {
            y = 116
            x = 198
        } else if (symbol == .restart) {
            print(texture.size())
        }
        
        let small = SKAction.resize(toWidth: 0, height: 0, duration: 0)
        let big1 = SKAction.resize(toWidth: x + 5, height: y + 5, duration: 0.3)
        let big2 = SKAction.resize(toWidth: x, height: y, duration: 0.1)
        let sequence = SKAction.sequence([small, big1, big2])
        
        run(sequence)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {        
        self.run(SKAction.fadeAlpha(to: 0.5, duration: 0.1))
        
        if symbol == .delete {
            delegate.deleteLastSymbol()
        } else {
            delegate.addSymbol(symbol)
        }
    }
                 
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let wait = SKAction.wait(forDuration: 0.1)
        let fade = SKAction.fadeAlpha(to: 1, duration: 0.05)
        
        let sequence = SKAction.sequence([wait, fade])
        
        self.run(sequence)
    }
}
