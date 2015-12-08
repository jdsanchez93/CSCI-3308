///
///  GameScene.swift
///  Snatch
///
///  Copyright (c) 2015 Team Rocket. All rights reserved.
///


import SpriteKit


/**
Body Type to be used for how things interact with each other

- hero:        type 1
- boundary:    type 2
- sensorUp:    type 4
- sensorDown:  type 8
- sensorRight: type 16
- sensorLeft:  type 32
- jewel:       type 64
- enemy:       type 128
- boundary2:   type 256
*/
enum BodyType:UInt32 {
    
    
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

/// Create the Game Scene
class GameScene: SKScene, SKPhysicsContactDelegate, NSXMLParserDelegate{
    
    
    var currentSpeed:Float = 5 ///hero speed
    var heroLocation:CGPoint = CGPointZero
    var mazeWorld:SKNode?
    var hero:Hero?
    var useTMXFiles:Bool = true
    var heroIsDead:Bool = false
    var jewelsAcquired:Int = 0
    var jewelsTotal:Int = 0
    var enemyCount:Int = 0
    var enemyDictionary:[String:CGPoint] = [:] //key is string and the value is the point of enemy in scene
    
    /**
    set up starting location, maze, enemy locations
    
    - parameter view: Current view displayed
    */
    override func didMoveToView(view: SKView) {
        
        
        self.backgroundColor = SKColor.blackColor()
        view.showsPhysics = false
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5) //anchors the scene to the middle of the maze to start
        
        /**
        *  For use with TMX Files
        */
        if (useTMXFiles == true) {
            println("setup with tmx")
            self.enumerateChildNodesWithName("*"){
                node, stop in
                
                node.removeFromParent()
            }
            
            
            mazeWorld = SKNode()
            addChild(mazeWorld!)
            
        }
            /**
            *  For use with SKS Files
            */
        else {
            
            mazeWorld = childNodeWithName("mazeWorld")
            heroLocation = mazeWorld!.childNodeWithName("StartingPoint")!.position
            
        }

        
        //MARK: Hero and Maze
       
        
        hero = Hero()
        hero!.position = heroLocation
        mazeWorld!.addChild(hero!)
        hero!.currentSpeed = currentSpeed ///MAY be be replaced with different vals at different levels
    
        
        
        let waitAction:SKAction = SKAction.waitForDuration(0.2) ///this is in seconds...
        
        /**
        *  Animate the run action based on the swipe direction
        */
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
            setUpEdgeFromSKS()
            setUpJewelsFromSKS()
            setUpEnemiesFromSKS()
            
        }
        else{
            parseTMXFileWithName("MazeType1")
    
        }
       
    }
    
    
    /**
    set up enemies from the sks file
    */
    func setUpEnemiesFromSKS() {
        
        mazeWorld!.enumerateChildNodesWithName("enemy"){
            node, stop in
            
            if let enemy = node as? SKSpriteNode {
                
                self.enemyCount++
                
                /// create a new enemy with the name from sks file
                let newEnemy:Enemy = Enemy(fromSKSWithImage: enemy.name!)
                self.mazeWorld!.addChild(newEnemy)
                newEnemy.position = enemy.position
                newEnemy.name = enemy.name
                
                self.enemyDictionary.updateValue(newEnemy.position, forKey: newEnemy.name!)
                
                enemy.removeFromParent()
            }
            
        }
        
        
        
        
        
    }
    
    
    
    /**
    Set up Boudary using SKS file
    */
    func setUpBoundaryFromSKS() {
        
        
        /**
        *  find all nodes with boundary name
        */
        mazeWorld!.enumerateChildNodesWithName("boundary"){
            
            node, stop in
            
            if let boundary = node as? SKSpriteNode{ ///let's me refer to node as boundary from now on
                
                println("found boundary")
                let rect:CGRect = CGRect(origin: boundary.position, size: boundary.size)
                let newBoundary:Boundary = Boundary(fromSKSWithRect: rect, isEdge: false)
                self.mazeWorld!.addChild(newBoundary)
                newBoundary.position = boundary.position
                
                boundary.removeFromParent()
                
            }
            
        }
        
    }
    
    func setUpEdgeFromSKS() {
        
        
        /**
        *  find all nodes with boundary name
        */
        mazeWorld!.enumerateChildNodesWithName("edge"){
            
            node, stop in
            
            if let edge = node as? SKSpriteNode{
                
                println("found edge")
                let rect:CGRect = CGRect(origin: edge.position, size: edge.size)
                let newEdge:Boundary = Boundary(fromSKSWithRect: rect, isEdge: true)
                self.mazeWorld!.addChild(newEdge)
                newEdge.position = edge.position
                
                edge.removeFromParent()
                
            }
            
        }
        
    }
    
    /**
    Set up jewels from SKS file
    */
    func setUpJewelsFromSKS() {
        
        
        mazeWorld!.enumerateChildNodesWithName("jewel"){
            /// find all nodes with the name "jewel"
            
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
    
    /**
    Determines swipe direction, changes hero direction
    
    - parameter touches: where the screen was touched
    - parameter event:   Event of screen touching
    */
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
        
        }
    }
   
    /**
    called to update scene before each scene is rendered
    
    - parameter currentTime: current time
    */
    override func update(currentTime: CFTimeInterval) {
        
        hero!.update()
        
    }
    
    
    /**
    Send hero to the right when swiped right
    
    - parameter sender: user swipe
    */
    func swipedRight(sender:UISwipeGestureRecognizer){
        
       hero!.goRight()
    }
    
    /**
    Send hero to the left when swiped left
    
    - parameter sender: user swipe
    */
    func swipedLeft(sender:UISwipeGestureRecognizer){
        
        hero!.goLeft()
    }
    
    /**
    Send hero up when swiped up
    
    - parameter sender: user swipe
    */
    func swipedUp(sender:UISwipeGestureRecognizer){
        
        hero!.goUp()
    }
    
    /**
    Send hero down when swiped down
    
    - parameter sender: user swipe
    */
    func swipedDown(sender:UISwipeGestureRecognizer){
        
        hero!.goDown()
    }
    
    //MARK: Contact related Code
    
    
    /**
    Called when hero comes into contact with an object, calls appropriate functions
    for moving hero, allowing hero to change directions, etc.
    
    - parameter contact: object contacted
    */
    func didBeginContact(contact: SKPhysicsContact) {
        
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        /**
        *  Different contact options for sensor and jewel
        */
        switch(contactMask) {
            
            case BodyType.boundary.rawValue | BodyType.sensorUp.rawValue:
            
                hero!.upSensorContactStart()
            case BodyType.boundary.rawValue | BodyType.sensorDown.rawValue:
            
                hero!.downSensorContactStart()
            
            case BodyType.boundary.rawValue | BodyType.sensorLeft.rawValue:
            
                hero!.leftSensorContactStart()
            
            case BodyType.boundary.rawValue | BodyType.sensorRight.rawValue:
            
                hero!.rightSensorContactStart()
            
            case BodyType.hero.rawValue | BodyType.jewel.rawValue:
                
                if let jewel = contact.bodyA.node as? Jewel { ///used if hero runs into a jewel
                    jewel.removeFromParent()
                    
            }
            
                else if let jewel = contact.bodyB.node as? Jewel { ///used if hero runs into a jewel
                    jewel.removeFromParent()
                   
                
            }
                
                jewelsAcquired++ ///total number of jewels, to be used as high score
                if jewelsAcquired == jewelsTotal{
                    println("collected all jewels")
            }
            
            default:
                return
            
        }
        
    }
    
    /**
    Called when hero ends contact with object
    
    - parameter contact: object with which contact is ended
    */
    func didEndContact(contact: SKPhysicsContact) {
        
     
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch(contactMask) {
            
        case BodyType.boundary.rawValue | BodyType.sensorUp.rawValue:
            
            hero!.upSensorContactEnd()
        case BodyType.boundary.rawValue | BodyType.sensorDown.rawValue:
            
            hero!.downSensorContactEnd()
            
        case BodyType.boundary.rawValue | BodyType.sensorLeft.rawValue:
            
            hero!.leftSensorContactEnd()
            
        case BodyType.boundary.rawValue | BodyType.sensorRight.rawValue:
            
            hero!.rightSensorContactEnd()
            
            
        default:
            return
        }
        
        
    }
    
    //MARK: Parse TMX File
    
    /**
    Parse TMX file to create dictionary
    
    - parameter name: name of file
    */
    func parseTMXFileWithName(name:NSString){
      
        let path:String = NSBundle.mainBundle().pathForResource(name as String, ofType: ".tmx")!
        let data:NSData = NSData(contentsOfFile: path)!
        let parser:NSXMLParser = NSXMLParser(data: data)
        
        parser.delegate = self
        parser.parse()
    
    }
    
    /**
    Actually parses the dictionary to create objects
    
    - parameter parser:        parser object
    - parameter elementName:   A string that is the name of an element (in its start tag)
    - parameter namespaceURI:  If namespace processing is turned on, contains the URI for the current namespace as a string object.
    - parameter qName:         If namespace processing is turned on, contains the qualified name for the current namespace as a string object.
    - parameter attributeDict: A dictionary that contains any attributes associated with the element.
    */
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        
        /**
        *  Begin parsin for objects
        */
        if (elementName == "object"){
            
            let type:AnyObject? = attributeDict["type"]
            
            /**
            *  parse and create boundaries from TMX File
            *
            *  @param "Boundary" type to find in tmx file
            *
            *  @return add boundaries to scene
            */
            if (type as? String == "Boundary"){
                
                var tmxDict = attributeDict
                tmxDict.updateValue("false", forKey: "isEdge")
                
                let newBoundary:Boundary = Boundary(theDict: tmxDict)
                    mazeWorld!.addChild(newBoundary)
                
            }
            
                /**
                *  parse and create edge from TMX File
                *
                *  @param "Edge" type to find in tmx file
                *
                *  @return add world edge to scene
                */
            else if (type as? String == "Edge"){
                
                var tmxDict = attributeDict
                tmxDict.updateValue("true", forKey: "isEdge")
                
                let newEdge:Boundary = Boundary(theDict: tmxDict)
                mazeWorld!.addChild(newEdge)
                
            }

            
                /**
                *  parse and create jewels from TMX File
                *
                *  @param "Jewel" type to find in tmx file
                *
                *  @return add jewel nodes to scene
                */
            else if (type as? String == "Jewel"){
                
                let newJewel:Jewel = Jewel(theDict: attributeDict)
                mazeWorld!.addChild(newJewel)
                
            }
                
            
                /**
                *  parse and create starting position from TMX File
                *
                *  @param "Portal" type to find in tmx file
                *
                *  @return change hero starting point to portal location
                */
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
            
                /**
                *  parse and create enemy objects from TMX File
                *
                *  @param "Enemy" type to find in tmx file
                *
                *  @return specific type of enemy in a dictionary
                */
            else if (type as? String == "Enemy"){
                enemyCount++
                
                let theName:String = attributeDict["name"] as AnyObject? as! String
                
                let newEnemy:Enemy = Enemy(theDict: attributeDict)
                mazeWorld!.addChild(newEnemy)
                
                newEnemy.name = theName
                
                let location:CGPoint = newEnemy.position
                
                enemyDictionary.updateValue(location, forKey: newEnemy.name!)
                
            }
            
            
            
        }
    }
    
    /**
    Center on hero, as long as hero is not dead
    */
    override func didSimulatePhysics() {
        
        /**
        *  if hero is not dead, center on hero
        */
        if (heroIsDead == false){
            
            self.centerOnNode(hero!)
            
        }
    }
    
    /**
    Center on a specific node
    
    - parameter node: node to be centered on. This should always be the hero in this game
    */
    func centerOnNode(node:SKNode){
        
        let cameraPositionInScene:CGPoint = self.convertPoint(node.position, fromNode: mazeWorld!)
        mazeWorld!.position = CGPoint(x: mazeWorld!.position.x - cameraPositionInScene.x, y: mazeWorld!.position.y - cameraPositionInScene.y)  ///centers the world around the character.
        
        
    }
    
    
    
    
}







