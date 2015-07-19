//
//  LoginViewController.swift
//  BookReview
//
//  Created by Nicholas Addison on 9/07/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController
{

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var messageField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func login(sender: AnyObject)
    {
        // if already logged in then segue to Navigation
        if let currentUser = PFUser.currentUser()
        {
            NSLog("current user \(currentUser.username) is already logged in")
            
            dispatch_async(dispatch_get_main_queue() )
            {
                    self.performSegueWithIdentifier("signInToNavigation", sender: self)
            }
            
            return
        }
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        var username = usernameField.text
        var password = passwordField.text
        
        PFUser.logInWithUsernameInBackground(username, password: password)
        {
            (user: PFUser?, error: NSError?) -> Void in
            
            self.activityIndicator.stopAnimating()
            
            if user != nil
            {
                dispatch_async(dispatch_get_main_queue() )
                {
                    self.performSegueWithIdentifier("signInToNavigation", sender: self)
                }
                
                self.passwordField.text = nil
                self.messageField.text = " "
            }
            else
            {
                if let message: AnyObject = error!.userInfo!["error"] {
                    self.messageField.text = "\(message)"
                }
            }
        }
    }

    @IBAction func logoutAction(sender: AnyObject)
    {
        PFUser.logOut()
        
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
        
        usernameField.text = nil
        passwordField.text = nil
        messageField.text = " "
    }
}
