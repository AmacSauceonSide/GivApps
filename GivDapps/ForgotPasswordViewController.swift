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

        
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        
        emailTF.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func getNewPassword(_ sender: UIButton) {
        
        //  Indicate an operation is taking place behind the scenes.
        activityIndicator.startAnimating()
        
        //  Ignore any tapping that the user makes while this process occurs.
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        guard let userEmail:String = emailTF.text else{
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: userEmail, completion: { error in
            
            if error != nil{
                
                //  Alert the user that an email has been sent to reset password.
                let alert = UIAlertController(title:"Ooops!", message: "Did you provide the right log in credentials?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title:"OK", style: .cancel,handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                self.activityIndicator.stopAnimating()
                
                //  Register any tapping that the user makes when this process finishes.
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            else{
                
                //  Alert the user that an email has been sent to reset password.
                let alert = UIAlertController(title:"Check your email!", message: "Check for an email from us to reset your password.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title:"OK", style: .cancel){ action in
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "LogInView")
                    self.present(controller, animated: true, completion: nil)
                    
                })
                
                self.present(alert, animated: true, completion: nil)
                
                self.activityIndicator.stopAnimating()
                
                //  Register any tapping that the user makes when this process finishes.
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            
        })
        
    }
    
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
