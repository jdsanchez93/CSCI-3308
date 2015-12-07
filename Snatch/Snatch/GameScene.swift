//
//  GameScene.swift
//  Snatch
//
//  Copyright (c) 2015 Team Rocket. All rights reserved.
//

import SpriteKit



enum BodyType:UInt32 {
    /*!@brief how things will interact with one another
     */
    
    case hero = 1
    case boundary = 2
    case sensorUp = 4
    case sensorDown = 8
    case sensorRight = 16
    case sensorLeft = 32
    case jewel = 64
    case enemy = 128
    case boundary2 = 256
    
    
    
    
}






class GameScene: SKScene, SKPhysicsContactDelegate, NSXMLParserDelegate{
    /*!@brief Class, create the game scene
    */
    
    var currentSpeed:Float = 5
    var heroLocation:CGPoint = CGPointZero
    var mazeWorld:SKNode?
    var hero:Hero?
    var useTMXFiles:Bool = true
    var heroIsDead:Bool = false
    var jewelsAcquired:Int = 0
    var jewelsTotal:Int = 0
    
    
    
    override func didMoveToView(view: SKView) {
        /*!@brief set up starting location, maze, enemy locations
        *
        *
        *
        */
        
        self.backgroundColor = SKColor.grayColor()
        view.showsPhysics = true
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5) //anchors the scene to the middle of the maze to start
        
        if (useTMXFiles == true) {
            println("setup with tmx")
            self.enumerateChildNodesWithName("*"){
                node, stop in
                
                node.removeFromParent()
            }
            
            
            mazeWorld = SKNode()
            addChild(mazeWorld!)
            
        }
        else {
            
            mazeWorld = childNodeWithName("mazeWorld")
            heroLocation = mazeWorld!.childNodeWithName("StartingPoint")!.position
            
        }

        
        /* hero and maze*/
       
        
        hero = Hero()
        hero!.position = heroLocation
        mazeWorld!.addChild(hero!)
        hero!.currentSpeed = currentSpeed //MAY be be replaced with different vals at different levels
    
        /* gestures */
        
        
        let waitAction:SKAction = SKAction.waitForDuration(0.2) //this is in seconds...
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
        
        if (useTMXFiles == false) {
            setUpBoundaryFromSKS()
            setUpJewelsFromSKS()
            
        }
        else{
            parseTMXFileWithName("MazeType1")
    
        }
       
    }
    
    
    
    
    func setUpBoundaryFromSKS() {
        /*!@brief Set up Boundary using GameScene.sks
        */
        
        mazeWorld!.enumerateChildNodesWithName("boundary"){
            /*!
            * @brief find all nodes with specific name
            * @param name to look for
            */
            node, stop in
            
            if let boundary = node as? SKSpriteNode{ ///let's me refer to node as boundary from now on
                
                println("found boundary")
                let rect:CGRect = CGRect(origin: boundary.position, size: boundary.size)
                let newBoundary:Boundary = Boundary(fromSKSWithRect: rect)
                self.mazeWorld!.addChild(newBoundary)
                newBoundary.position = boundary.position
                
                boundary.removeFromParent()
                
            }
            
        }
        
    }
    
    
    func setUpJewelsFromSKS() {
        /*!
        * @brief Set up jewels from GameScene.sks
        */
        
        mazeWorld!.enumerateChildNodesWithName("jewel"){
            /*!
            * @brief find all nodes with specific name
            * @param name to look for
            */
            node, stop in
            
            if let jewel = node as? SKSpriteNode{
                ///let's me refer to node as jewel from now on
                
                let newJewel:Jewel = Jewel()
                self.mazeWorld!.addChild(newJewel)
                newJewel.position = jewel.position
                
                self.jewelsTotal++
                
                jewel.removeFromParent()
                
            }
            
        }
        
    }

    
    
    
    //MARK: Swipe Gestures
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /*!
        * @brief Called when a touch begins
        */
        
        for touch in (touches as! Set<UITouch>) { //find the touch location
            let location = touch.locationInNode(self)
            
        
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /*!
        * @brief called to update scene before each scene is rendered
        * @param Current time
        */
        hero!.update()
        
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        /*!
        * @brief Send hero to the right when swiped right
        * @param right swipe gesture
        */
       hero!.goRight()
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        /*!
        * @brief Send hero to the left when swiped right
        * @param right swipe gesture
        */
        hero!.goLeft()
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        /*!
        * @brief Send hero up when swiped right
        * @param right swipe gesture
        */
        hero!.goUp()
    }
    
    func swipedDown(sender:UISwipeGestureRecognizer){
        /*!
        * @brief Send hero down when swiped right
        * @param right swipe gesture
        */
        hero!.goDown()
    }
    
    //MARK: Contact related Code
    
    func didBeginContact(contact: SKPhysicsContact) {
        /*!
        * @brief Called when hero comes into contact with object
        * @param Type of contact
        */
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch(contactMask) {
            
            case BodyType.hero.rawValue | BodyType.jewel.rawValue:
                if let jewel = contact.bodyA.node as? Jewel { ///used if hero runs into a jewel
                    jewel.removeFromParent()
                    
            }
            
                else if let jewel = contact.bodyB.node as? Jewel { ///used if hero runs into a jewel
                    jewel.removeFromParent()
                   
                
            }
                
                jewelsAcquired++
                if jewelsAcquired == jewelsTotal{
                    println("collected all jewels")
            }
            
            default:
                return
            
        }
        
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        /*!
        * @brief Called when hero ends contact with object
        * @param Type of contact
        */
     
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch(contactMask) {
            
        case BodyType.hero.rawValue | BodyType.boundary.rawValue:
            println("is not touching wall") ///print after hero leaves wall
            
        default:
            return
        }
        
        
    }
    
    //MARK: Parse TMX File
    
    func parseTMXFileWithName(name:NSString){
        /*!
        * @brief parse a tmx file to creat the maze
        * @param name of tmx file
        */
        let path:String = NSBundle.mainBundle().pathForResource(name as String, ofType: ".tmx")!
        let data:NSData = NSData(contentsOfFile: path)!
        let parser:NSXMLParser = NSXMLParser(data: data)
        
        parser.delegate = self
        parser.parse()
    
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        /*!
        * @brief parses the file, creates different objects
        * @param All kinds...
        */
        
        if (elementName == "object"){
            
            let type:AnyObject? = attributeDict["type"]
            
            if (type as? String == "Boundary"){ ///looks for an Boundary object in the .tmx file
                
                let newBoundary:Boundary = Boundary(theDict: attributeDict)
                    mazeWorld!.addChild(newBoundary)
                
            }
            
            else if (type as? String == "Jewel"){ ///looks for an Jewel object in the .tmx file
                
                let newJewel:Jewel = Jewel(theDict: attributeDict)
                mazeWorld!.addChild(newJewel)
                
            }
                
            else if (type as? String == "Portal") {
                let theName:String = attributeDict["name"] as AnyObject? as! String
                
                if (theName == "StartingPoint"){
                    
                    let theX:String = attributeDict["x"] as AnyObject? as! String ///as! because swift is weird...
                    let x:Int = theX.toInt()!
                    
                    let theY:String = attributeDict["y"] as AnyObject? as! String
                    let y:Int = theY.toInt()!
                    
                    hero!.position = CGPoint(x: x, y: y * -1) ///reverse the y value since it is reversed in xml file
                    heroLocation = hero!.position

                    
                }
                
            }
            
            
            
        }
    }
    
    
    override func didSimulatePhysics() {
        /*!
        * @brief Center on hero, as long as hero is not dead
        */
        if (heroIsDead == false){
            
            self.centerOnNode(hero!)
            
        }
    }
    
    
    func centerOnNode(node:SKNode){
        /*!
        * @brief Center on a specific node as point coords in this case the hero
        * @param Node
        */
        
        let cameraPositionInScene:CGPoint = self.convertPoint(node.position, fromNode: mazeWorld!)
        mazeWorld!.position = CGPoint(x: mazeWorld!.position.x - cameraPositionInScene.x, y: mazeWorld!.position.y - cameraPositionInScene.y)  ///centers the world around the character.
        
        
    }
    
    
    
    
}







