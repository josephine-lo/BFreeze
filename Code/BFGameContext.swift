//
//  BFGameContext.swift
//  BFreeze
//
//  Created by jlo on 10/30/24.
//

import Combine
import GameplayKit

class BFGameContext: GameContext {
    var gameScene: BFGameScene? {
        scene as? BFGameScene
    }
    let gameMode: GameModeType
    let gameInfo: BFGameInfo
    var layoutInfo: BFLayoutInfo = .init(screenSize: .zero)
    
    private(set) var stateMachine: GKStateMachine?
    
    init(dependencies: Dependencies, gameMode: GameModeType) {
        self.gameInfo = BFGameInfo()
        self.gameMode = gameMode
        super.init(dependencies: dependencies)
    }
    
    func updateLayoutInfo(withScreenSize size: CGSize) {
        layoutInfo = BFLayoutInfo(screenSize: size)
    }
    
    func configureStates() {
        guard let gameScene else { return }
        print("did configure states")
        stateMachine = GKStateMachine(states: [
            BFGameIdleState(scene: gameScene, context: self),
            BFGamePlayingState(scene: gameScene, context: self),
            BFGameOverState(scene: gameScene, context: self)
        ])
//        stateMachine?.enter(BFGameIdleState.self)
    }
    
}
