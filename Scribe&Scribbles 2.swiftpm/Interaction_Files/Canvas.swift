import SpriteKit

class Canvas: SKSpriteNode {
    var symbols: [Symbol] = []
    var symbolSprites: [SymbolNode] = []
    
    var delegate: SymbolDelegate!
    
    let tex: SKTexture
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Bro?")
    }
    
    init(delegate: SymbolDelegate) {
        tex = SKTexture(imageNamed: "Canvas")
        super.init(texture: tex, color: .white, size: tex.size())
        self.zPosition = -5
        self.position = CGPoint(x: 410, y: 700) // 750
        
        run(SKAction.resize(toWidth: tex.size().width/2, height: tex.size().height/2, duration: 0))
        run(SKAction.hide())
        
        self.delegate = delegate
    }
    
    func spawn() {
        let wait = SKAction.wait(forDuration: 0.01)
        let grow_1 = SKAction.resize(toWidth: tex.size().width + 100, height: tex.size().height + 100, duration: 0.25)
        let grow_2 = SKAction.resize(toWidth: tex.size().width, height: tex.size().height, duration: 0.25)
        let show = SKAction.unhide()
        let sequence = SKAction.sequence([wait, show, grow_1, grow_2])
        
        run(sequence)
    }
    
    func hide() {
        let grow_1 = SKAction.resize(toWidth: tex.size().width + 200, height: tex.size().height + 200, duration: 0.15)
        let grow_2 = SKAction.resize(toWidth: 0, height: 0, duration: 0.15)
        let sequence = SKAction.sequence([grow_1, grow_2])
        
        run(sequence)
    }
    
    func addSymbol(_ symbol: Symbol) {
        let symbolsCount = symbols.count
        if symbolsCount >= 12 { return }
        
        let symbolSprite = SymbolNode(imageName: symbol.imageName, delegate: delegate)
        let labelNode = SKLabelNode(text: symbol.rawValue)
        let pos = CGPoint(x: -180 + (symbolsCount % 4) * 120, y:  180 - (symbolsCount / 4) * 165)
        let labelPos = CGPoint(x: 0, y: -85)
        
        symbolSprite.spawn(pos: pos, labelNode: labelNode)
        
        labelNode.fontColor = .black
        labelNode.fontName = "BOH"
        labelNode.fontSize = 24
        labelNode.position = labelPos
        
        symbolSprite.isUserInteractionEnabled = true
        
        symbolSprites.append(symbolSprite)
        addChild(symbolSprite)
        
        symbols.append(symbol)
    }
    
    func verifyPhrase(phrase: [String]) -> Bool {
        var correctSymbols = 0
        for symbol in symbols {
            if symbol.rawValue == phrase[correctSymbols] {
                correctSymbols += 1
                continue
            }
            correctSymbols = 0
            if symbol.rawValue == phrase[correctSymbols] {
                correctSymbols += 1
            }
        }
        
        print(correctSymbols)
        
        if correctSymbols >= phrase.count {
            return true
        }
        return false
    }
    
    func removeLastSymbol() {
        if symbols.isEmpty {
            return
        }
        
        symbols.removeLast()
        
        guard let symbolSprite = symbolSprites.last else {
            return
        }
        
        symbolSprite.remove()
        
        symbolSprites.removeLast()
    }
    
    func fixCanvas() {
        var pos: CGPoint
        
        for (i, sprite) in symbolSprites.enumerated() {
            pos = CGPoint(x: -180 + (i % 4) * 120, y:  180 - (i / 4) * 165)
            sprite.run(SKAction.move(to: pos, duration: 0.15))
        }
        
        if symbolSprites.isEmpty {
            delegate.hideDeleteKey()
        }
    }
    
    func removeCertainSymbol(node: SymbolNode) {
        for (i, sprite) in symbolSprites.enumerated() {
            if sprite == node {
                symbolSprites.remove(at: i)
                symbols.remove(at: i)
                fixCanvas()
                return
            }
        }
    }
    
    func removeAllSymbols(sound: SoundDelegate) {
        for _ in symbolSprites {
            removeLastSymbol()
        }
        sound.playSound("Pah.m4a")
    }
}
