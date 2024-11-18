//
//  BFBoxNode.swift
//  BFreeze
//
//  Created by jlo on 11/7/24.
//

import SpriteKit

class BFConveyorNode: SKSpriteNode {
    var conveyor: SKSpriteNode = SKSpriteNode()
    var conveyorSpeed: TimeInterval = 20.0
    var originalSpeed: TimeInterval = 20.0
    var startSpeed: TimeInterval = 20.0
    var upperBoundY: CGFloat = 0.0
    
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
        upperBoundY = screenHeight + self.size.height / 2.0
        let moveUp = SKAction.moveTo(y: upperBoundY, duration: conveyorSpeed) // Move up off-screen
        let resetPosition = SKAction.moveTo(y: -self.size.width / 2.0, duration: 0)
//        let resetPosition = SKAction.moveTo(y: -self.size.height / 2.0, duration: 0)
        let conveyorLoop = SKAction.sequence([moveUp, resetPosition])
        
        // Repeat the loop indefinitely
        let repeatConveyor = SKAction.repeatForever(conveyorLoop)
        self.run(repeatConveyor)
        conveyorSpeed = startSpeed
    }
    
    func speedUpConveyor(by factor: TimeInterval) {
        conveyorSpeed = max(1.0, conveyorSpeed - factor) // Ensure speed doesn't go below a minimum value
        print(conveyorSpeed)
        //self.removeAllActions() // Stop current movement
        startConveyorMovement(screenHeight: self.size.height) // Restart movement with new speed

    }
    
    func temporarilySpeedUpConveyor(for duration: TimeInterval, by increment: TimeInterval) {
        print("temp speeding:  \(self.conveyorSpeed)")
        self.conveyorSpeed -= increment

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.conveyorSpeed = self.originalSpeed
        }
        startConveyorMovement(screenHeight: self.size.height)
        print("finished speeding:  \(self.conveyorSpeed)")
    }
    
    
//    func temporarilySpeedUpConveyor(for duration: TimeInterval, by factor: TimeInterval) {
//        conveyorSpeed = max(1.0, conveyorSpeed + factor) // Speed up
//        self.removeAllActions()
//        startConveyorMovement(screenHeight: self.size.height)
//
//        let wait = SKAction.wait(forDuration: duration)
//        let resetSpeed = SKAction.run {
//            self.conveyorSpeed += factor // Reset to original speed
//            self.removeAllActions() // Stop current movement
//            self.startConveyorMovement(screenHeight: self.size.height) // Restart with original speed
//        }
//        self.run(SKAction.sequence([wait, resetSpeed]))
//
//    }
    
}
