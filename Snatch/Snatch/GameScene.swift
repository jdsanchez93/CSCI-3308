//
//  GameScene.swift
//  Snatch
//
//  Created by Nicolette Goulart on 11/8/15.
//  Copyright (c) 2015 Team Rocket. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var currentSpeed:Float = 5
    var heroLocation:CGPoint = CGPointZero
    var mazeWorld:SKNode?
    var hero:Hero?
    
    
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = SKColor.blackColor()
        
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
}







