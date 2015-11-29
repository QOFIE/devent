//
//  ViewController.swift
//  Devent
//
//  Created by Erman Sefer on 16/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit


class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (PFUser.currentUser() == nil) {
            let loginViewController = LoginViewController()
            loginViewController.delegate = self
            loginViewController.fields = [PFLogInFields.UsernameAndPassword, .LogInButton, .PasswordForgotten, .SignUpButton, .Facebook]
            loginViewController.emailAsUsername = true
            loginViewController.signUpController?.emailAsUsername = true
            loginViewController.signUpController?.delegate = self
            loginViewController.facebookPermissions = ["public_profile", "email", "user_about_me", "user_work_history", "user_education_history", "user_birthday", "user_location"]
            self.presentViewController(loginViewController, animated: false, completion: nil)
        } else {
            presentLoggedInAlert()
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        presentLoggedInAlert()
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        presentLoggedInAlert()
        
    }
    
    func presentLoggedInAlert() {
        let alertController = UIAlertController(title: "You're logged in", message: "Welcome to Devent", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.performSegueWithIdentifier("loggedInSeque", sender: self)
        }
        
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}



