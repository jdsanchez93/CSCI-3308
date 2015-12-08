//
//  LoginScreen.swift
//  Snatch
//
//  Created by Joseph Sanchez on 12/5/15.
//  Copyright (c) 2015 Team Rocket. All rights reserved.
//

import UIKit

class LoginScreen: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    /**
    Do any additional setup after loading the view
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.Portrait.rawValue;
        UIDevice.currentDevice().setValue(value, forKey: "orientation");
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true;
    }
    
    /**
    Dispose of any resources that can be recreated.
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
    Check if login button was tapped
    
    - parameter sender: should be a tap
    */
    @IBAction func loginButtonTapped(sender: AnyObject) {
        let username = usernameTextField.text;
        let password = passwordTextField.text;
        
        /**
        *  Make sure password isn't empty
        */
        if(password.isEmpty) {
            return;
        }
        
        ///Send user data to server
        let myUrl = NSURL(string: "http://caramel-howl-113305.appspot.com/userLogin.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let postString = "username=\(username)&password=\(password)";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        ///Execute http post request
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if(error != nil) {
                println("error=\(error)");
                return;
            }
            
            var err: NSError?;
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSDictionary;
            
            if let parseJSON = json {
                var resultValue = parseJSON["status"] as? String;
                println("result: \(resultValue)");
                
                if(resultValue == "Success") {
                    ///Login is successful
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn");
                    NSUserDefaults.standardUserDefaults().synchronize();
                    
                    self.dismissViewControllerAnimated(true, completion: nil);
                }
                
            }
        }
        
        task.resume();
        
    }
    
    
    
}
