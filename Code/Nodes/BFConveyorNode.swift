//
//  BFBoxNode.swift
//  BFreeze
//
//  Created by jlo on 11/7/24.
//

import SpriteKit

class BFConveyorNode: SKSpriteNode {
    var conveyor: SKSpriteNode = SKSpriteNode()
    
    func setup(screenSize: CGSize, layoutInfo: BFLayoutInfo) {
        
        let conveyorNode = SKSpriteNode(color: .gray, size: layoutInfo.conveyorSize)
        
//        boxNode.position = CGPoint(x: -boxWidth / 2.0, y: 0)
        addChild(conveyorNode)
        conveyor = conveyorNode
        addConveyorLines(conveyorSize: layoutInfo.conveyorSize)
        startConveyorMovement(screenHeight: screenSize.height)
    }
    
    func addConveyorLines(conveyorSize: CGSize) {
        let lineHeight: CGFloat = 5.0
        let lineSpacing: CGFloat = 100.0
        
        var currentY: CGFloat = -conveyorSize.height / 2
        while currentY < conveyorSize.height / 2 {
            let line = SKSpriteNode(color: .black, size: CGSize(width: conveyorSize.width, height: lineHeight))
            line.position = CGPoint(x: 0, y: currentY)
            addChild(line)
            currentY += lineSpacing
        }
    }
    
    func startConveyorMovement(screenHeight: CGFloat) {
        // Define the movement actions
        let moveUp = SKAction.moveTo(y: screenHeight + self.size.height / 2.0, duration: 20.0) // Move up off-screen
        let resetPosition = SKAction.moveTo(y: -self.size.width / 2.0, duration: 0)
//        let resetPosition = SKAction.moveTo(y: -self.size.height / 2.0, duration: 0)  // Reset to start at the bottom
        let conveyorLoop = SKAction.sequence([moveUp, resetPosition])
        
        // Repeat the loop indefinitely
        let repeatConveyor = SKAction.repeatForever(conveyorLoop)
        self.run(repeatConveyor)
    }
}
