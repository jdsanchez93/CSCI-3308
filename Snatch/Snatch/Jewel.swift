//
//  Jewel.swift
//  Snatch
//

import Foundation
import SpriteKit

class Jewel:SKNode {
    
    var jewelSprite:SKSpriteNode?
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        super.init()
        
        jewelSprite = SKSpriteNode(imageNamed: "jewel")
        addChild(jewelSprite!)
        
        createPhysicsBody()
        
    }
    
    init (theDict:Dictionary<NSObject, AnyObject>){
        
        super.init()
        
        let theX:String = theDict["x"] as AnyObject? as! String ///as! because swift is weird...
        let x:Int = theX.toInt()!
        
        let theY:String = theDict["y"] as AnyObject? as! String
        let y:Int = theY.toInt()!
        
        let location:CGPoint = CGPoint(x: x, y: y * -1)
        
        jewelSprite = SKSpriteNode(imageNamed: "jewel")
        addChild(jewelSprite!)
        
        self.position = CGPoint(x: location.x + (jewelSprite!.size.width / 2), y: location.y - (jewelSprite!.size.height / 2))
        
        createPhysicsBody()
        
    }
    
    
    
    func createPhysicsBody(){
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: jewelSprite!.size.width / 2)
        
        self.physicsBody?.categoryBitMask = BodyType.jewel.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = BodyType.hero.rawValue
        
        self.zPosition = 90
        
    }
    
}

