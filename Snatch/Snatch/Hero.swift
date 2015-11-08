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
    var currentDirection = Direction.Right
    var desiredDirection = DesiredDirection.None
    
    
    
    
    
    
    
    var objectSprite:SKSpriteNode?
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init (){
        super.init()
        println("hero was added")
        
        objectSprite = SKSpriteNode(imageNamed: "hero")
        addChild(objectSprite!)
        
        
        
        
    
    }
    
    func update(){
        println("running")
    }
    
    
    
}































