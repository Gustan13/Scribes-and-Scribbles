//
//  EndingScene.swift
//  Zakuski
//
//  Created by Gustavo Binder on 14/04/23.
//

import SpriteKit

enum introState {
    case menu, story
}

class IntroScene: SKScene {
    
    var currentState: introState = .menu
    
    var richard = Richard()
    
    var fDialogue = FlexibleDialogue()
    
    var gameScene: GameScene!
    
    var nextDialogue = 0
    
    let dialoguePosition = CGPoint(x: 400, y: 750)
    
    let firstPositions = [CGPoint(x: 400, y: 1000), CGPoint(x: 350, y: 800), CGPoint(x: 400, y: 600)]
    let thirdPositions = [CGPoint(x: 400, y: 900), CGPoint(x: 350, y: 700)]
    
    var canChange = true
    
    let label = SKLabelNode(text: "Touch to Continue")
    
    let title = SKSpriteNode()
    let titleTexture = SKTexture(imageNamed: "Title")
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "Background2")
        
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -10
        
        title.texture = titleTexture
        title.position = CGPoint(x: frame.midX, y: frame.midY)
        title.zPosition = 12
        
        label.zPosition = 10
        label.position = CGPoint(x: frame.minX + 175, y: frame.minY + 50)
        label.fontColor = .black
        label.fontName = "Boh"
        label.run(SKAction.fadeAlpha(to: 0, duration: 0))
        
        addChild(label)
        addChild(fDialogue)
        addChild(background)
        addChild(richard)
        addChild(title)
        
//        richard.spawnRichard(expression: .think, yPos: 200)
//        richard.zPosition = 10
//
//        fDialogue.create(positions: firstPositions, balloons: [1,2,3], "i")
        
        spawnTitle()
    }
    
    func spawnLabel() {
        let wait = SKAction.wait(forDuration: 1)
        let appear = SKAction.fadeAlpha(to: 1, duration: 1)
        
        let sequence = SKAction.sequence([wait, appear])
        
        label.run(sequence)
    }
    
    func spawnTitle() {
        title.run(SKAction.resize(toWidth: 0, height: 0, duration: 0))
        
        run(SKAction.playSoundFileNamed("Pop.m4a", waitForCompletion: false))
        
        let overgrow = SKAction.resize(toWidth: titleTexture.size().width + 75, height: titleTexture.size().height + 75, duration: 0.22)
        let shrink = SKAction.resize(toWidth: titleTexture.size().width, height: titleTexture.size().height, duration: 0.22)
        
        let sequence = SKAction.sequence([overgrow, shrink])
        title.run(sequence)
    }
    
    func hideTitle() {
        let overgrow = SKAction.resize(toWidth: titleTexture.size().width + 75, height: titleTexture.size().height + 75, duration: 0.22)
        let shrink = SKAction.resize(toWidth: 0, height: 0, duration: 0.22)
        let hide = SKAction.hide()
        
        let sequence = SKAction.sequence([overgrow, shrink, hide])
        
        title.run(sequence)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentState == .menu {
            richard.spawnRichard(expression: .think, yPos: 200)
            richard.zPosition = 10
            
            fDialogue.create(positions: firstPositions, balloons: [1,2,3], "i")
            currentState = .story
            hideTitle()
            return
        }
        
        if canChange == false {
            return
        }
        
        let transition = SKTransition.fade(withDuration: 0.75)
        
        let wait = SKAction.wait(forDuration: 2)
        let hideRichard = SKAction.run {
            self.richard.hideRichard()
        }
        
        let changeScene = SKAction.run {
            self.view?.presentScene(self.gameScene, transition: transition)
        }
        
        let sequence = SKAction.sequence([hideRichard, wait, changeScene])
        
        if (fDialogue.iterable < fDialogue.balloonAmount) {
            fDialogue.spawnNextBalloon()
            return
        }
        
        fDialogue.destroy()
        nextDialogue += 1
        
        switch(nextDialogue) {
        case 1:
            fDialogue.create(positions: firstPositions, balloons: [4,5,6], "i")
        case 2:
            fDialogue.create(positions: thirdPositions, balloons: [7,8], "i")
        case 3:
            fDialogue.create(positions: [CGPoint(x: 400, y: 750)], balloons: [9], "i")
        default:
            if canChange == false {
                return
            }
            
            gameScene = GameScene()
            gameScene.size = CGSize(width: 820, height: 1180)
            gameScene.scaleMode = .aspectFill
            
            run(sequence)
            
            canChange = false
            richard.yPos = -200
            richard.hideRichard()
            
            let waiten = SKAction.wait(forDuration: 0.1)
            let hiden = SKAction.hide()
            let sequence2 = SKAction.sequence([waiten, hiden])
            
            richard.run(sequence2)
            
            return
        }
        
        if (nextDialogue == 1) {
            richard.switchRichard(.normal, yPos: 200)
        }
        else if (nextDialogue == 2) {
            richard.switchRichard(.happy, yPos: 200)
        }
        else if (nextDialogue == 3) {
            richard.switchRichard(.think, yPos: 200)
        }
    }
}
