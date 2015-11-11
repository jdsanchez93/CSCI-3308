//
//  GameScene.swift
//  Snatch
//
//  Copyright (c) 2015 Team Rocket. All rights reserved.
//

import SpriteKit



enum BodyType:UInt32 {
    //how things will interact with one another
    
    case hero = 1
    case boundary = 2
    case sensorUp = 4
    case sensorDown = 8
    case sensorRight = 16
    case sensorLeft = 32
    case star = 64
    case enemy = 128
    case boundary2 = 256
    
    
    
    
}






class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var currentSpeed:Float = 5
    var heroLocation:CGPoint = CGPointZero
    var mazeWorld:SKNode?
    var hero:Hero?
    var useTMXFiles:Bool = false
    
    
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = SKColor.whiteColor()
        view.showsPhysics = true
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        mazeWorld = childNodeWithName("mazeWorld")
        heroLocation = mazeWorld!.childNodeWithName("StartingPoint")!.position
        
        hero = Hero()
        hero!.position = heroLocation
        mazeWorld!.addChild(hero!)
        hero!.currentSpeed = currentSpeed //MAY be be replaced with different vals at different levels
    
        /* gestures */
        
        
        let waitAction:SKAction = SKAction.waitForDuration(0.2)
        self.runAction(waitAction, completion: {
            
            let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:") )
            swipeRight.direction = .Right
            view.addGestureRecognizer(swipeRight)
            
            let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:") )
            swipeLeft.direction = .Left
            view.addGestureRecognizer(swipeLeft)
            
            let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedUp:") )
            swipeUp.direction = .Up
            view.addGestureRecognizer(swipeUp)
            
            let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedDown:") )
            swipeDown.direction = .Down
            view.addGestureRecognizer(swipeDown)
            
            
        }
        )
        
        
        
        /* set Up based on TMX or SKS */
        
        if (useTMXFiles == true) {
            println("setup with tmx")
            
        }
        else {
            println("setup with SKS")
            setUpBoundaryFromSKS()
        }
    }
    
    
    
    
    func setUpBoundaryFromSKS() {
        
        mazeWorld!.enumerateChildNodesWithName("boundary"){
            node, stop in
            
            if let boundary = node as? SKSpriteNode{ //let's me refer to node as boundary from now on
                
                println("found boundary")
                let rect:CGRect = CGRect(origin: boundary.position, size: boundary.size)
                let newBoundary:Boundary = Boundary(fromSKSWithRect: rect)
                self.mazeWorld!.addChild(newBoundary)
                newBoundary.position = boundary.position
                
                boundary.removeFromParent()
                
            }
            
        }
        
    }
    
    
    
    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
        
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        hero!.update()
        
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
       hero!.goRight()
       
        
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        hero!.goLeft()
        
        
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        hero!.goUp()
        
        
    }
    
    func swipedDown(sender:UISwipeGestureRecognizer){
        hero!.goDown()
        
        
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch(contactMask) {
            
            case BodyType.hero.rawValue | BodyType.boundary.rawValue:
                println("ran into wall")
            
            default:
                return
            
        }
        
    }
    
    func didEndContact(contact: SKPhysicsContact) {
     
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch(contactMask) {
            
        case BodyType.hero.rawValue | BodyType.boundary.rawValue:
            println("is not touching wall")
            
        default:
            return
        }
        
        
    }
}







