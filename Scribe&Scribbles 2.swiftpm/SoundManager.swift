//
//  SoundManager.swift
//  Zakuski
//
//  Created by Gustavo Binder on 17/04/23.
//

import SpriteKit

protocol SoundDelegate {
    func playSound(_ sound: String)
}

extension GameScene: SoundDelegate {
    func playSound(_ sound: String) {
        self.run(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
    }
}
