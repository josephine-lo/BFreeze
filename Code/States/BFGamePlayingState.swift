//
//  BFGamePlayingState.swift
//  BFreeze
//
//  Created by jlo on 11/8/24.
//

import GameplayKit

class BFGamePlayingState: GKState {
    weak var scene: BFGameScene?
    weak var context: BFGameContext?
    
    init(scene: BFGameScene, context: BFGameContext) {
        self.scene = scene
        self.context = context
        super.init()
    }
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func didEnter(from previousState: GKState?) {
        print("did enter idle state")
    }
    
//    func handleTouch(_ touch: UITouch) {
//        guard let scene, let context else { return }
//        print("touched \(touch)")
//        let touchLocation = touch.location(in: scene)
//        let newBoxPos = CGPoint(x: touchLocation.x - context.layoutInfo.conveyorSize.width / 2.0,
//                                y: touchLocation.y - context.layoutInfo.conveyorSize.height / 2.0)
//        scene.conveyor?.position = newBoxPos
//    }
//    
//    func handleTouchMoved(_ touch: UITouch) {
//        guard let scene, let context else { return }
//        let touchLocation = touch.location(in: scene)
//        let newBoxPos = CGPoint(x: touchLocation.x - context.layoutInfo.conveyorSize.width / 2.0,
//                                y: touchLocation.y - context.layoutInfo.conveyorSize.height / 2.0)
//        scene.conveyor?.position = newBoxPos
//    }
//    
//
//    func handleTouchEnded() {
//        print("touched ended")
//    }
    
}
