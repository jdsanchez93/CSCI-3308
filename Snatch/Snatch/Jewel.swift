//
//  Jewel.swift
//  Snatch
//

import Foundation
import SpriteKit

class Jewel:SKNode{
    
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
    
    
    func createPhysicsBody(){
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: jewelSprite!.size.width / 2)
        
        self.physicsBody?.categoryBitMask = BodyType.jewel.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = BodyType.hero.rawValue
        
        self.zPosition = 90
        
    }
    
}

