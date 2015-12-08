//
//  Jewel.swift
//  Snatch
//

import Foundation
import SpriteKit

/// Jewel Class
/// this class contains all of the information about the jewels
/// including physics bodies, location, contact options, etc
class Jewel:SKNode {
    
    var jewelSprite:SKSpriteNode?
    
    /**
    Default init as SKS
    
    - parameter aDecoder: see SK NSCoder
    
    - returns: Error if not implemented
    */
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    Default init from SKS file
    
    - returns: jewel sprite with physics body characteristics
    */
    override init() {
        
        super.init()
        
        jewelSprite = SKSpriteNode(imageNamed: "jewel")
        addChild(jewelSprite!)
        
        createPhysicsBody()
        
    }
    
    /**
    Init with dictionary
    
    - parameter theDict: Dictionary of attributes for each jewel from tmx file
    
    - returns: jewels with correct coordinates
    */
    init (theDict:Dictionary<NSObject, AnyObject>){
        
        super.init()
        
        let theX:String = theDict["x"] as AnyObject? as! String ///as! because swift is weird...
        let x:Int = theX.toInt()!
        
        let theY:String = theDict["y"] as AnyObject? as! String
        let y:Int = theY.toInt()!
        
        let location:CGPoint = CGPoint(x: x, y: y * -1) ///see same in boundary
        
        jewelSprite = SKSpriteNode(imageNamed: "jewel")
        addChild(jewelSprite!)
        
        self.position = CGPoint(x: location.x + (jewelSprite!.size.width / 2), y: location.y - (jewelSprite!.size.height / 2))
        
        createPhysicsBody()
        
    }
    
    
    /**
    Create the jewel body in the scene with all attributes
    */
    func createPhysicsBody(){
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: jewelSprite!.size.width / 2)
        
        self.physicsBody?.categoryBitMask = BodyType.jewel.rawValue
        self.physicsBody?.collisionBitMask = 0 ///everything will pass through
        self.physicsBody?.contactTestBitMask = BodyType.hero.rawValue ///send signal when in contact with hero
        
        self.zPosition = 90
        
    }
    
}

