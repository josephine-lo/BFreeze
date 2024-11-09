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
    var score: Int = 0
    
    
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
        
        prepareGameContext()
        prepareStartNodes()
        
        createDraggableCircle(fillColor: .red)
        createDraggableCircle(fillColor: .blue)
        createDraggableCircle(fillColor: .green)
        
        displayRandomCircles()
        
        
        
//        conveyor = BFConveyorNode()
//        addChild(conveyor)
    
        
        context.stateMachine?.enter(BFGameIdleState.self)
    }
    
    
    
    func createDraggableCircle(fillColor: UIColor) {
        let circleRadius: CGFloat = 30.0
        let circleNode = SKShapeNode(circleOfRadius: circleRadius)
        circleNode.fillColor = fillColor
        circleNode.position = initialPositions[fillColor] ?? CGPoint(x: 0, y: 0)
        circleNode.zPosition = 1
        circleNode.name = "draggableCircle"  // Tag circles for identification
        addChild(circleNode)
        
//        let moveAction = SKAction.moveBy(x: 300, y: 0, duration: 5) // Move horizontally
//        circleNode.run(moveAction)
    }
    
    func createDisplayCircle(fillColor: UIColor, position: CGPoint) {
        let circleRadius: CGFloat = 30.0
        let circleNode = SKShapeNode(circleOfRadius: circleRadius)
        circleNode.fillColor = fillColor
        circleNode.position = position
        circleNode.zPosition = 1
        circleNode.name = "displayCircle"  // Tag circles for identification
        addChild(circleNode)
        
        displayCircles.append(circleNode)
        
    }
    
    func prepareGameContext() {
        guard let context else {
            return
        }

        context.scene = self
        context.updateLayoutInfo(withScreenSize: size)
        context.configureStates()
    }
    
    func prepareStartNodes() {
        guard let context else {
            return
        }
        let center = CGPoint(x: size.width / 2.0,
                             y: size.height / 2.0)
        let conveyor = BFConveyorNode()
        conveyor.setup(screenSize: size, layoutInfo: context.layoutInfo)
        conveyor.position = center
        addChild(conveyor)
        self.conveyor = conveyor
        
        createDraggableCircle(fillColor: .red)
        createDraggableCircle(fillColor: .blue)
        createDraggableCircle(fillColor: .green)

        
        
    }
    
    func displayRandomCircles() {
        let colors: [UIColor] = [.red, .green, .blue]
        //let numberOfCircles = Int.random(in: 2...3)
        let numberOfCircles = 3
        
//        let radius: CGFloat = 75.0
////        let centerX = size.width / 2
////        let centerY = size.height / 2
//        let centerX = size.width / 2
//        let centerY = size.height / 2
        
        let positions: [CGPoint] = [
            CGPoint(x: size.width - 45, y: size.height - 85),
            CGPoint(x: size.width - 90, y: size.height - 85),
            CGPoint(x: size.width - 60, y: size.height - 125)
        ]
        
        for i in 0..<numberOfCircles {
            let randomColor = colors.randomElement() ?? .white
            createDisplayCircle(fillColor: randomColor, position: positions[i])
//            createDraggableCircle(fillColor: randomColor)
//            let circle = SKShapeNode(circleOfRadius: radius)
//            circle.fillColor = randomColor
//            circle.position = positions[i]
//            circle.zPosition = 1
        }
    }
    
    func checkCirclesMatch() -> Bool {
        let displayColors = Set(displayCircles.map { $0.fillColor })
        let conveyorColors = Set(conveyorCircles.map { $0.fillColor })

        return displayColors == conveyorColors
        
//        guard displayCircles.count == conveyorCircles.count else { return false }
//        
//        for (displayCircle, conveyorCircle) in zip(displayCircles, conveyorCircles) {
//            if displayCircle.fillColor != conveyorCircle.fillColor {
//                return false
//            }
//        }
//        return true
    }
    
    override func update(_ currentTime: TimeInterval) {
        if checkCirclesMatch() {
            print("Match found!")
            score += 1
            scoreLabel.text = "Score: \(score)"
            displayCircles.removeAll()
            displayRandomCircles()
            conveyorCircles.removeAll()
            // Perform actions if there's a match, such as scoring points or triggering an event
        } else {
            // Handle non-matching state, if necessary
        }
    }



      //........
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first, let state = context?.stateMachine?.currentState as? BFGamePlayingState else {
//            return
//        }
//        state.handleTouch(touch)
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first, let state = context?.stateMachine?.currentState as? BFGamePlayingState else {
//            return
//        }
//        state.handleTouchMoved(touch)
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let state = context?.stateMachine?.currentState as? BFGamePlayingState else {
//            return
//        }
//        state.handleTouchEnded()
//    }
    
    
    // Touches began: Check if a circle is touched
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//           var touchedNode = SKShapeNode()
           if let touch = touches.first {
               let location = touch.location(in: self)
               let touchedNode = atPoint(location)
               
               if touchedNode.name == "draggableCircle", let shapeNode = touchedNode as? SKShapeNode {
                   selectedNode = shapeNode
//                   replaceCircle(existingNode: shapeNode)
               }
           }
       }
       
       // Touches moved: Drag the selected circle
       override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
           if let touch = touches.first, let node = selectedNode {
               let location = touch.location(in: self)
               node.position = location
//               replaceCircle(existingNode: node)
//               if let circle = atPoint(location) as? SKShapeNode {
//                   // Move the circle along with the touch
//                   circle.position = location
//               }
           }
       }
       
       // Touches ended: Drop the circle and move it along conveyor if dropped there
       override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
           if let node = selectedNode {
               // Check if the circle is close to the conveyor area
               print(abs(node.position.y - conveyorPosition.y))
               if abs(node.position.y - conveyorPosition.y) < 50 {
                   moveToConveyor(circleNode: node)  // Start conveyor movement
               }
//           guard let touch = touches.first else { return }
//           let location = touch.location(in: self)
//           
//           if let circle = atPoint(location) as? SKShapeNode {
//               // Check if the circle is within the bounds of BFConveyorNode
//               if conveyor.contains(location) {
//                   conveyorCircles.append(circle)
//               }
           }
           
           createDraggableCircle(fillColor: selectedNode!.fillColor)
//               replaceCircle(existingNode: selectedNode!)
           selectedNode = nil
           
       }

       func moveToConveyor(circleNode: SKShapeNode) {
           // Move the circle along the conveyor path
           let moveAction = SKAction.moveBy(x: 0, y: self.size.height, duration: 20.0) // Adjust as needed
           conveyorCircles.append(circleNode)
           circleNode.run(moveAction)
       }
    
//        func replaceCircle(fillColor: UIColor) {
//            // Create a new circle with the same color in the initial position
//            createDraggableCircle(fillColor: fillColor)
//        }

        func replaceCircle(existingNode: SKNode) {
            guard let shapeNode = existingNode as? SKShapeNode else {
                print("The provided node is not an SKShapeNode.")
                return
            }

            let currentFillColor = shapeNode.fillColor
            existingNode.removeFromParent()
            createDraggableCircle(fillColor: currentFillColor)
        }

    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let touchLocation = touch.location(in: self)
//        
//        if circleNode.contains(touchLocation) {
//            isDragging = true
//        }
//    }
//
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard isDragging, let touch = touches.first else { return }
//        let touchLocation = touch.location(in: self)
//        
//        circleNode.position = touchLocation
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        isDragging = false
//        
//        if circleNode.intersects(conveyor) {
////            circleNode.position.y = conveyor.position.y
////            print("Circle placed on the conveyor")
//            let snappedPosition = snapToNearestGridLine(circlePosition: circleNode.position)
//            circleNode.position = snappedPosition
//            print("Circle placed and snapped on the conveyor")
//        }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        isDragging = false
//    }
//    
//    func snapToNearestGridLine(circlePosition: CGPoint) -> CGPoint {
//        let offsetY = circlePosition.y - conveyor.position.y
//        let gridIndex = round(offsetY / gridSpacing)
//        let snappedY = conveyor.position.y + gridIndex * gridSpacing
//        
//        return CGPoint(x: circlePosition.x, y: snappedY)
//    }

}
