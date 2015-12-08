//
//  MenuScreen.swift
//  Snatch
//
//  Created by Joseph Sanchez on 12/5/15.
//  Copyright (c) 2015 Team Rocket. All rights reserved.
//

import UIKit

/// Class Menu Screen
/// this class will create the menu screen, allow users to navigate to login or register screens
class MenuScreen: UIViewController {
    
    /**
    Do any additional setup after loading the view
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /**
    Dispose of any resources that can be recreated if memory warning.
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /**
    Check if login screen appeared to verify login
    
    - parameter animated: did the screen animate
    */
    override func viewDidAppear(animated: Bool) {
        let isUserLogginIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn");
        //Display login page if user is not logged in
        if(!isUserLogginIn) {
            self.performSegueWithIdentifier("loginView", sender: self);
        }
    }
    
    /**
    Logout if logout button was tapped
    
    - parameter sender: button tap
    */
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn");
        NSUserDefaults.standardUserDefaults().synchronize();
        self.dismissViewControllerAnimated(true, completion: nil);
        
        self.performSegueWithIdentifier("loginView", sender: self);
    }
}