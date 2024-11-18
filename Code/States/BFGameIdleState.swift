//
//  BFGameIdleState.swift
//  BFreeze
//
//  Created by jlo on 11/6/24.
//

import GameplayKit



class BFGameIdleState: GKState {
    weak var scene: BFGameScene?
    weak var context: BFGameContext?
    var playButton: SKLabelNode!
    var instructionsLabel: SKLabelNode!
    
    
    init(scene: BFGameScene, context: BFGameContext) {
        self.scene = scene
        self.context = context
        super.init()
//        setupIdleState()
    }
    
    func setupIdleState() {
        guard let scene = scene else { return }

        playButton = SKLabelNode(fontNamed: "Helvetica")
        playButton.text = "Play"
        playButton.fontSize = 36
        playButton.fontColor = .green
        playButton.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        //playButton.position = CGPoint(x: context?.layoutInfo.screenSize / 2, y: context?.layoutInfo.screenSize / 2)
        playButton.name = "playButton"
        scene.addChild(playButton)
        print("Play button added at position: \(playButton.position)")

//        showIdleInstructions()
    }


    func showIdleInstructions() {
        guard let scene = scene else { return }

        instructionsLabel = SKLabelNode(fontNamed: "Helvetica")
        instructionsLabel.text = "Tap Play to Begin"
        instructionsLabel.fontSize = 24
        instructionsLabel.fontColor = .white
        instructionsLabel.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY - 50)
        instructionsLabel.name = "instructionsLabel"
        scene.addChild(instructionsLabel)
    }
    
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is BFGamePlayingState.Type || stateClass is BFGameOverState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        print("did enter idle state")
        setupIdleState()
        showIdleInstructions()
    }
    
//    func handleTouch(_ touch: UITouch) {
//        let location = touch.location(in: scene!)
//
//        if let playButton = playButton, playButton.contains(location) {
//            stateMachine?.enter(BFGamePlayingState.self)
//        }
//    }
    
//    func handleTouch(_ touch: UITouch) {
//        let location = touch.location(in: scene!)
//
//        if let playButton = playButton, playButton.contains(location) {
//            print("Play button pressed")
//            stateMachine?.enter(BFGamePlayingState.self)
//        } else {
//            print("Touched at \(location), but not on play button")
//        }
//    }
    
    func handleTouch(_ touch: UITouch) {
        let location = touch.location(in: scene!)
        print("Touch location: \(location)")

        if let playButton = playButton {
//            print("Play button frame: \(playButton.frame)")
            if playButton.contains(location) {
//                print("Play button pressed")
                stateMachine?.enter(BFGamePlayingState.self)
            } else {
                print("Touched outside play button")
            }
        }
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
    
    

//    func handleTouchEnded() {
//        print("touched ended")
//    }
    
}
