//
//  SignInViewController.swift
//  GivDapps
//
//  Created by Guillermo Colin on 7/21/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


/*  IMPORTANT: The variable currentUser of type User is a glabal variable that can be used while using the app.
    This variable holds info suchas as first name, last name, etc... Do not delete*/
var currentUser:User?


class SignInViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        //  Instantiate delegates for UITextFields where appropriate.
        emailTF.delegate = self
        passwordTF.delegate = self
        
        //  activityIndicator setup.
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*  Outlets to the UITextFields of this View -- Start*/
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    /*  Outlets to the UITextFields of this View -- End*/
    
    //  Outlet to the UIActivityIndicatorView of this View.
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //  User taps on Sign In, then try signing in.
    @IBAction func signIn(_ sender: UIButton) {
        
        signInUser(emailTextField: emailTF, passwordTextField: passwordTF, activityInd: activityIndicator)
        
    }
    
    //  User taps on Take a Tour, then present the TourSlideViewController to the user.
    @IBAction func takeATour(_ sender: UIButton) {
        
        //  Instantiate storyBoard.
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        //  Intantiate View Controller.
        let ViewController = storyBoard.instantiateViewController(withIdentifier: "TourSlidesViewController")
        
        //  Present Tour to the user.
        self.present(ViewController, animated: true, completion: nil)
        
    }

    //  Function to sign in the user (used in signIN()).
    func signInUser(emailTextField: UITextField, passwordTextField: UITextField, activityInd: UIActivityIndicatorView) {
        
        //  Indicate an operation is taking place behind the scenes.
        activityIndicator.startAnimating()
        
        //  Ignore any tapping that the user makes while this process occurs.
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //  Make sure you have an email and a password.
        guard let userEmail:String = emailTextField.text, let userPassword:String = passwordTextField.text else {
            return
        }
        
        //  Sign in using Firebase's method.
        Auth.auth().signIn(withEmail: userEmail, password: userPassword, completion: { (user,error) in
            
            //  Error occured while signing in. Notify the user.
            if(error != nil){
                
                print(error?.localizedDescription ?? "Error signing in")
                
                //  If user provides invalid log in credentials or there is problem, then alert the user.
                let alert = UIAlertController(title:"Ooops", message: "Check your log in credentials or try again later.", preferredStyle: .alert)
                
                //  Add an OK button to dismiss it.
                alert.addAction(UIAlertAction(title:"OK", style: .cancel,handler: nil))
                
                //  Present it.
                self.present(alert, animated: true, completion: nil)
                
                DispatchQueue.main.async {
                    
                    //  Stop animating the activityIndicator, the process has finished.
                    self.activityIndicator.stopAnimating()
                    
                    //  Register any tapping that the user makes when this process finishes.
                    UIApplication.shared.endIgnoringInteractionEvents()
                
                }
                
            }
            //  Everything went well while signing in.
            else{
                
                DispatchQueue.main.async {
                    
                    //  Stop animating the activityIndicator, the process has finished.
                    self.activityIndicator.stopAnimating()
                    
                    //  Register any tapping that the user makes when this process finishes.
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    //  Request a Firebase snapshot based on the user's uid.
                    let ref = Database.database().reference().child("User").child((user?.uid)!).observe(.value, with: {
                        snapshot in
                        
                        //  Compose the user from the Firebase snapshot retrieved.
                        currentUser = User(snapshot: snapshot)
                        
                    })
                }
                
                /*  Navigate user to the RevealView (or sliding menu) */
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let viewController = storyboard.instantiateViewController(withIdentifier: "RevealView")
                
                self.present(viewController, animated: true, completion: nil)

                
            }
        })
        
    }


    //  Function to dismisss the keyboard when the return key is tapped on.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}




