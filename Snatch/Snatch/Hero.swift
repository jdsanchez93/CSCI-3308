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

/// Hero Class
/// this class contains all of the information about the hero
/// including physics body, location, direction, speed, contact options, etc
class Hero:SKNode {
    
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
    
    /**
    return error if not init
    
    - parameter aDecoder: see SpriteKit NSCoder
    
    - returns: Error if not initialized
    */
    required init?(coder aDecoder: NSCoder) { //this handes the error if the init of coder hasn't been implemented
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    Default init for hero
    
    - returns: hero node
    */
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
    
    /**
    This function will update the character etc every frame, changes when the screen is swyped
    */
    func update(){
        
        /**
        *  updates based on current direction and orientation
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
    
    /**
    Convert degrees to radians
    
    - parameter degrees: degrees as double
    
    - returns: radians as double
    */
    func degreesToRadians(degrees: Double) -> Double {
        
        return degrees/180 * Double(M_PI)
    }
    
    /**
    send hero up
    */
    func goUp(){
        
        /**
        *  if hero is blocked, changed desired direction until clear
        */
        if (upBlocked == true) {
            desiredDirection = DesiredDirection.Up
            
        }
            /**
            *  otherwise run the animation for hero moving upward
            and update physics body sensors
            */
        else{
        
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
    /**
    send hero down
    */
    func goDown(){
        
        /**
        *  if hero is blocked, changed desired direction until clear
        */
        if (downBlocked == true) {
            desiredDirection = DesiredDirection.Down
            
        }
            /**
            *  otherwise run the animation for hero moving down
            and update physics body sensors
            */
        else{
        
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
    /**
    send hero right
    */
    func goRight(){
        
        /**
        *  if hero is blocked, changed desired direction until clear
        */
        if (rightBlocked == true) {
            desiredDirection = DesiredDirection.Right
            
        }
            /**
            *  otherwise run the animation for hero moving right
            and update physics body sensors
            */
        else{
        
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
    
    /**
    send hero left
    */
    func goLeft(){
        
        /**
        *  if hero is blocked, changed desired direction until clear
        */
        if (leftBlocked == true) {
            desiredDirection = DesiredDirection.Left
            
        }
            /**
            *  otherwise run the animation for hero moving left
            and update physics body sensors
            */
        else{
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
    
    /**
    set up the hero animation sequence
    */
    func setUpAnimation(){
        
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
    
    /**
    *  Animates the hero to make it look like he's running
    */
    func runAnimation(){
        
        objectSprite!.runAction(movingAnimation)
     
    }
    
    /**
    *  Stop the running animation
    */
    func stopAnimation(){
        
        objectSprite!.removeAllActions()
    }
    
    
    //MARK: Create sensors
    
    /**
    Create Sensor on hero for up
    
    - parameter whileTravellingUpOrDown: bool for if the hero is travelling up or down
    */
    func createUpSensorPhysicsBody(#whileTravellingUpOrDown:Bool){
        
        var size:CGSize = CGSizeZero
        
        /**
        *  if hero is traveling down, set sensor sizes to w: 32, h: 9
        */
        if (whileTravellingUpOrDown == true){
            
            size = CGSize(width: 32, height: 9)
        } else {
            size = CGSize(width: 32.4, height: 36)
            
        }
        
        /// set up sensor physics body properties
        nodeUp!.physicsBody = nil ///to get rid of any existing physics body
        let bodyUp:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: size)
        nodeUp!.physicsBody = bodyUp
        nodeUp!.physicsBody?.categoryBitMask = BodyType.sensorUp.rawValue
        nodeUp!.physicsBody?.collisionBitMask = 0
        nodeUp!.physicsBody?.contactTestBitMask = BodyType.boundary.rawValue
        nodeUp!.physicsBody?.pinned = true //pinned to its parent nodes body
        nodeUp!.physicsBody?.allowsRotation = false
        
        
        
    }
    
    /**
    Create Sensor on hero for down
    
    - parameter whileTravellingUpOrDown: bool for if the hero is travelling up or down
    */
    func createDownSensorPhysicsBody(#whileTravellingUpOrDown:Bool){
        
        var size:CGSize = CGSizeZero
        
        if (whileTravellingUpOrDown == true){
            
            size = CGSize(width: 32, height: 9)
        } else {
            size = CGSize(width: 32.4, height: 36)
            
        }
        
        /// set down sensor physics body properties
        nodeDown!.physicsBody = nil ///to get rid of any existing physics body
        let bodyDown:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: size)
        nodeDown!.physicsBody = bodyDown
        nodeDown!.physicsBody?.categoryBitMask = BodyType.sensorDown.rawValue
        nodeDown!.physicsBody?.collisionBitMask = 0
        nodeDown!.physicsBody?.contactTestBitMask = BodyType.boundary.rawValue
        nodeDown!.physicsBody?.pinned = true //pinned to its parent nodes body
        nodeDown!.physicsBody?.allowsRotation = false
        
        
        
    }
    
    /**
    Create Sensor on hero for left
    
    - parameter whileTravellingRightOrLeft: if the hero is travelling right or left
    */
    func createLeftSensorPhysicsBody(#whileTravellingRightOrLeft:Bool){
        
        var size:CGSize = CGSizeZero
        
        if (whileTravellingRightOrLeft == true){
            
            size = CGSize(width: 9, height: 32)
        } else {
            size = CGSize(width: 36, height: 32.4)
            
        }
        
        /// set left sensor physics body properties
        nodeLeft!.physicsBody = nil ///to get rid of any existing physics body
        let bodyLeft:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: size)
        nodeLeft!.physicsBody = bodyLeft
        nodeLeft!.physicsBody?.categoryBitMask = BodyType.sensorLeft.rawValue
        nodeLeft!.physicsBody?.collisionBitMask = 0
        nodeLeft!.physicsBody?.contactTestBitMask = BodyType.boundary.rawValue
        nodeLeft!.physicsBody?.pinned = true //pinned to its parent nodes body
        nodeLeft!.physicsBody?.allowsRotation = false
        
        
        
    }
    

    /**
    Create Sensor on hero for right
    
    - parameter whileTravellingRightOrLeft: if the hero is travelling right or left
    */
    func createRightSensorPhysicsBody(#whileTravellingRightOrLeft:Bool){
        
        var size:CGSize = CGSizeZero
        
        if (whileTravellingRightOrLeft == true){
            
            size = CGSize(width: 9, height: 32)
        } else {
            size = CGSize(width: 36, height: 32.4)
            
        }
        
        /// set right sensor physics body properties
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
    
    
    /**
    up sensor has made contact, change up to blocked
    if the hero is moving up, stop animation
    */
    func upSensorContactStart(){
        
        upBlocked = true
        
        if (currentDirection == Direction.Up){
            currentDirection = Direction.None
            self.physicsBody?.dynamic = false
            stopAnimation()
        }
        
    }
    
    /**
    down sensor has made contact, change down to blocked
    if the hero is moving down, stop animation
    */
    func downSensorContactStart(){
        
        downBlocked = true
        
        if (currentDirection == Direction.Down){
            currentDirection = Direction.None
            self.physicsBody?.dynamic = false
            stopAnimation()
        }
        
    }
    
    /**
    left sensor has made contact, change left to blocked
    if the hero is moving left, stop animation
    */
    func leftSensorContactStart(){
        leftBlocked = true
        
        if (currentDirection == Direction.Left){
            currentDirection = Direction.None
            self.physicsBody?.dynamic = false
            stopAnimation()
        }
        
        
    }
    
    /**
    right sensor has made contact, change right to blocked
    if the hero is moving right, stop animation
    */
    func rightSensorContactStart(){
        rightBlocked = true
        
        if (currentDirection == Direction.Right){
            currentDirection = Direction.None
            self.physicsBody?.dynamic = false
            stopAnimation()
        }
        
        
    }
    
    
    //MARK: Functions for Sensor Contact: Ended
    
    /**
    Up sensor has ended contact, unblock, 
    if desired direction was up go up, reset desired direction
    */
    func upSensorContactEnd(){
        upBlocked = false
        
        if (desiredDirection == DesiredDirection.Up) {
            goUp()
            desiredDirection = DesiredDirection.None
        }
        
        
    }
    
    /**
    Down sensor has ended contact, unblock,
    if desired direction was down go down, reset desired direction
    */
    func downSensorContactEnd(){
        downBlocked = false
        
        if (desiredDirection == DesiredDirection.Down) {
            goDown()
            desiredDirection = DesiredDirection.None
        }
        
        
    }
    
    /**
    Left sensor has ended contact, unblock,
    if desired direction was left go left, reset desired direction
    */
    func leftSensorContactEnd(){
        leftBlocked = false
        
        if (desiredDirection == DesiredDirection.Left) {
            goLeft()
            desiredDirection = DesiredDirection.None
        }
        
        
        
    }
    
    /**
    Right sensor has ended contact, unblock,
    if desired direction was right go right, reset desired direction
    */
    func rightSensorContactEnd(){
        rightBlocked = false
        
        if (desiredDirection == DesiredDirection.Right) {
            goRight()
            desiredDirection = DesiredDirection.None
        }
        
    }
    
    
}









