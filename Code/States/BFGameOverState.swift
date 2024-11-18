//
//  BFGameOverState.swift
//  BFreeze
//
//  Created by jlo on 11/8/24.
//

import GameplayKit


class BFGameOverState: GKState {
    unowned let scene: BFGameScene
    unowned let context: BFGameContext

    init(scene: BFGameScene, context: BFGameContext) {
        self.scene = scene
        self.context = context
        super.init()
    }

    override func didEnter(from previousState: GKState?) {
        print("Game Over State Entered")
        
        clearGameElements()
        
        displayGameOverMessage()
    }

    func clearGameElements() {
        scene.removeAllChildren()
        //context.resetGame()
    }

    func displayGameOverMessage() {
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontSize = 45
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        gameOverLabel.zPosition = 10 // Ensure it's on top of other elements
        scene.addChild(gameOverLabel)

        // Optionally, add a restart button or instructions to restart the game
        let restartLabel = SKLabelNode(text: "Tap to Restart")
        restartLabel.fontSize = 30
        restartLabel.fontColor = .white
        restartLabel.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2 - 50)
        restartLabel.zPosition = 10
        scene.addChild(restartLabel)
    }


}
//
//class BFGameOverState: GKState {
//    weak var scene: BFGameScene?
//    weak var context: BFGameContext?
//    
//    init(scene: BFGameScene, context: BFGameContext) {
//        self.scene = scene
//        self.context = context
//        super.init()
//    }
//    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
//        return stateClass is BFGameIdleState.Type
//    }
//    
//    override func didEnter(from previousState: GKState?) {
//        super.didEnter(from: previousState)
//        
//        displayGameOverUI()
////        scene?.stopGameActions()
//    }
//    
//    override func willExit(to nextState: GKState) {
//        super.willExit(to: nextState)
//        
//        // Clean up the game over UI, if necessary
//        removeGameOverUI()
//    }
//    
//    
//
//    func handleTouchEnded(_ touch: UITouch) {
//        print("touched ended \(touch)")
//    }
//    
//    
//    func handleTouch(_ touch: UITouch) {
//        let location = touch.location(in: scene!)
//        
//        if let restartButton = scene?.childNode(withName: "restartButton"), restartButton.contains(location) {
//            stateMachine?.enter(BFGameIdleState.self)
//        }
//    }
//
//
//    
//    // Function to display game over UI
//    func displayGameOverUI() {
//        guard let gameScene = scene else { return }
//        
//        // Display "Game Over" label
//        let gameOverLabel = SKLabelNode(fontNamed: "Helvetica")
//        gameOverLabel.text = "Game Over"
//        gameOverLabel.fontSize = 48
//        gameOverLabel.fontColor = .red
//        gameOverLabel.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY + 50)
//        gameOverLabel.name = "gameOverLabel"
//        gameScene.addChild(gameOverLabel)
//        
//        // Display final score
//        let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
//        scoreLabel.text = "Score: \(gameScene.score)"
//        scoreLabel.fontSize = 36
//        scoreLabel.fontColor = .white
//        scoreLabel.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
//        scoreLabel.name = "scoreLabel"
//        gameScene.addChild(scoreLabel)
//        
//        // Optionally add a restart button
//        let restartButton = SKLabelNode(fontNamed: "Helvetica")
//        restartButton.text = "Restart"
//        restartButton.fontSize = 36
//        restartButton.fontColor = .green
//        restartButton.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY - 50)
//        restartButton.name = "restartButton"
//        gameScene.addChild(restartButton)
//    }
//    
//    // Function to remove game over UI when exiting the state
//    func removeGameOverUI() {
//        guard let gameScene = scene else { return }
//        
//        gameScene.childNode(withName: "gameOverLabel")?.removeFromParent()
//        gameScene.childNode(withName: "scoreLabel")?.removeFromParent()
//        gameScene.childNode(withName: "restartButton")?.removeFromParent()
//    }
//}
//
//
