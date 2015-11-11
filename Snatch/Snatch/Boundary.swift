//
//  Boundary.swift
//  Snatch

import Foundation
import SpriteKit


class Boundary:SKNode {
    
    /* properties */
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}

    init (fromSKSWithRect rect:CGRect){
        
        super.init()
        
        let newLocation = CGPoint(x: -(rect.size.width / 2), y: -(rect.size.height / 2) )
        let newRect:CGRect = CGRect (origin: newLocation, size: rect.size)
        
        createBoundary(newRect)
        
    }

    func createBoundary(rect:CGRect){
        
        let shape = SKShapeNode(rect: rect, cornerRadius: 19)
        shape.fillColor = SKColor.clearColor() //sets the color of the boundary
        shape.strokeColor = SKColor.blackColor()
        shape.lineWidth = 1
        
        addChild(shape)
        
        
        //add the physics of the boundaries
        self.physicsBody = SKPhysicsBody(rectangleOfSize: rect.size)
        self.physicsBody!.dynamic = false //immovable
        self.physicsBody!.categoryBitMask = BodyType.boundary.rawValue
        self.physicsBody!.friction = 0
        self.physicsBody!.allowsRotation = false
        
        
        self.zPosition = 100 //visual depth is above anything that gets added at default position
        
    }





}