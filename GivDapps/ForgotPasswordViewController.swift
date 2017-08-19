//
//  ForgotPasswordViewController.swift
//  GivDapps
//
//  Created by Guillermo Colin on 7/21/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        //  activityIndicator setup.
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        
        //  Instantiate delegates for UITextFields where appropriate.
        emailTF.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*  Outlets to the UITextFields of this View -- Start*/
    
    @IBOutlet weak var emailTF: UITextField!
    
    /*  Outlets to the UITextFields of this View -- End*/
    
    //  Outlet to the UIActivityIndicatorView of this View.
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //  User taps on getNewPassword, send an email to the user to reset the password.
    @IBAction func getNewPassword(_ sender: UIButton) {
        
        //  Indicate an operation is taking place behind the scenes.
        activityIndicator.startAnimating()
        
        //  Ignore any tapping that the user makes while this process occurs.
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //  Make sure you get an email from the user.
        guard let userEmail:String = emailTF.text else{
            return
        }
        
        //  Send a password resent using Firebase's services.
        Auth.auth().sendPasswordReset(withEmail: userEmail, completion: { error in
            
            if error != nil{
                
                //  Alert the user that an email has been sent to reset password.
                let alert = UIAlertController(title:"Ooops!", message: "Did you provide the right log in credentials?", preferredStyle: .alert)
                
                //  Add an OK button to dismiss it.
                alert.addAction(UIAlertAction(title:"OK", style: .cancel,handler: nil))
                
                //  Present it.
                self.present(alert, animated: true, completion: nil)
                
                //  Stop animating the activityIndicator, the process has finished.
                self.activityIndicator.stopAnimating()
                
                //  Register any tapping that the user makes when this process finishes.
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            else{
                
                //  Alert the user that an email has been sent to reset password.
                let alert = UIAlertController(title:"Check your email!", message: "Check for an email from us to reset your password.", preferredStyle: .alert)
                
                //  Add an OK button to take the user back to the LogInView
                alert.addAction(UIAlertAction(title:"OK", style: .cancel){ action in
                    
                    /*  Navigate user to the LogInView */
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let controller = storyboard.instantiateViewController(withIdentifier: "LogInView")
                    
                    self.present(controller, animated: true, completion: nil)
                    
                })
                
                //  Present it.
                self.present(alert, animated: true, completion: nil)
                
                //  Stop animating the activityIndicator, the process has finished.
                self.activityIndicator.stopAnimating()
                
                //  Register any tapping that the user makes when this process finishes.
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            
        })
        
    }
    
    //  User taps on cancel, dismiss this ViewController.
    @IBAction func cancel(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //  Function to dismisss the keyboard when the return key is tapped on.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return false
    }


}
