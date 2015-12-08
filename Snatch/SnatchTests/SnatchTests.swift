//
//  SnatchTests.swift
//  SnatchTests
//
//  Created by Nicolette Goulart on 11/8/15.
//  Copyright (c) 2015 Team Rocket. All rights reserved.
//

import SpriteKit
import UIKit
import XCTest
import Snatch


class SnatchTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    func testDown() {
        
        let hero = Hero()
        hero.goDown()
        XCTAssertEqual(Direction.Down, hero.currentDirection)
        
    }
    
    func testRight() {
        
        let hero = Hero()
        hero.goRight()
        XCTAssertEqual(Direction.Right, hero.currentDirection)
        
    }
    
    func testUp() {
        
        let hero = Hero()
        hero.goUp()
        XCTAssertEqual(Direction.Up, hero.currentDirection)
        
    }
    
    func testLeft() {
        
        let hero = Hero()
        hero.goLeft()
        XCTAssertEqual(Direction.Left, hero.currentDirection)
        
    }
    
    func testDegreestoRadians() {
        
        let hero = Hero()
        var radians = 30/180 * Double(M_PI)
        XCTAssertEqual(hero.degreesToRadians(30), radians, "degrees did not convert correctly")
        
    }

    func testHeroInit() {
        let hero = Hero()
        XCTAssert(hero.currentSpeed == 5, "Initial speed incorrect")
        XCTAssert(hero.currentDirection == Direction.None, "Initial direction incorrect")
        XCTAssert(hero.desiredDirection == DesiredDirection.None, "Initial desired direction incorrect")
        
    }
    
    func testBoundaryInit() {
        let rect = CGRectMake(0, 0, 10, 20)
        let b = Boundary(fromSKSWithRect: rect, isEdge: false)
        //println(b.children.first)
        XCTAssert(b.children.count == 1, "Boundary did not correctly create SKShapeNode")
        
    }
    
    func testJewelInit() {
        
        let jewel = Jewel()
        //println(b.children.first)
        XCTAssert(jewel.children.count == 1, "Boundary did not correctly create SKShapeNode")
        
    }
    
    func testEnemyInit() {
        let enemy = Enemy(fromSKSWithImage: "enemy_opponent")
        XCTAssert(enemy.enemySpeed == 5, "Initial speed incorrect")
        XCTAssert(enemy.currentDirection == EnemyDirection.Up, "Initial direction incorrect")
        XCTAssert(enemy.heroLocationIs == HeroIs.Southwest, "Initial hero direction incorrect")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
