//
//  Enemy.swift
//  Snatch
//
//  Created by Nicolette Goulart on 12/7/15.
//  Copyright (c) 2015 Team Rocket. All rights reserved.
//

import Foundation
import SpriteKit

/// Enemy Class
class Enemy: SKNode {
    /**
    Default init as SKS
    
    - parameter aDecoder: see SK NSCoder
    
    - returns: Error if not implemented
    */
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    Init from SKS with a specific name
    
    - parameter image: name of image to be used as icon
    
    - returns: enemy sprite with icon of image
    */
    init (fromSKSWithImage image:String) {
        
        super.init()
        
        let enemySprite = SKSpriteNode(imageNamed: image)
        addChild(enemySprite)
        
        
    }
    
    /**
    Init with dictionary
    
    - parameter theDict: Dictionary of attributes for each jewel from tmx file
    
    - returns: enemies with correct coordinates and image icons
    */
    init (theDict:Dictionary<NSObject, AnyObject>){
        
        super.init()
        
        let theX:String = theDict["x"] as AnyObject? as! String
        let x:Int = theX.toInt()!
        
        let theY:String = theDict["y"] as AnyObject? as! String
        let y:Int = theY.toInt()!
        
        let location:CGPoint = CGPoint(x: x, y: y * -1) ///see same in boundary
        
        let image = theDict["name"] as AnyObject? as! String
        
        let enemySprite = SKSpriteNode(imageNamed: image)
        
        self.position = CGPoint(x: location.x + (enemySprite.size.width / 2), y: location.y - (enemySprite.size.height / 2))
        
        addChild(enemySprite)
    }
    
}
