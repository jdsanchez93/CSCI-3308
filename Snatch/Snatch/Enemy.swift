//
//  Enemy.swift
//  Snatch
//
//  Created by Nicolette Goulart on 12/7/15.
//  Copyright (c) 2015 Team Rocket. All rights reserved.
//

import Foundation
import SpriteKit

/**
Direction of hero relative to enemy

- Southwest: hero is southwest of enemy
- Southeast: hero is southeast of enemy
- Northwest: hero is northwest of enemy
- Northeast: hero is northeast of enemy
*/
enum HeroIs {
    
    case Southwest, Southeast, Northwest, Northeast
    
}

/**
Current enemy direction

- Up:    Enemy is moving Up
- Down:  Enemy is moving Down
- Left:  Enemy is moving Left
- Right: Enemy is moving 
*/
enum EnemyDirection {
    
    case Up, Down, Left, Right
    
}

/// Enemy Class
/// this class contains all of the information about the enemies
/// including physics bodies, location, direction, speed, contact options, etc
class Enemy: SKNode {
    
    /**
    Default init as SKS
    
    @param: aDecoder: see SK NSCoder
    
    @return: Error if not implemented
    */
    
    var heroLocationIs = HeroIs.Southwest
    var currentDirection = EnemyDirection.Up
    var enemySpeed:Float = 5
    
    var previousLocation1:CGPoint = CGPointZero
    var previousLocation2:CGPoint = CGPoint(x: 1, y: 1)
    
    
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
        setUpPhysics(enemySprite.size)
        
        
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
        setUpPhysics(enemySprite.size)
    }
    
    /**
    set up enemy physics
    */
    func setUpPhysics(size:CGSize){
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody?.categoryBitMask = BodyType.enemy.rawValue
        self.physicsBody?.collisionBitMask = BodyType.boundary.rawValue | BodyType.boundary2.rawValue
        self.physicsBody?.contactTestBitMask = BodyType.hero.rawValue | BodyType.enemy.rawValue
        self.physicsBody?.allowsRotation = false
        
        self.zPosition = 90
        
        
    }
    
    
    func decideDirection() {
        
        println("stuck")
        
    }
    
    
    
    /**
    * check if enemy has stayed in same location for more than 1 update
    * save location variable prior to moving
    * check direction enemy is moving, increment primarily in that direction
    * add some to left, right, up, down depending on hero location
    * after moving enemy, save location for comparison
    */
    func update() {
        
        /**
        *  check if enemy has stayed in same location for more than 1 update
        */
        
        if (Int(previousLocation2.y) == Int(previousLocation1.y)) && (Int(previousLocation2.x) == Int(previousLocation1.x)){
            
            decideDirection()
            
        }
        
        previousLocation2 = previousLocation1
        
        /**
        *  if the current direction of the enemy is up, update position to continue towards hero
        */
        if(currentDirection == .Up){
            self.position = CGPoint(x: self.position.x, y: self.position.y + CGFloat(enemySpeed))
            
            if (heroLocationIs == .Northeast){
                self.position = CGPoint(x: self.position.x + CGFloat(enemySpeed), y: self.position.y)
            } else {
                ///assume northwest
                self.position = CGPoint(x: self.position.x - CGFloat(enemySpeed), y: self.position.y)
            }
            
        }
        
        /**
        *  if the current direction of the enemy is down, update position to continue towards hero
        */
        if(currentDirection == .Down){
            self.position = CGPoint(x: self.position.x, y: self.position.y - CGFloat(enemySpeed))
            
            if (heroLocationIs == .Southeast){
                self.position = CGPoint(x: self.position.x + CGFloat(enemySpeed), y: self.position.y)
            } else {
                self.position = CGPoint(x: self.position.x - CGFloat(enemySpeed), y: self.position.y)
            }
            
        }
        
        /**
        *  if the current direction of the enemy is left, update position to continue towards hero
        */
        if(currentDirection == .Left){
            self.position = CGPoint(x: self.position.x, y: self.position.y + CGFloat(enemySpeed))
            
            if (heroLocationIs == .Southeast){
                self.position = CGPoint(x: self.position.x, y: self.position.y + CGFloat(enemySpeed))
            } else {
                self.position = CGPoint(x: self.position.x, y: self.position.y - CGFloat(enemySpeed))
            }
            
        }
        
        /**
        *  if the current direction of the enemy is right, update position to continue towards hero
        */
        if(currentDirection == .Right){
            self.position = CGPoint(x: self.position.x, y: self.position.y + CGFloat(enemySpeed))
            
            if (heroLocationIs == .Southwest){
                self.position = CGPoint(x: self.position.x, y: self.position.y  + CGFloat(enemySpeed))
            } else {
                ///assume northwest
                self.position = CGPoint(x: self.position.x, y: self.position.y + CGFloat(enemySpeed))
            }
            
        }
        
        
     previousLocation1 = self.position
        
        
    }
    
    
}
