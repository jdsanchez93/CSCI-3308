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
    
    
    init (theDict:Dictionary<NSObject, AnyObject> ) {
        
        super.init()

        let theX:String = theDict["x"] as AnyObject? as! String //as! because swift is weird...
        let x:Int = theX.toInt()! //added ! because... it breaks otherwise
        
        let theY:String = theDict["y"] as AnyObject? as! String
        let y:Int = theY.toInt()!
        
        let theWidth:String = theDict["width"] as AnyObject? as! String
        let width:Int = theWidth.toInt()!
        
        let theHeight:String = theDict["height"] as AnyObject? as! String
        let height:Int = theHeight.toInt()!
        
        let location:CGPoint = CGPoint(x: x, y: y * -1) //use -1 because the grid is set up with 0,0 at the top left instead of the bottom left.
        let size:CGSize = CGSize(width: width, height: height)
        
        self.position = CGPoint(x: location.x + (size.width / 2), y: (location.y - size.height/2))
        let rect:CGRect = CGRectMake(-(size.width/2), -(size.height/2), size.width, size.height)
        
        createBoundary(rect)
        
        
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