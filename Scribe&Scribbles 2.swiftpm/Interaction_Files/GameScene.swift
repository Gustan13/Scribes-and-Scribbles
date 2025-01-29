//
//  GameScene.swift
//  Zakuski
//
//  Created by Gustavo Binder on 07/04/23.
//

import SpriteKit

class GameScene: SKScene {
    
    var currentState: GameState = .intro
    
    var canvas: Canvas!
    var keyboard: Keyboard!
    
    var richard = Richard()
    
    var background: Background!
    
    var dialogue = Dialogue()
    
    var canClick = true
    var timesTyped = 0
    
    let sign_1 = PopUpNode(.sign_1)
    let sign_2 = PopUpNode(.sign_2)
    let sign_3 = PopUpNode(.sign_3)
    
    var phrase: [String] = ["Man", "Food", "Bison"]
    
    let dialoguePosition = CGPoint(x: 250, y: 700)
    
    let pop = SKAudioNode(fileNamed: "Pop.m4a")
    let woosh = SKAudioNode(fileNamed: "Woosh.m4a")
    let poof = SKAudioNode(fileNamed: "Poof.m4a")
    let ini = SKAudioNode(fileNamed: "In.m4a")
    
    let backgroundSound = SKAudioNode(fileNamed: "The Entertainer.mp3")
    
    override func didMove(to view: SKView) {
        let backgroundTexture = SKTexture(imageNamed: "Background")
        let backgroundSprite = SKSpriteNode(texture: backgroundTexture)
        backgroundSound.run(SKAction.changeVolume(to: 0.25, duration: 0))
        
        backgroundSprite.zPosition = -10
        backgroundSprite.position = CGPoint(x: frame.midX, y: frame.midY)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        keyboard = Keyboard(delegate: self)
        canvas = Canvas(delegate: self)
    
        background = Background()
        
        addChild(backgroundSound)
        addChild(backgroundSprite)
        addChild(background)
        addChild(keyboard)
        addChild(canvas)
        addChild(richard)
        addChild(dialogue)
        addChild(sign_1)
        addChild(sign_2)
        addChild(sign_3)
        
        currentState = .cave
        
        background.createCave()
        keyboard.spawn()
        canvas.spawn()
        keyboard.createCaveKeys()
        background.spawnAll()
        sign_1.spawn()
        
        backgroundSound.run(SKAction.play())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (canClick) {
            return
        }
        
        if dialogue.nextDialogue() == false {
            canClick = true
            dialogue.erase()
            nextLevel()
            richard.hideRichard()
        }
    }
    
    func nextLevel() {
        
        let hide = SKAction.run {
            self.background.hideAll()
        }
        let wait = SKAction.wait(forDuration: 1.3)
        var nextChapter: SKAction = SKAction.run {}
        var sequence: SKAction
        
        switch currentState {
        case .intro:
            currentState = .cave
            nextChapter = SKAction.run {
            }
        case .cave:
            currentState = .cave_2
            self.sign_1.hide()
            self.sign_2.spawn()
            nextChapter = SKAction.run {}
        case .cave_2:
            currentState = .egypt
            self.canvas.removeAllSymbols(sound: self)
            nextChapter = SKAction.run {
                self.background.createEgypt()
                self.keyboard.createEgyptKeys()
                self.background.spawnAll()
                self.phrase = ["I", "Drink", "Water", "To", "Live"]
            }
        case .egypt:
            currentState = .phoenicia
            self.keyboard.deleteKeys()
            nextChapter = SKAction.run {
                self.background.createPhoenicia()
                self.background.spawnAll()
                self.sign_2.hide()
                self.sign_3.spawn()
                self.keyboard.createPhoeniciaKeys()
            }
        case .phoenicia:
            let wait = SKAction.wait(forDuration: 2)
            
            let transition = SKTransition.fade(withDuration: 2)
            
            let nextScene = EndingScene()
            nextScene.size = CGSize(width: 820, height: 1180)
            nextScene.scaleMode = .aspectFill
            
            keyboard.hide()
            canvas.hide()
            sign_3.hide()
            
            self.canvas.removeAllSymbols(sound: self)
            
            let nextLevel = SKAction.run {
                self.view?.presentScene(nextScene, transition: transition)
            }
            
            let sequence = SKAction.sequence([wait, nextLevel])
            backgroundSound.run(SKAction.changeVolume(to: 0, duration: 1.5))
            
            run(sequence)
        }
        
        richard.hideRichard()
        
        if (currentState == .cave || currentState == .cave_2) {
            sequence = SKAction.sequence([wait, nextChapter])
        } else {
            sequence = SKAction.sequence([hide, wait, nextChapter])
        }
        
        self.hideDeleteKey()
        
        timesTyped = 0
        
        run(sequence)
    }
}

extension GameScene: SymbolDelegate {
    
    func addSymbol(_ symbol: Symbol) {
        
        if (!canClick) {
            return
        }
        
        if canvas.symbols.isEmpty {
            showDeleteKey()
        }
        
        if canvas.symbols.count == 12 {
            return
        }
        
        timesTyped += 1
        
        canvas.addSymbol(symbol)
        
        nextLevelComplete("Pop.m4a")
    }
    
    func nextLevelComplete(_ sound: String) {
        let wait = SKAction.wait(forDuration: 1.8)
        var next: SKAction!
        
        switch(currentState) {
        case .intro:
            break
        case .cave:
            if (!canvas.verifyPhrase(phrase: phrase)) {
                playSound(sound)
                return
            }
            
            self.canvas.removeAllSymbols(sound: self)
            self.hideDeleteKey()
            
            canClick = false
            
            next = SKAction.run {
                self.dialogue.createDialogue(dialogues: [1,2,3], "D", self.dialoguePosition)
                if self.dialogue.nextDialogue() { }
                self.richard.spawnRichard(expression: .happy, yPos: 575)
            }
            
            let sequence = SKAction.sequence([wait, next])
            
            run(sequence)
        case .cave_2:
            if (timesTyped <= 3) {
                playSound(sound)
                return
            }
            
            canClick = false
            
            timesTyped = 0
            dialogue.createDialogue(dialogues: [4], "D", dialoguePosition)
            if dialogue.nextDialogue() {}
            richard.spawnRichard(expression: .think, yPos: 575)
        case .egypt:
            if (!canvas.verifyPhrase(phrase: phrase)) {
                playSound(sound)
                return
            }
            
            self.canvas.removeAllSymbols(sound: self)
            self.hideDeleteKey()
            
            canClick = false
            
            next = SKAction.run {
                self.dialogue.createDialogue(dialogues: [5,9,6], "D", self.dialoguePosition)
                if self.dialogue.nextDialogue() { }
                self.richard.spawnRichard(expression: .happy, yPos: 575)
            }
            
            let sequence = SKAction.sequence([wait, next])
            
            run(sequence)
        case .phoenicia:
            if (timesTyped <= 10) {
                playSound(sound)
                return
            }
            
            canClick = false
            
            timesTyped = 0
            dialogue.createDialogue(dialogues: [7, 8], "D", dialoguePosition)
            if dialogue.nextDialogue() {}
            richard.spawnRichard(expression: .think, yPos: 575)
        }
    }
    
    func deleteLastSymbol() {
        canvas.removeLastSymbol()
        playSound("Poof.m4a")
        if canvas.symbols.isEmpty {
            hideDeleteKey()
        }
    }
    
    func deleteSymbol(node: SymbolNode) {
        node.remove()
        canvas.removeCertainSymbol(node: node)
        nextLevelComplete("Poof.m4a")
//        playSound("Poof.m4a")
    }
    
    func hideDeleteKey() {
        let overgrow = SKAction.resize(toWidth: 232, height: 132, duration: 0.15)
        let shrink = SKAction.resize(toWidth: 99, height: 58, duration: 0.05)
        let hide = SKAction.hide()
        let sequence = SKAction.sequence([overgrow, shrink, hide])
        
        keyboard.deleteKey.run(sequence)
    }
    
    func showDeleteKey() {
        keyboard.deleteKey.run(SKAction.unhide())
        let overgrow = SKAction.resize(toWidth: 232, height: 132, duration: 0.1)
        let shrink = SKAction.resize(toWidth: 198, height: 116, duration: 0.15)
        let sequence = SKAction.sequence([overgrow, shrink])
        
        keyboard.deleteKey.run(sequence)
    }
}
