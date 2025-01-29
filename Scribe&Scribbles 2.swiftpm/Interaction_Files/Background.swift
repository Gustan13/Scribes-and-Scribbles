//
//  Background.swift
//  Zakuski
//
//  Created by Gustavo Binder on 09/04/23.
//

import SpriteKit

enum PopUpType: String {
    case doubleRock = "Rocks"
    case rock = "Rock"
    
    case pyramid = "Pyramid"
    case nile = "Nile"
    case tree = "Tree"
    
    case boat = "Boat"
    case sea = "Sea"
    case pot = "Pot"
    
    case sign_1 = "Sign_1"
    case sign_2 = "Sign_2"
    case sign_3 = "Sign_3"
    
    var imageName: String {
        rawValue
    }
    
    var movement: (position: CGPoint, yUp: CGFloat) {
        switch self {
        case .doubleRock:
            return (CGPoint(x: 150, y: -200), CGFloat(500))
        case .rock:
            return (CGPoint(x: 700, y: -200), CGFloat(475))
        case .pyramid:
            return (CGPoint(x: 150, y: -150), CGFloat(600))
        case .nile:
            return (CGPoint(x: 400, y: -100), CGFloat(500))
        case .tree:
            return (CGPoint(x: 700, y: -200), CGFloat(600))
        case .boat:
            return (CGPoint(x: 100, y: -300), CGFloat(600))
        case .sea:
            return (CGPoint(x: 200, y: -150), CGFloat(375))
        case .pot:
            return (CGPoint(x: 700, y: -200), CGFloat(500))
        case .sign_1:
            return (CGPoint(x: 410, y: 1700), CGFloat(1130)) // 1175
        case .sign_2:
            return (CGPoint(x: 410, y: 1700), CGFloat(1130))
        case .sign_3:
            return (CGPoint(x: 410, y: 1700), CGFloat(1130))
        }
    }
}

class PopUpNode: SKSpriteNode {
    
    let yDown: CGFloat
    let yUp: CGFloat
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Pump up the jam")
    }
    
    init(_ type: PopUpType) {
        yUp = type.movement.yUp
        yDown = type.movement.position.y
        
        let t = SKTexture(imageNamed: type.imageName)
        
        super.init(texture: t, color: .white, size: t.size())
        
        position = type.movement.position
        
        let randomAngle = CGFloat.random(in: 0.025...0.1)
        let randomTime = CGFloat.random(in: 1...3)
        
        let moveLeft = SKAction.rotate(byAngle: -randomAngle, duration: randomTime)
        let moveRight = SKAction.rotate(byAngle: randomAngle, duration: randomTime)
        let sequence = SKAction.sequence([moveLeft, moveRight])
        let repeatForever = SKAction.repeatForever(sequence)
        if (type != .sign_1 && type != .sign_2 && type != .sign_3) {
            run(repeatForever)
        }
    }
    
    func spawn() {
        let rise_1 = SKAction.move(to: CGPoint(x: position.x, y: yUp + (yUp - position.y)/10), duration: 0.5)
        let rise_2 = SKAction.move(to: CGPoint(x: position.x, y: yUp), duration: 0.1)
        let sequence = SKAction.sequence([rise_1, rise_2])
        
        run(sequence)
    }
    
    func hide() {
        let rise = SKAction.move(to: CGPoint(x: position.x, y: yUp + 50), duration: 0.1)
        let down = SKAction.move(to: CGPoint(x: position.x, y: yDown), duration: 0.25)
        let sequence = SKAction.sequence([rise, down])
        
        run(sequence)
    }
}

class Background: SKNode {
    var currentPopUps: [PopUpNode] = []
    
//    var delegate: SoundDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Pump it up")
    }
    
    override init() {
//        delegate = sound
        super.init()
        zPosition = -9
    }
    
    func woosh() {
        let wait = SKAction.wait(forDuration: 0.20)
        let action = SKAction.run {
//            self.delegate.playSound("Woosh.m4a")
            self.run(SKAction.playSoundFileNamed("Woosh.m4a", waitForCompletion: false))
        }
        let sequence = SKAction.sequence([wait, action])
        run(sequence)
    }
    
    func ini() {
        let wait = SKAction.wait(forDuration: 0.10)
        let action = SKAction.run {
//            self.delegate.playSound("In.m4a")
            self.run(SKAction.playSoundFileNamed("In.m4a", waitForCompletion: false))
        }
        let sequence = SKAction.sequence([wait, action])
        run(sequence)
    }
    
    func createCave() {
        currentPopUps.append(PopUpNode(.doubleRock))
        currentPopUps.append(PopUpNode(.rock))
    }
    
    func createEgypt() {
        currentPopUps.append(PopUpNode(.nile))
        currentPopUps.append(PopUpNode(.pyramid))
        currentPopUps.append(PopUpNode(.tree))
    }
    
    func createPhoenicia() {
        currentPopUps.append(PopUpNode(.boat))
        currentPopUps.append(PopUpNode(.sea))
        currentPopUps.append(PopUpNode(.pot))
    }
    
    func createEnding() {
        currentPopUps.append(PopUpNode(.nile))
        currentPopUps.append(PopUpNode(.pot))
        currentPopUps.append(PopUpNode(.doubleRock))
    }
    
    func spawnAll() {
        for (i, popUp) in currentPopUps.enumerated() {
            addChild(popUp)
            
            let wait = SKAction.wait(forDuration: Double(i)/5)
            let spawn = SKAction.run {
                popUp.spawn()
            }
            let sequence = SKAction.sequence([wait, spawn])
            
            run(sequence)
        }
        woosh()
    }
    
    func hideAll() {
        
        var actions: [SKAction] = []
        
        for popUp in currentPopUps {
            actions.append(SKAction.run {
                popUp.hide()
            })
        }
        
        actions.append(SKAction.wait(forDuration: 1))
        
        actions.append(SKAction.run {
            for popUp in self.currentPopUps {
                popUp.removeFromParent()
            }
            self.currentPopUps.removeAll()
        })
        
        run(SKAction.sequence(actions))
        ini()
    }
}
