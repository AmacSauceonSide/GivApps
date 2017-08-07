//
//  SignInViewController.swift
//  GivDapps
//
//  Created by Guillermo Colin on 7/21/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import UIKit
import FirebaseAuth


class SignInViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.hideKeyboardWhenDone()
        emailTF.delegate = self
        passwordTF.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    
    @IBAction func signIn(_ sender: UIButton) {
        signInUser(emailTextField: emailTF, passwordTextField: passwordTF)
    }
    
    
    
    @IBAction func takeATour(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let ViewController = storyBoard.instantiateViewController(withIdentifier: "TourSlidesViewController")
        
        self.present(ViewController, animated: true, completion: nil)
        
    }

    
    func signInUser(emailTextField: UITextField, passwordTextField: UITextField) {
        
        guard let userEmail:String = emailTextField.text, let userPassword:String = passwordTextField.text else {
            return
        }
        

        Auth.auth().signIn(withEmail: userEmail, password: userPassword, completion: { (user,error) in
            if(error != nil){
                print(error?.localizedDescription ?? "Error signing in")
            }
            else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "UserProfileView")
                self.present(viewController, animated: true, completion: nil)
            }
        })
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

extension UIViewController{
    
    func hideKeyboardWhenDone(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    

}


/*extension UITextField:UITextFieldDelegate{
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}*/
