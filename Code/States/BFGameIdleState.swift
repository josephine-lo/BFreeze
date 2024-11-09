//
//  BFGameIdleState.swift
//  BFreeze
//
//  Created by jlo on 11/6/24.
//

import GameplayKit

//class BFGameIdleState {
//    weak var scene: SKScene?
//    var playButton: SKLabelNode!
//    
//    init(scene: SKScene) {
//        self.scene = scene
//        setupIdleState()
//    }
//    
//    func setupIdleState() {
//        guard let scene = scene else { return }
//        
//        playButton = SKLabelNode(fontNamed: "Helvetica")
//        playButton.text = "Play"
//        playButton.fontSize = 36
//        playButton.fontColor = .green
//        playButton.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
//        playButton.name = "playButton"
//        scene.addChild(playButton)
//        
//        showIdleInstructions()
//    }
//    
//
//    func showIdleInstructions() {
//        guard let scene = scene else { return }
//        
//        let instructionsLabel = SKLabelNode(fontNamed: "Helvetica")
//        instructionsLabel.text = "Tap Play to Begin"
//        instructionsLabel.fontSize = 24
//        instructionsLabel.fontColor = .white
//        instructionsLabel.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY - 50)
//        instructionsLabel.name = "instructionsLabel"
//        scene.addChild(instructionsLabel)
//    }
//    
//    // Handle transitioning from idle to active state
//    func startGame() {
//        // Remove or hide idle state elements
//        playButton.removeFromParent()
//        scene?.childNode(withName: "instructionsLabel")?.removeFromParent()
//        
//        // Signal game state change, for example by setting an `isGameActive` flag in the main game controller
////        if let gameScene = scene as? BFGameScene {
////            gameScene.isGameActive = true  // Assuming GameScene has an `isGameActive` flag
////            gameScene.beginGameActions()   // Start the game actions
////        }
//    }
//}




class BFGameIdleState: GKState {
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
    
    

    func handleTouchEnded() {
        print("touched ended")
    }
    
}
