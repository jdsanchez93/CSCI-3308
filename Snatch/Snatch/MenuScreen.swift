//
//  MenuScreen.swift
//  Snatch
//
//  Created by Joseph Sanchez on 12/5/15.
//  Copyright (c) 2015 Team Rocket. All rights reserved.
//

import UIKit

class MenuScreen: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let isUserLogginIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn");
        //Display login page if user is not logged in
        if(!isUserLogginIn) {
            self.performSegueWithIdentifier("loginView", sender: self);
        }
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn");
        NSUserDefaults.standardUserDefaults().synchronize();
        self.dismissViewControllerAnimated(true, completion: nil);
        
        self.performSegueWithIdentifier("loginView", sender: self);
    }
}