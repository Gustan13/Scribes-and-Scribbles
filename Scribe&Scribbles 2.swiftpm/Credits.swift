//
//  Credits.swift
//  Zakuski
//
//  Created by Gustavo Binder on 19/04/23.
//

import SpriteKit

class Credits: SKScene {
    
    let backgroundImage = SKTexture(imageNamed: "Background")
    let keyboardImage = SKTexture(imageNamed: "Keyboard")
    let credits = SKTexture(imageNamed: "Credits")
    let thankYou = SKTexture(imageNamed: "Ending")
    let restartTexture = SKTexture(imageNamed: "Key_Restart")
    
    let restart = SKSpriteNode()
    let endingLabel = SKSpriteNode()
    
    let richard = Richard()
    
    let transparent = SKAction.fadeAlpha(to: 0.25, duration: 0.1)
    let solid = SKAction.fadeAlpha(to: 1, duration: 0.1)
    let wait = SKAction.wait(forDuration: 1.25)
    
    let background = Background()
    
    var canClick = true
    
    override func didMove(to view: SKView) {
        let backgroudSprite = SKSpriteNode(texture: backgroundImage)
        backgroudSprite.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroudSprite.zPosition = -10
        
        let keyboardSprite = SKSpriteNode(texture: keyboardImage)
        keyboardSprite.position = CGPoint(x: frame.midX, y: 189)
        keyboardSprite.zPosition = 10
        
        let label = SKSpriteNode(texture: credits)
        label.position = CGPoint(x: frame.midX, y: frame.minY + 75)
        label.zPosition = 15
        label.run(SKAction.resize(toWidth: 0, height: 0, duration: 0))
        
        endingLabel.texture = thankYou
        endingLabel.position = CGPoint(x: frame.midX, y: frame.midY + 400)
        endingLabel.zPosition = 10
        endingLabel.run(SKAction.resize(toWidth: 0, height: 0, duration: 0))
        
        restart.texture = restartTexture
        restart.position = CGPoint(x: frame.midX, y: frame.minY + 200)
        restart.zPosition = 50
        restart.run(SKAction.resize(toWidth: 0, height: 0, duration: 0))
        
        addChild(backgroudSprite)
        addChild(keyboardSprite)
        addChild(restart)
        addChild(label)
        addChild(richard)
        addChild(endingLabel)
        addChild(background)
        
        richard.spawnRichard(expression: .happy, yPos: 575)
        
        spawnEndingLabel(sprite: endingLabel)
        spawnEndingLabel(sprite: restart)
        spawnEndingLabel(sprite: label)
        
        background.createEnding()
        background.spawnAll()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if restart.contains(location) && canClick == true{
            let intro = IntroScene()
            intro.size = CGSize(width: 820, height: 1180)
            intro.scaleMode = .aspectFill

            let change = SKAction.run {
                self.view?.presentScene(intro, transition: SKTransition.doorway(withDuration: 1))
            }
            
            let wait = SKAction.wait(forDuration: 0.1)

            let sequence = SKAction.sequence([transparent, wait, solid, change])
            restart.run(sequence)
            canClick = false

            background.hideAll()
            
            richard.hideRichard()
        }
    }
    
    func spawnEndingLabel(sprite: SKSpriteNode) {
        let spriteTextureSize = sprite.texture?.size()
        let overgrow = SKAction.resize(toWidth: spriteTextureSize!.width + 50, height: spriteTextureSize!.height + 50, duration: 0.22)
        let shrink = SKAction.resize(toWidth: spriteTextureSize!.width, height: spriteTextureSize!.height, duration: 0.22)
        
        let sequence = SKAction.sequence([overgrow, shrink])
        
        sprite.run(sequence)
    }
}
