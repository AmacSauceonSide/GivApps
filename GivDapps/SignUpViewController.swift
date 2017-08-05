//
//  SignUpViewController.swift
//  GivDapps
//
//  Created by Guillermo Colin on 7/19/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var ref:DatabaseReference!
    
    //  UITextFields.
    @IBOutlet weak var firstNameTF: UITextField!
    
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    //  ScrollView to adjust the view when typing requires it.
    @IBOutlet weak var scrollView: UIScrollView!
    
    //  Views.
    @IBOutlet weak var innerView: UIView!
    
    //  UIImageViews.
    @IBOutlet weak var profileImage: UIImageView!
    
    //  Action to add a profile pic when the plus symbol is tapped on.
    @IBAction func addProfilePic(_ sender: UIButton) {
        print("Add image button pressed")
        let alertController = UIAlertController(title: "Choose image", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (action) -> Void in
            self.showPicker(sourceType: .photoLibrary)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //  User taps on the Done button.
    @IBAction func done(_ sender: UIButton) {
        
        //  If all fields were completed grant access to the next step.
        if completedFields(){
            print("\nAll fields completed\n")
            ref.child("Test").setValue("Received")
        }
            //  Else alert the user.
        else{
            
            let alert = UIAlertController(title: "Incomplete Fields", message: "Make sure you fill out every field.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title:"OK", style: .cancel, handler:{ (UIAlertAction) in
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func alreadyHaveAccount(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*  Custom Functions - Start */
    
    //  Function to allo the user to show the picture
    func showPicker(sourceType: UIImagePickerControllerSourceType){
        
        //  Create an imagePicker to be presented.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    //  Function to check that all fields are completed.
    func completedFields() -> Bool{
        
        //  Variable to return either true or false based on the logic.
        var allFieldsCompleted:Bool = false
        
        //  Variable keeping track of emtpy fields.
        var numberOfEmptyFields:Int = 0
        
        //  Loop for every field in the innerView.
        for field  in self.innerView.subviews {
            
            //  Current field is a UITextField
            if let textField = field as? UITextField{
                
                //  Check wether UITextField is empty or not.
                let emptyField:Bool = (textField.text?.isEmpty)!
                
                //  Switch based on the boolean value.
                switch emptyField {
                   //   If there is an empty UITextField then add one to the numberOfEmptyFields.
                case true:
                    
                    numberOfEmptyFields += 1
                    
                default:
                    print()
                }
                
            }
            
        }
        
        //  If all textfields were completed, set allFieldsCompleted to true.
        if(numberOfEmptyFields <= 0){
            allFieldsCompleted = true
        }
        
        return allFieldsCompleted
    }
    
    /*  Custom Functions - End */
    
    
    /*  Functions from delegates - Start */
    
    //  Function to perform operations, such as choosing the profile picture, once an image is selected.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let theInfo:NSDictionary = info as NSDictionary
        
        let img:UIImage = theInfo.object(forKey: UIImagePickerControllerOriginalImage) as! UIImage
        
        profileImage.image = img
        
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
    }

    //  Function to remove the keyboard if the user taps on Remove button.
    func doneClicking(){
        view.endEditing(true)
    }
    
    
    //  Function to readjust the view if the keyboard covers the current UITextField.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
            case emailTF:
                self.scrollView.setContentOffset(CGPoint(x:0, y:250) , animated: true)
            
            case passwordTF:
                
                self.scrollView.setContentOffset(CGPoint(x:0, y:250) , animated: true)
            
            default:
                print()
        }
        
    }
    
    //  Function to readjust the view if the user ends editing the current UITextField.
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }
    
    //  Function to go to the next UITextField whenver the Next button is available on the keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Increment the tag of UITextField by 1.
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        }
        else {
            // Remove keyboard.
            textField.resignFirstResponder()
        }
        
        return false
        
    }
    
    //  Function to remove the keyboard if the user clicks elsewhere/outside of the UITextField.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    /*  Functions from delegates - End */
}
