//
//  LandingPageViewController.swift
//  SpLifter
//
//  Created by Wilson Ding on 4/2/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LandingPageViewController: UIViewController {

    @IBOutlet weak var transparentIcon: UIImageView!
    
    let defaultDuration = 3.0
    let defaultDamping = 0.25
    let defaultVelocity = 3.0
    
    let facebookReadPermissions = ["id", "first_name", "last_name", "email"]
    
    var firstName = ""
    var lastName = ""
    var email = ""
    var image = ""
    
    var loginSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        animateButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateButton() {
        transparentIcon.transform = CGAffineTransformMakeScale(0.75, 0.75)
        
        UIView.animateWithDuration(defaultDuration,
                                   delay: 0,
                                   usingSpringWithDamping: CGFloat(defaultDamping),
                                   initialSpringVelocity: CGFloat(defaultVelocity),
                                   options: UIViewAnimationOptions.AllowUserInteraction,
                                   animations: {
                                    self.transparentIcon.transform = CGAffineTransformIdentity
            },
                                   completion: { finished in
                                    self.animateButton()
            }
        )
    }

    @IBAction func loginFacebookAction(sender: AnyObject) {
        loginToFacebook()
        
        if loginSuccess {
            self.performSegueWithIdentifier("segueToMain", sender: self)
        }
    }
    
    func loginToFacebook() {
        if FBSDKAccessToken.currentAccessToken() != nil {
            //For debugging, when we want to ensure that facebook login always happens
            //FBSDKLoginManager().logOut()
            //Otherwise do:
            
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, first_name, last_name, email"], tokenString: FBSDKAccessToken.currentAccessToken().tokenString, version: nil, HTTPMethod: "GET")
            req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
                if(error == nil)
                {
                    self.firstName = result.valueForKey("first_name") as! String
                    
                    self.lastName = result.valueForKey("last_name") as! String
                    
                    self.email = result.valueForKey("email") as! String
                    
                    self.image = "http://graph.facebook.com/\(result.valueForKey("id") as! String)/picture?type=large"
                    
                    self.loginSuccess = true
                }
                else
                {
                    print("error \(error)")
                }
            })
            
            return
        }
        
        FBSDKLoginManager().logInWithReadPermissions(self.facebookReadPermissions, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if error != nil {
                //According to Facebook:
                //Errors will rarely occur in the typical login flow because the login dialog
                //presented by Facebook via single sign on will guide the users to resolve any errors.
                
                // Process error
                FBSDKLoginManager().logOut()
            } else if result.isCancelled {
                // Handle cancellations
                FBSDKLoginManager().logOut()
            } else {
                self.firstName = result.valueForKey("first_name") as! String
                
                self.lastName = result.valueForKey("last_name") as! String
                
                self.email = result.valueForKey("email") as! String
                
                self.image = "http://graph.facebook.com/\(result.valueForKey("id") as! String)/picture?type=large"
                
                self.loginSuccess = true
            }
        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueToMain" {
            let sVC = segue.destinationViewController as! MainViewController
            
            sVC.firstName = firstName
            sVC.lastName = lastName
            sVC.email = email
            sVC.image = image
        }
        
    }

}
