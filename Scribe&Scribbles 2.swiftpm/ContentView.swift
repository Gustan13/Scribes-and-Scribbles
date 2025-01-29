// PLEASE PLAY THIS APP IN PORTRAIT MODE

import SpriteKit
import SwiftUI

struct ContentView: View {

    var scene: SKScene {
        let scene = IntroScene()
        scene.size = CGSize(width: 820, height: 1180)
        scene.scaleMode = .aspectFill
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
            .previewInterfaceOrientation(.portrait)
    }
}
