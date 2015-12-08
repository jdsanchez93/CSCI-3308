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
    /*!
    * @brief Hero class
    */
    
    /* properties */
    
    var currentSpeed:Float = 5
    var currentDirection = Direction.None
    var desiredDirection = DesiredDirection.None
    
    var movingAnimation:SKAction = SKAction()
    var objectSprite:SKSpriteNode?
    
    var downBlocked:Bool = false
    var upBlocked:Bool = false
    var leftBlocked:Bool = false
    var rightBlocked:Bool = false
    
    var nodeUp:SKNode?
    var nodeDown:SKNode?
    var nodeLeft:SKNode?
    var nodeRight:SKNode?
    
    var buffer:Int = 25
    
    
    required init?(coder aDecoder: NSCoder) { //this handes the error if the init of coder hasn't been implemented
        fatalError("init(coder:) has not been implemented")
    }
    
    override init (){ //override the init for SKNode
        super.init() //init a normal SKNode, with additional stuff befow
        println("hero was added")
        
        objectSprite = SKSpriteNode(imageNamed: "snatchHero")
        addChild(objectSprite!)
        
        setUpAnimation()
        runAnimation()
        
        let largerSize:CGSize = CGSize(width: objectSprite!.size.width * 1.2, height: objectSprite!.size.height * 1.2)
        
        /* Setting physics for hero
        */
        self.physicsBody = SKPhysicsBody(rectangleOfSize: largerSize)
        self.physicsBody!.friction = 0 ///slippery when interacting
        self.physicsBody!.dynamic = true /// whether or not it's part of overall physics simulation
        self.physicsBody!.restitution = 0 ///not bouncy
        self.physicsBody!.allowsRotation = false /// whether or not the physics body can rotate
        
        self.physicsBody!.categoryBitMask = BodyType.hero.rawValue
        ///if collisionBitMask is 0 then it will not collide with anything. Default: collides with everything
        self.physicsBody!.contactTestBitMask = BodyType.boundary.rawValue | BodyType.jewel.rawValue
        
        nodeUp = SKNode()
        addChild(nodeUp!)
        nodeUp!.position = CGPoint(x: 0, y: buffer)
        createUpSensorPhysicsBody(whileTravellingUpOrDown: false)
        
        nodeDown = SKNode()
        addChild(nodeDown!)
        nodeDown!.position = CGPoint(x: 0, y: -buffer)
        createDownSensorPhysicsBody(whileTravellingUpOrDown: false)
        
        nodeRight = SKNode()
        addChild(nodeRight!)
        nodeRight!.position = CGPoint(x: buffer, y: 0)
        createRightSensorPhysicsBody(whileTravellingRightOrLeft: true)
        
        nodeLeft = SKNode()
        addChild(nodeLeft!)
        nodeLeft!.position = CGPoint(x: -buffer, y: 0)
        createLeftSensorPhysicsBody(whileTravellingRightOrLeft: true)
        
     
    
    }
    
    func update(){
        /**
        * This function will update the character etc every frame, changes when the screen is swyped
        */
        
        switch currentDirection{
            case .Right:
            
                self.position = CGPoint(x: self.position.x + CGFloat(currentSpeed), y: self.position.y)
                objectSprite!.zRotation = CGFloat( degreesToRadians(0) )
                objectSprite!.xScale = 1.0 ///xscale = 1.0 or -1.0 for orientation in the world. 
                ///don't mess with z rotation or y rotation...
            
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
        /**
        * Convert degrees to radians
        * @param Degrees as a double to be converted
        */
        return degrees/180 * Double(M_PI)
    }
    
    
    func goUp(){
        /**
        send hero up
        */
        
        if (upBlocked == true) {
            desiredDirection = DesiredDirection.Up
            
        } else{
        
            runAnimation()
            currentDirection = .Up
            downBlocked = false
            self.physicsBody?.dynamic = true
            
            createUpSensorPhysicsBody(whileTravellingUpOrDown: true)
            createDownSensorPhysicsBody(whileTravellingUpOrDown: true)
            createRightSensorPhysicsBody(whileTravellingRightOrLeft: false)
            createLeftSensorPhysicsBody(whileTravellingRightOrLeft: false)
        }
    }
    
    func goDown(){
        /**
        send hero down
        */
        if (downBlocked == true) {
            desiredDirection = DesiredDirection.Down
            
        } else{
        
         currentDirection = .Down
         runAnimation()
         upBlocked = false
         self.physicsBody?.dynamic = true
         
         createUpSensorPhysicsBody(whileTravellingUpOrDown: true)
         createDownSensorPhysicsBody(whileTravellingUpOrDown: true)
         createRightSensorPhysicsBody(whileTravellingRightOrLeft: false)
         createLeftSensorPhysicsBody(whileTravellingRightOrLeft: false)
        }
    }
    
    func goRight(){
        /**
        send hero right
        */
        if (rightBlocked == true) {
            desiredDirection = DesiredDirection.Right
            
        } else{
        
            currentDirection = .Right
            runAnimation()
        
            leftBlocked = false
            self.physicsBody?.dynamic = true
        
            createUpSensorPhysicsBody(whileTravellingUpOrDown: false)
            createDownSensorPhysicsBody(whileTravellingUpOrDown: false)
            createRightSensorPhysicsBody(whileTravellingRightOrLeft: true)
            createLeftSensorPhysicsBody(whileTravellingRightOrLeft: true)
        }
    }
    
    func goLeft(){
        /**
        send hero left
        */
        if (leftBlocked == true) {
            desiredDirection = DesiredDirection.Left
            
        } else{
            currentDirection = .Left
            runAnimation()
            
            rightBlocked = false
            self.physicsBody?.dynamic = true
        
            createUpSensorPhysicsBody(whileTravellingUpOrDown: false)
            createDownSensorPhysicsBody(whileTravellingUpOrDown: false)
            createRightSensorPhysicsBody(whileTravellingRightOrLeft: true)
            createLeftSensorPhysicsBody(whileTravellingRightOrLeft: true)
        }
    }
    
    func setUpAnimation(){
        /// set up the hero animation sequence
        
        let atlas = SKTextureAtlas(named: "walking") ///without the .atlas extension
        let array:[String] = ["walk1", "walk2", "walk3", "walk2"] ///this is the order the files are cycled
        
        var atlasTextures:[SKTexture] = []
        
        for (var i = 0; i < array.count; i++) {
            
            let texture:SKTexture = atlas.textureNamed( array[i] )
            atlasTextures.insert(texture, atIndex:i)
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1.0/12, resize: true, restore:false )
        movingAnimation = SKAction.repeatActionForever(atlasAnimation)
        
    }
    
    func runAnimation(){
        /**
        *  Animates the hero to make it look like he's running
        */
        objectSprite!.runAction(movingAnimation)
     
    }
    
    func stopAnimation(){
        /**
        *  Stop the running animation
        */
        objectSprite!.removeAllActions()
    }
    
    
    //MARK: Create sensors
    
    /**
    Create Sensor on hero for up
    
    - parameter whileTravellingUpOrDown: if the hero is travelling down
    */
    func createUpSensorPhysicsBody(#whileTravellingUpOrDown:Bool){
        
        var size:CGSize = CGSizeZero
        
        if (whileTravellingUpOrDown == true){
            
            size = CGSize(width: 32, height: 9)
        } else {
            size = CGSize(width: 32.4, height: 36)
            
        }
        
        nodeUp!.physicsBody = nil ///to get rid of any existing physics body
        let bodyUp:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: size)
        nodeUp!.physicsBody = bodyUp
        nodeUp!.physicsBody?.categoryBitMask = BodyType.sensorUp.rawValue
        nodeUp!.physicsBody?.collisionBitMask = 0
        nodeUp!.physicsBody?.contactTestBitMask = BodyType.boundary.rawValue
        nodeUp!.physicsBody?.pinned = true //pinned to its parent nodes body
        nodeUp!.physicsBody?.allowsRotation = false
        
        
        
    }
    
    func createDownSensorPhysicsBody(#whileTravellingUpOrDown:Bool){
        
        var size:CGSize = CGSizeZero
        
        if (whileTravellingUpOrDown == true){
            
            size = CGSize(width: 32, height: 9)
        } else {
            size = CGSize(width: 32.4, height: 36)
            
        }
        
        nodeDown!.physicsBody = nil ///to get rid of any existing physics body
        let bodyDown:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: size)
        nodeDown!.physicsBody = bodyDown
        nodeDown!.physicsBody?.categoryBitMask = BodyType.sensorDown.rawValue
        nodeDown!.physicsBody?.collisionBitMask = 0
        nodeDown!.physicsBody?.contactTestBitMask = BodyType.boundary.rawValue
        nodeDown!.physicsBody?.pinned = true //pinned to its parent nodes body
        nodeDown!.physicsBody?.allowsRotation = false
        
        
        
    }
    
    func createLeftSensorPhysicsBody(#whileTravellingRightOrLeft:Bool){
        
        var size:CGSize = CGSizeZero
        
        if (whileTravellingRightOrLeft == true){
            
            size = CGSize(width: 9, height: 32)
        } else {
            size = CGSize(width: 36, height: 32.4)
            
        }
        
        nodeLeft!.physicsBody = nil ///to get rid of any existing physics body
        let bodyLeft:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: size)
        nodeLeft!.physicsBody = bodyLeft
        nodeLeft!.physicsBody?.categoryBitMask = BodyType.sensorLeft.rawValue
        nodeLeft!.physicsBody?.collisionBitMask = 0
        nodeLeft!.physicsBody?.contactTestBitMask = BodyType.boundary.rawValue
        nodeLeft!.physicsBody?.pinned = true //pinned to its parent nodes body
        nodeLeft!.physicsBody?.allowsRotation = false
        
        
        
    }
    

    
    func createRightSensorPhysicsBody(#whileTravellingRightOrLeft:Bool){
        
        var size:CGSize = CGSizeZero
        
        if (whileTravellingRightOrLeft == true){
            
            size = CGSize(width: 9, height: 32)
        } else {
            size = CGSize(width: 36, height: 32.4)
            
        }
        
        nodeRight!.physicsBody = nil ///to get rid of any existing physics body
        let bodyRight:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: size)
        nodeRight!.physicsBody = bodyRight
        nodeRight!.physicsBody?.categoryBitMask = BodyType.sensorRight.rawValue
        nodeRight!.physicsBody?.collisionBitMask = 0
        nodeRight!.physicsBody?.contactTestBitMask = BodyType.boundary.rawValue
        nodeRight!.physicsBody?.pinned = true //pinned to its parent nodes body
        nodeRight!.physicsBody?.allowsRotation = false
 
    }

    //MARK: Functions for Sensor Contact: Ititated
    
    func upSensorContactStart(){
        
        upBlocked = true
        
        if (currentDirection == Direction.Up){
            currentDirection = Direction.None
            self.physicsBody?.dynamic = false
            stopAnimation()
        }
        
    }
    
    func downSensorContactStart(){
        
        downBlocked = true
        
        if (currentDirection == Direction.Down){
            currentDirection = Direction.None
            self.physicsBody?.dynamic = false
            stopAnimation()
        }
        
    }
    
    func leftSensorContactStart(){
        leftBlocked = true
        
        if (currentDirection == Direction.Left){
            currentDirection = Direction.None
            self.physicsBody?.dynamic = false
            stopAnimation()
        }
        
        
    }
    
    func rightSensorContactStart(){
        rightBlocked = true
        
        if (currentDirection == Direction.Right){
            currentDirection = Direction.None
            self.physicsBody?.dynamic = false
            stopAnimation()
        }
        
        
    }
    
    
    //MARK: Functions for Sensor Contact: Ended
    
    func upSensorContactEnd(){
        upBlocked = false
        
        if (desiredDirection == DesiredDirection.Up) {
            goUp()
            desiredDirection = DesiredDirection.None
        }
        
        
    }
    
    func downSensorContactEnd(){
        downBlocked = false
        
        if (desiredDirection == DesiredDirection.Down) {
            goDown()
            desiredDirection = DesiredDirection.None
        }
        
        
    }
    
    func leftSensorContactEnd(){
        leftBlocked = false
        
        if (desiredDirection == DesiredDirection.Left) {
            goLeft()
            desiredDirection = DesiredDirection.None
        }
        
        
        
    }
    
    func rightSensorContactEnd(){
        rightBlocked = false
        
        if (desiredDirection == DesiredDirection.Right) {
            goRight()
            desiredDirection = DesiredDirection.None
        }
        
    }
    
    
}









