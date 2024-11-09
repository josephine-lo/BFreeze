//
//  BFGameOverState.swift
//  BFreeze
//
//  Created by jlo on 11/8/24.
//

import GameplayKit

class BFGameOverState: GKState {
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
        super.didEnter(from: previousState)
        
        displayGameOverUI()
//        scene?.stopGameActions()
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        // Clean up the game over UI, if necessary
        removeGameOverUI()
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
    
    

    func handleTouchEnded(_ touch: UITouch) {
        print("touched ended \(touch)")
    }
    


    
    // Function to display game over UI
    func displayGameOverUI() {
        guard let gameScene = scene else { return }
        
        // Display "Game Over" label
        let gameOverLabel = SKLabelNode(fontNamed: "Helvetica")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 48
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY + 50)
        gameOverLabel.name = "gameOverLabel"
        gameScene.addChild(gameOverLabel)
        
        // Display final score
        let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel.text = "Score: \(gameScene.score)"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
        scoreLabel.name = "scoreLabel"
        gameScene.addChild(scoreLabel)
        
        // Optionally add a restart button
        let restartButton = SKLabelNode(fontNamed: "Helvetica")
        restartButton.text = "Restart"
        restartButton.fontSize = 36
        restartButton.fontColor = .green
        restartButton.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY - 50)
        restartButton.name = "restartButton"
        gameScene.addChild(restartButton)
    }
    
    // Function to remove game over UI when exiting the state
    func removeGameOverUI() {
        guard let gameScene = scene else { return }
        
        gameScene.childNode(withName: "gameOverLabel")?.removeFromParent()
        gameScene.childNode(withName: "scoreLabel")?.removeFromParent()
        gameScene.childNode(withName: "restartButton")?.removeFromParent()
    }
}


