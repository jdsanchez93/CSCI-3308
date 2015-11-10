//
//  Hero.swift
//  Snatch
//
//  Created by Nicolette Goulart on 11/8/15.
//  Copyright (c) 2015 Team Rocket. All rights reserved.
//

import Foundation
import SpriteKit

enum Direction {
    
    case Up, Down, Right, Left, None
    
    
}


enum DesiredDirection {
    
    case Up, Down, Right, Left, None
    
    
}


class Hero:SKNode {
    
    /* properties */
    
    var currentSpeed:Float = 5
    var currentDirection = Direction.None
    var desiredDirection = DesiredDirection.None
    
    var movingAnimation:SKAction?
    var objectSprite:SKSpriteNode?
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init (){
        super.init()
        println("hero was added")
        
        objectSprite = SKSpriteNode(imageNamed: "snatchHero")
        addChild(objectSprite!)
        
        setUpAnimation()
        runAnimation()
        
        let largerSize:CGSize = CGSize(width: objectSprite!.size.width * 1.2, height: objectSprite!.size.height * 1.2)
        
        /* Setting physics for hero
        */
        self.physicsBody = SKPhysicsBody(rectangleOfSize: largerSize)
        self.physicsBody!.friction = 0 //slippery when interacting
        self.physicsBody!.dynamic = true // whether or not it's part of overall physics simulation
        self.physicsBody!.restitution = 0 //not bouncy
        self.physicsBody!.allowsRotation = false // whether or not the physics body can rotate
        
        self.physicsBody!.categoryBitMask = BodyType.hero.rawValue
        //if contactTestBitMask is 0 then it will not collide with anything. Default: collides with everything
        self.physicsBody!.contactTestBitMask = BodyType.boundary.rawValue | BodyType.star.rawValue
        
        
     
    
    }
    
    func update(){
        
        /** This function will update the character etc every frame, changes when the screen is swyped
        */
        
        switch currentDirection{
            case .Right:
            
                self.position = CGPoint(x: self.position.x + CGFloat(currentSpeed), y: self.position.y)
                objectSprite!.zRotation = CGFloat( degreesToRadians(0) )
                objectSprite!.xScale = 1.0
            
            case .Left:
                self.position = CGPoint(x: self.position.x - CGFloat(currentSpeed), y: self.position.y)
                objectSprite!.zRotation = CGFloat( degreesToRadians(0) )
                objectSprite!.xScale = -1.0
            
            case .Up:
                self.position = CGPoint(x: self.position.x, y: self.position.y + CGFloat(currentSpeed))
                objectSprite!.zRotation = CGFloat( degreesToRadians(90) )
                objectSprite!.xScale = 1.0
            case .Down:
                self.position = CGPoint(x: self.position.x, y: self.position.y - CGFloat(currentSpeed))
                objectSprite!.zRotation = CGFloat( degreesToRadians(90) )
                objectSprite!.xScale = -1.0
            case .None:
                self.position = CGPoint(x: self.position.x, y: self.position.y)
            
            
        }
   
        
    }
    
    func degreesToRadians(degrees: Double) -> Double {
        return degrees/180 * Double(M_PI)
    }
    
    
    func goUp(){
        currentDirection = .Up
        runAnimation()
    }
    
    func goDown(){
        currentDirection = .Down
        runAnimation()
    }
    
    func goRight(){
        currentDirection = .Right
        runAnimation()
        
    }
    
    func goLeft(){
        currentDirection = .Left
        runAnimation()
    }
    
    func setUpAnimation(){
        
        let atlas = SKTextureAtlas(named: "walking") //without the .atlas extension
        let array:[String] = ["walk1", "walk2", "walk3", "walk2"]
        
        var atlasTextures:[SKTexture] = []
        
        for (var i = 0; i < array.count; i++) {
            
            let texture:SKTexture = atlas.textureNamed( array[i] )
            atlasTextures.insert(texture, atIndex:i)
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1.0/12, resize: true, restore:false )
        movingAnimation = SKAction.repeatActionForever(atlasAnimation)
        
    }
    
    func runAnimation(){
        objectSprite!.runAction(movingAnimation)
        
        
        
    }
    
    func stopAnimation(){
        objectSprite!.removeAllActions()
    
    
    
    }
    
}









