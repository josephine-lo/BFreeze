//
//  BFGamePlayingState.swift
//  BFreeze
//
//  Created by jlo on 11/8/24.
//

import GameplayKit
import SpriteKit


class BFGamePlayingState: GKState {
    unowned let scene: BFGameScene
    unowned let context: BFGameContext
    
    var selectedNode: SKShapeNode?
    var conveyor: BFConveyorNode!

    var displayCircles: [SKShapeNode] = []
    var conveyorCircles: [SKShapeNode] = []
    var whiteBoxNode: SKSpriteNode!
    var conveyorSpeed: TimeInterval = 20.0
    var lastMissTime: TimeInterval = 0
    
    let initialPositions: [UIColor: CGPoint] = [
        .red: CGPoint(x: 75, y: 100),
        .blue: CGPoint(x: 75, y: 200),
        .green: CGPoint(x: 75, y: 300)
    ]
    
    init(scene: BFGameScene, context: BFGameContext) {
        self.scene = scene
        self.context = context
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is BFGameOverState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        print("did enter playing state")
        
        if let instructionsLabel = scene.childNode(withName: "instructionsLabel") {
            instructionsLabel.removeFromParent()
        }
        
        prepareStartNodes()
//        setupWhiteBox()
        createDraggableCircles()
        displayRandomCircles()
    }

    func createDraggableCircles() {
        createDraggableCircle(fillColor: .red)
        createDraggableCircle(fillColor: .blue)
        createDraggableCircle(fillColor: .green)
    }

    func createDraggableCircle(fillColor: UIColor) {
        let circleRadius: CGFloat = 30.0
        let circleNode = SKShapeNode(circleOfRadius: circleRadius)
        circleNode.fillColor = fillColor
        circleNode.position = initialPositions[fillColor] ?? CGPoint(x: 0, y: 0)
        circleNode.zPosition = 1
        circleNode.name = "draggableCircle"
        scene.addChild(circleNode) // Add to the scene
    }

    func createDisplayCircle(fillColor: UIColor, position: CGPoint) {
        let circleRadius: CGFloat = 30.0
        let circleNode = SKShapeNode(circleOfRadius: circleRadius)
        circleNode.fillColor = fillColor
        circleNode.position = position
        circleNode.zPosition = 1
        circleNode.name = "displayCircle"
        scene.addChild(circleNode) // Add to the scene
        displayCircles.append(circleNode)
    }

    func removeDisplayCircles() {
        for circle in displayCircles {
            circle.removeFromParent()
        }
        displayCircles.removeAll()
    }

    func prepareStartNodes() {
//        guard let context = context else { return }
        conveyor = BFConveyorNode()
        conveyor.setup(screenSize: scene.size, layoutInfo: context.layoutInfo)
        conveyor.position = CGPoint(x: scene.size.width / 2.0, y: scene.size.height / 2.0)
        scene.addChild(conveyor)
        setupWhiteBox()
    }
    

    func displayRandomCircles() {
        let colors: [UIColor] = [.red, .green, .blue]
        let numberOfCircles = 3
        
        let positions: [CGPoint] = [
            CGPoint(x: scene.size.width - 45, y: scene.size.height - 85),
            CGPoint(x: scene.size.width - 90, y: scene.size.height - 85),
            CGPoint(x: scene.size.width - 60, y: scene.size.height - 125)
            
//            CGPoint(x: scene.size.width ?? 0 - 45, y: scene.size.height ?? 0 - 85),
//            CGPoint(x: scene.size.width ?? 0 - 90, y: scene.size.height ?? 0 - 85),
//            CGPoint(x: scene.size.width ?? 0 - 60, y: scene.size.height ?? 0 - 125)
        ]
        
        for i in  0..<numberOfCircles {
            let randomColor = colors.randomElement() ?? .white
            createDisplayCircle(fillColor: randomColor, position: positions[i])
        }
    }

    func checkCirclesMatch() -> Bool {
        guard !displayCircles.isEmpty, !conveyorCircles.isEmpty else {
            return false
        }
        
        guard displayCircles.count == conveyorCircles.count else {
            return false
        }
        let displayColors = Set(displayCircles.map { $0.fillColor })
        let conveyorColors = Set(conveyorCircles.map { $0.fillColor })

        return displayColors == conveyorColors
    }

    func moveCirclesOffScreen() {
        for circle in conveyorCircles {
            let moveAction = SKAction.moveBy(x: 0, y: self.conveyor.upperBoundY, duration: 1.0)
            circle.run(moveAction) {
                circle.removeFromParent()
            }
        }
    }

    func setupWhiteBox() {
        let whiteBoxNode = SKSpriteNode(color: .white, size: CGSize(width: 100, height: 5))
        whiteBoxNode.position = CGPoint(x: 0, y: -380)
        conveyor.addChild(whiteBoxNode) // Add the white box as a child of the conveyor
    }

    override func update(deltaTime currentTime: TimeInterval) {
        if checkCirclesMatch() {
            print("Match found!")
            // Assuming score and scoreLabel are defined in the scene
            scene.score += 1
            scene.scoreLabel.text = "Score: \(scene.score)"
            
            //self.conveyor.speedUpConveyor(by: 15.0)
            //conveyor.temporarilySpeedUpConveyor(for: 0.5, by: 15.0)
            clearConveyor()
            prepareStartNodes()
            
            moveCirclesOffScreen()
            removeDisplayCircles()
            displayRandomCircles()
            conveyorCircles.removeAll()

        }
        
        // Check if 20 seconds have passed since the last miss increment

        if currentTime - lastMissTime >= 25 {
            clearConveyor()
            missCount()
            lastMissTime = currentTime
        }
    }
    
    func missCount() {
        scene.miss += 1
        scene.missLabel.text = "Miss: \(scene.miss)"
        
        if scene.miss == 3 {
            context.stateMachine?.enter(BFGameOverState.self)
        }
        
        prepareStartNodes()
    }
    
    
    func handleTouch(_ touch: UITouch) {
            let location = touch.location(in: scene)
            let touchedNode = scene.atPoint(location)

            if let shapeNode = touchedNode as? SKShapeNode, shapeNode.name == "draggableCircle" {
                selectedNode = shapeNode
                createDraggableCircle(fillColor: selectedNode?.fillColor ?? .white)

            }
        }


    func handleTouchMoved(_ touch: UITouch) {
        guard let node = selectedNode else { return }
        let location = touch.location(in: scene)
        node.position = location
    }


    func handleTouchEnd() {
//        guard let node = selectedNode else { return }
//        let circlePosition = node.position
//        let conveyorPosition = conveyor.convert(circlePosition, from: scene)
//
//        if conveyor.contains(conveyorPosition) {
//            node.removeFromParent()
//            conveyor.addChild(node)
//            node.position = conveyorPosition
//        } else {
//            node.position = initialPositions[node.fillColor] ?? CGPoint(x: 0, y: 0)
//
//        }
        
        if let node = selectedNode {
            let circlePosition = node.position

            if conveyor.contains(circlePosition) {
                moveToConveyor(circleNode: node)
//                placeAndMoveCircle(circleNode: node)
            } else {
                node.position = initialPositions[node.fillColor] ?? CGPoint(x: 0, y: 0)
            }
        }
        selectedNode = nil
    }

    
    func clearConveyor() {
        conveyorSpeed += 1.0 // Speed up the conveyor
        for circle in conveyorCircles {
            circle.removeFromParent() // Remove all circles from the conveyor
        }
        conveyorCircles.removeAll() // Clear the array of circles

    }


    func moveToConveyor(circleNode: SKShapeNode) {
       let moveAction = SKAction.moveTo(y: self.conveyor.upperBoundY, duration: self.conveyor.conveyorSpeed) // Adjust as needed
//           self.conveyor.addChild(circleNode)
       conveyorCircles.append(circleNode)
       print(conveyorCircles)
       circleNode.run(moveAction)
   }
    
    
    func spawnWhiteBox() {
        whiteBoxNode = SKSpriteNode(color: .white, size: CGSize(width: 100, height: 5))
        whiteBoxNode.position = CGPoint(x: 0, y: -380) // Position it at the bottom of the conveyor
        conveyor.addChild(whiteBoxNode) // Add the white box as a child of the conveyor
//        startWhiteBoxMovement() // Start moving the white box

    }


    func startWhiteBoxMovement() {
        let moveAction = SKAction.moveTo(y: scene.size.height / 2, duration: self.conveyor.conveyorSpeed)
        let resetAction = SKAction.moveTo(y: -scene.size.height / 2, duration: 0)
        let sequence = SKAction.sequence([moveAction, resetAction])
        let repeatAction = SKAction.repeatForever(sequence)
        whiteBoxNode.run(repeatAction)

    }
    
    
//    func moveToConveyor(circleNode: SKShapeNode) {
//        let scenePosition = circleNode.position
//        circleNode.removeFromParent()
//
//        conveyorCircles.append(circleNode)
//        let conveyorPosition = conveyor.convert(scenePosition, from: scene)
//        circleNode.position = conveyorPosition
//        
//        let moveAction = SKAction.moveTo(y: self.conveyor.upperBoundY, duration: self.conveyor.conveyorSpeed)
//        
//        circleNode.run(moveAction) {
//            self.conveyor.addChild(circleNode)
//        }
//    }
    
    func placeAndMoveCircle(circleNode: SKShapeNode) {
        if circleNode.parent != nil {
            circleNode.removeFromParent()
        }
        conveyor.addChild(circleNode)
        print("Current Parent: \(String(describing: circleNode.parent))")
        print("Circle Position: \(circleNode.position), Z-Position: \(circleNode.zPosition)")
        circleNode.position = CGPoint(x: conveyor.frame.minX, y: conveyor.frame.midY) // Adjust as needed
        let moveAction = SKAction.moveTo(x: conveyor.frame.maxX, duration: 5.0) // Adjust duration as needed

        // Run the move action on the circle node
        circleNode.run(moveAction)
        
        circleNode.run(moveAction) {
            circleNode.removeFromParent()
        }
    }
    
    
//    func placeAndMoveCircle(circleNode: SKShapeNode) {
//        conveyor.addChild(circleNode)
//        circleNode.position = CGPoint(x: conveyor.frame.minX, y: conveyor.frame.midY) // Adjust as needed
//        
//        let moveAction = SKAction.moveTo(x: conveyor.frame.maxX, duration: 5.0) // Adjust duration as needed
//        
//        circleNode.run(moveAction) {
//            circleNode.removeFromParent()
//        }
//    }
    
//    func moveToConveyor(circleNode: SKShapeNode) {
//        circleNode.removeFromParent()
//        conveyorCircles.append(circleNode)
//        
//        let moveAction = SKAction.moveTo(y: self.conveyor.upperBoundY, duration: self.conveyor.conveyorSpeed)
//        circleNode.run(moveAction) {
//            self.conveyor.addChild(circleNode) // Add the circle to the conveyor
//        }
//
//    }

//    func replaceCircle(existingNode: SKNode) {
//        guard let shapeNode = existingNode as? SKShapeNode else {
//            print("The provided node is not an SKShapeNode.")
//            return
//        }
//
//        let currentFillColor = shapeNode.fillColor
//        existingNode.removeFromParent()
//        createDraggableCircle(fillColor: currentFillColor)
//    }
}



//class BFGamePlayingState: GKState {
//    weak var scene: BFGameScene?
//    weak var context: BFGameContext?
//    
//    var circleNode: SKShapeNode!
//    var conveyor: BFConveyorNode!
//    var isDragging = false
//    let gridSpacing: CGFloat = 50.0
//    var displayCircles: [SKShapeNode] = []
//    var conveyorCircles: [SKShapeNode] = []
//
//    
//    let initialPositions: [UIColor: CGPoint] = [
//        .red: CGPoint(x: 75, y: 100),
//        .blue: CGPoint(x: 75, y: 200),
//        .green: CGPoint(x: 75, y: 300)
//    ]
//    
//    init(scene: BFGameScene, context: BFGameContext) {
//        self.scene = scene
//        self.context = context
//        super.init()
//    }
//    
//    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
//        return stateClass is BFGameOverState.Type
//    }
//    
//    override func didEnter(from previousState: GKState?) {
//        print("did enter playing state")
//        
//        prepareStartNodes()
//        setupWhiteBox()
//
//        createDraggableCircle(fillColor: .red)
//        createDraggableCircle(fillColor: .blue)
//        createDraggableCircle(fillColor: .green)
//
//        displayRandomCircles()
//    }
//
//    
//    // SKShapeNode version
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
//
//
//    func prepareStartNodes() {
//        guard let context else {
//            return
//        }
//        let center = CGPoint(x: size.width / 2.0,
//                             y: size.height / 2.0)
//        let conveyor = BFConveyorNode()
//        conveyor.setup(screenSize: size, layoutInfo: context.layoutInfo)
//        conveyor.position = center
//        addChild(conveyor)
//        self.conveyor = conveyor
//        
//        createDraggableCircle(fillColor: .red)
//        createDraggableCircle(fillColor: .blue)
//        createDraggableCircle(fillColor: .green)
//
//        
//        
//    }
//
//    func displayRandomCircles() {
//        let colors: [UIColor] = [.red, .green, .blue]
//    //        let numberOfCircles = Int.random(in: 2...3)
//        let numberOfCircles = 3
//        
//        
//        let positions: [CGPoint] = [
//            CGPoint(x: size.width - 45, y: size.height - 85),
//            CGPoint(x: size.width - 90, y: size.height - 85),
//            CGPoint(x: size.width - 60, y: size.height - 125)
//        ]
//        
//        for i in 0..<numberOfCircles {
//            let randomColor = colors.randomElement() ?? .white
//            createDisplayCircle(fillColor: randomColor, position: positions[i])
//        }
//    }
//
//    func checkCirclesMatch() -> Bool {
//        guard displayCircles.count == conveyorCircles.count else {
//            return false
//        }
//        let displayColors = Set(displayCircles.map { $0.fillColor })
//        let conveyorColors = Set(conveyorCircles.map { $0.fillColor })
//
//        return displayColors == conveyorColors
//        
//    }
//
//    func moveCirclesOffScreen() {
//        for circle in conveyorCircles {
//            let moveAction = SKAction.moveBy(x: 0, y: self.conveyor.upperBoundY, duration: 1.0)
//            circle.run(moveAction) {
//                circle.removeFromParent()
//            }
//        }
//    }
//
//
//    func setupWhiteBox() {
//        whiteBoxNode = SKSpriteNode(color: .white, size: CGSize(width: 100, height: 5)) // Thin rectangle
//        whiteBoxNode.position = CGPoint(x: 0, y: 20) // Position it above the conveyor (relative to conveyorNode)
//        self.conveyor.addChild(whiteBoxNode) // Add the white box as a child of the conveyor
//
//
//    }
//
//    override func update(_ currentTime: TimeInterval) {
//        if checkCirclesMatch() {
//            print("Match found!")
//            score += 1
//            scoreLabel.text = "Score: \(score)"
//            //self.conveyor.temporarilySpeedUpConveyor(for: 5.0, by: 5.0)
//    //            self.conveyor.speedUpConveyor(by: 5.0)
//            moveCirclesOffScreen()
//            displayCircles.removeAll()
//            removeDisplayCircles()
//            displayRandomCircles()
//            conveyorCircles.removeAll()
//            moveCirclesOffScreen()
//            
//    //            self.conveyor.speedUpConveyor(by: -2.0)
//        } else {
//            // Handle non-matching state, if necessary
//        }
//    }
//
//
//
//
//
//// Touches began: Check if a circle is touched
//   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
////           var touchedNode = SKShapeNode()
//       if let touch = touches.first {
//           let location = touch.location(in: self)
//           let touchedNode = atPoint(location)
//           
//           if touchedNode.name == "draggableCircle", let shapeNode = touchedNode as? SKShapeNode {
//               selectedNode = shapeNode
////                   replaceCircle(existingNode: shapeNode)
//           }
//       }
//   }
//   
//   // Touches moved: Drag the selected circle
//   override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//       if let touch = touches.first, let node = selectedNode {
//           let location = touch.location(in: self)
//           node.position = location
////               replaceCircle(existingNode: node)
////               if let circle = atPoint(location) as? SKShapeNode {
////                   // Move the circle along with the touch
////                   circle.position = location
////               }
//       }
//   }
//   
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let node = selectedNode {
//            let circlePosition = node.position
//            
//            if self.conveyor.contains(circlePosition) {
//                moveToConveyor(circleNode: node)
//            } else {
//                // reset the circle's position if it's not on the conveyor
//                node.position = initialPositions[node.fillColor] ?? CGPoint(x: 0, y: 0)
//            }
//        }
//        
//        if let selectedNode = selectedNode {
//            let _: () = createDraggableCircle(fillColor: selectedNode.fillColor)
//        } else {
//            // do nothing
//        }
//        selectedNode = nil
//    }
//
//    func moveToConveyor(circleNode: SKShapeNode) {
//       let moveAction = SKAction.moveTo(y: self.conveyor.upperBoundY, duration: self.conveyor.conveyorSpeed) // Adjust as needed
////           self.conveyor.addChild(circleNode)
//       conveyorCircles.append(circleNode)
//       print(conveyorCircles)
//       circleNode.run(moveAction)
//   }
//
//
//
//    func replaceCircle(existingNode: SKNode) {
//        guard let shapeNode = existingNode as? SKShapeNode else {
//            print("The provided node is not an SKShapeNode.")
//            return
//        }
//
//        let currentFillColor = shapeNode.fillColor
//        existingNode.removeFromParent()
//        createDraggableCircle(fillColor: currentFillColor)
//    }
//
//    
//}
