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

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
