//
//  BFGameScene.swift
//  BFreeze
//
//  Created by jlo on 10/30/24.
//

import SpriteKit
import GameplayKit

class BFGameScene: SKScene {
    weak var context: BFGameContext?
    var conveyorPosition: CGPoint = CGPoint(x: 50, y: 100)
    var selectedNode: SKShapeNode?
    var scoreLabel: SKLabelNode!
    var missLabel: SKLabelNode!
    var whiteBoxNode: SKSpriteNode!
    var score: Int = 0
    var miss: Int = 0
    
    
    //    var box: BFBoxNode?
    
    var circleNode: SKShapeNode!
    var conveyor: BFConveyorNode!
    var isDragging = false
    let gridSpacing: CGFloat = 50.0
    var displayCircles: [SKShapeNode] = []
    var conveyorCircles: [SKShapeNode] = []
    
    
    
    
    let initialPositions: [UIColor: CGPoint] = [
        .red: CGPoint(x: 75, y: 100),
        .blue: CGPoint(x: 75, y: 200),
        .green: CGPoint(x: 75, y: 300)
    ]
    
    init(context: BFGameContext, size: CGSize) {
        self.context = context
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        guard let context else {
            return
        }
        
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.fontSize = 25
        scoreLabel.position = CGPoint(x: 58, y: self.size.height - 100)
        addChild(scoreLabel)
        
        missLabel = SKLabelNode(text: "Miss: \(miss)")
        missLabel.fontSize = 25
        missLabel.position = CGPoint(x: 58, y: self.size.height - 150)
        addChild(missLabel)
        
        prepareGameContext()
        //        prepareStartNodes()
        //        setupWhiteBox()
        //
        //        createDraggableCircle(fillColor: .red)
        //        createDraggableCircle(fillColor: .blue)
        //        createDraggableCircle(fillColor: .green)
        //
        //        displayRandomCircles()
        
        
        
        context.stateMachine?.enter(BFGameIdleState.self)
    }
    
    
    
    // SKShapeNode version
    //    func createDraggableCircle(fillColor: UIColor) {
    //        let circleRadius: CGFloat = 30.0
    //        let circleNode = SKShapeNode(circleOfRadius: circleRadius)
    //        circleNode.fillColor = fillColor
    //        circleNode.position = initialPositions[fillColor] ?? CGPoint(x: 0, y: 0)
    //        circleNode.zPosition = 1
    //        circleNode.name = "draggableCircle"  // Tag circles for identification
    //        addChild(circleNode)
    //    }
    //
    //    func createDisplayCircle(fillColor: UIColor, position: CGPoint) {
    //        let circleRadius: CGFloat = 30.0
    //        let circleNode = SKShapeNode(circleOfRadius: circleRadius)
    //        circleNode.fillColor = fillColor
    //        circleNode.position = position
    //        circleNode.zPosition = 1
    //        circleNode.name = "displayCircle"
    //        addChild(circleNode)
    //
    //        displayCircles.append(circleNode)
    //
    //    }
    //
    //    func removeDisplayCircles() {
    //        for circle in displayCircles {
    //            circle.removeFromParent()
    //        }
    //
    //        displayCircles.removeAll()
    //    }
    
    func prepareGameContext() {
        guard let context else {
            return
        }
        
        context.scene = self
        context.updateLayoutInfo(withScreenSize: size)
        context.configureStates()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        if let state = context?.stateMachine?.currentState as? BFGameIdleState {
            state.handleTouch(touch)
        } else if let state = context?.stateMachine?.currentState as? BFGamePlayingState {
            state.handleTouch(touch)

        }

    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let state = context?.stateMachine?.currentState as? BFGamePlayingState else {
            return
        }
        state.handleTouchMoved(touch)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let state = context?.stateMachine?.currentState as? BFGamePlayingState else {
            return
        }
        state.handleTouchEnd()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let state = context?.stateMachine?.currentState as? BFGamePlayingState else {
            return
        }
        state.update(deltaTime: currentTime)
    }
    
    
}
    
