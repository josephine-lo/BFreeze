//
//  ContentView.swift
//  BFreeze
//
//  Created by jlo on 10/14/24.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    let context = BFGameContext(dependencies: .init(),
                                gameMode: .single)
    let screenSize: CGSize = UIScreen.main.bounds.size
    
    var body: some View {
        SpriteView(scene: BFGameScene(context: context,
                                      size: screenSize))
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
        .ignoresSafeArea()
}

