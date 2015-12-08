//
//  RegisterScreen.swift
//  Snatch
//
//  Created by Joseph Sanchez on 12/6/15.
//  Copyright (c) 2015 Team Rocket. All rights reserved.
//

import UIKit

class RegisterScreen: UIViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        
        let userEmail = userEmailTextField.text;
        let username = usernameTextField.text;
        let password = passwordTextField.text;
        let repeatPassword = repeatPasswordTextField.text;
        
        //Check for empty fields
        if(userEmail.isEmpty || password.isEmpty || repeatPassword.isEmpty) {
            //Display alert message
            displayMyAlertMessage("All fields are required");
            return;
        }
        
        //Check if passwords match
        if(password != repeatPassword) {
            //Display an alert message
            displayMyAlertMessage("Passwords do not match");
            return;
        }
        
        //Send user data to server
        let myUrl = NSURL(string: "http://caramel-howl-113305.appspot.com/userRegister.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let postString = "email=\(userEmail)&username=\(username)&password=\(password)";
        println(postString);
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        //Execute http post request
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if(error != nil) {
                println("error=\(error)");
                return;
            }
            
            var err: NSError?;
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSDictionary;
            
            println("json=\(json)");
            
            if let parseJSON = json {
                var resultValue = parseJSON["status"] as? String;
                println("result: \(resultValue)");
                
                var isUserRegistered:Bool = false;
                if(resultValue == "Success") {
                    isUserRegistered = true;
                }
                
                var messageToDisplay:String = parseJSON["message"] as! String!;
                if(!isUserRegistered) {
                    messageToDisplay = parseJSON["message"] as! String!;
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    //Display alert message with ocnfirmation.
                    var myAlert = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: UIAlertControllerStyle.Alert);
                    
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { action in
                        self.dismissViewControllerAnimated(true, completion: nil);
                    }
                    
                    myAlert.addAction(okAction);
                    self.presentViewController(myAlert, animated:true, completion:nil);
                });
            }
        }
        
        task.resume();
        
    }
    
    func displayMyAlertMessage(userMessage:String) {
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil);
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil);
    }
    
    
}
