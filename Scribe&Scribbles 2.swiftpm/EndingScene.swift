//
//  EndingScene.swift
//  Zakuski
//
//  Created by Gustavo Binder on 14/04/23.
//

import SpriteKit

class EndingScene: SKScene {
    
    var richard = Richard()
    var dialogue = Dialogue()
    
    var fDialogue = FlexibleDialogue()
    
    var gameScene: Credits!
    
    var nextDialogue = 0
    
    let dialoguePosition = CGPoint(x: 400, y: 750)
    
    let firstPositions = [CGPoint(x: 400, y: 1000), CGPoint(x: 350, y: 800), CGPoint(x: 400, y: 600)]
    let thirdPositions = [CGPoint(x: 400, y: 950), CGPoint(x: 400, y: 700)]
    
    var canChange = true
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "Background2")
        let foreground = SKSpriteNode(imageNamed: "Gradient")
        
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -10
        
        foreground.position = CGPoint(x: frame.midX, y: frame.midY)
        foreground.zPosition = 10
        
        //addChild(foreground)
        addChild(fDialogue)
        addChild(background)
        addChild(richard)
        addChild(dialogue)
        
        richard.spawnRichard(expression: .normal, yPos: 200)
        richard.zPosition = 10
        
        fDialogue.create(positions: firstPositions, balloons: [1,2,3], "e")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.fade(withDuration: 1)
        
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
            fDialogue.create(positions: [CGPoint(x: 400, y: 700)], balloons: [4], "e")
        case 2:
            fDialogue.create(positions: thirdPositions, balloons: [5,6], "e")
        default:
            if canChange == false {
                return
            }
            
            gameScene = Credits()
            gameScene.size = CGSize(width: 820, height: 1180)
            gameScene.scaleMode = .aspectFill
            
            run(sequence)
            canChange = false
            
            let waiten = SKAction.wait(forDuration: 0.22)
            let hiden = SKAction.hide()
            let sequence2 = SKAction.sequence([waiten, hiden])
            
            richard.run(sequence2)
        }
        
        if canChange == false {
            return
        }
        
        if (nextDialogue == 1) {
            richard.switchRichard(.happy, yPos: 200)
        }
    }
}
