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
import FirebaseStorage


class SignUpViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
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

            registerUser(firstN: firstNameTF, lastN: lastNameTF, email: emailTF, password: passwordTF)
            
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
    
    var img:UIImage? = UIImage(named: "blank_profile_pic")
    
    //  Function to perform operations, such as choosing the profile picture, once an image is selected.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let theInfo:NSDictionary = info as NSDictionary
        
        if let currentImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            img = currentImage
        }
        
        //img = theInfo.object(forKey: UIImagePickerControllerOriginalImage) as? UIImage
        
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
    
    
    //  Function to register the user
    func registerUser(firstN: UITextField, lastN: UITextField, email: UITextField, password: UITextField){
        
        //  Indicate an operation is taking place behind the scenes.
        self.activityIndicator.startAnimating()
        
        //  Ignore any tapping that the user makes while this process occurs.
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //  User's basic info.
        guard let userFirstN:String = firstN.text, let userLastN:String = lastN.text else {
            return
        }
        
        //  New User Credentials.
        guard let userEmail:String = email.text, let userPassword:String = password.text else {
            return
        }
        
        //  Create new user in the Firebase
        Auth.auth().createUser(withEmail: userEmail, password: userPassword, completion: { (user, error) in
            
            if error != nil{
                print(error!.localizedDescription)
                
                //  If there's an error resgistering the user, then alert the user.
                let alert = UIAlertController(title:"Ooops", message: "We can't register you at the moment. Please try again later.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title:"OK", style: .cancel,handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                DispatchQueue.main.async {
                    
                    self.activityIndicator.stopAnimating()
                    
                    //  Register any tapping that the user makes when this process finishes.
                    UIApplication.shared.endIgnoringInteractionEvents()
                }

            }else{
                
                //Testing
                let imgUUID = NSUUID().uuidString
                let storage = Storage.storage().reference().child("profilePic").child("\(imgUUID).png")
                
                if let uploadData = UIImagePNGRepresentation(self.img!){
                    storage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil{
                            print(error.debugDescription)
                            return
                        }
                        if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                            
                            let newUser = User(firstN: userFirstN, lastN: userLastN, email: userEmail)
                            newUser.profileImgURL = profileImageURL
                            
                            guard let uid = user?.uid else{
                                return
                            }
                            
                            let userReference = self.ref.child("User").child(uid)
                            
                            userReference.updateChildValues(newUser.basicUserInfo, withCompletionBlock:{ (error, ref) in
                                if (error != nil){
                                    print(error?.localizedDescription ?? "Error Saving user data")
                                }
                                else{
                                    print("\nUser Profile Successfully created\n")
                                    
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let controller = storyboard.instantiateViewController(withIdentifier: "LogInView")
                                    self.present(controller, animated: true, completion: nil)
                                }
                                
                            })
                            
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                                
                                //  Register any tapping that the user makes when this process finishes.
                                UIApplication.shared.endIgnoringInteractionEvents()
                            }
                        }
                    })
                }
                
                //End testing
                
                //  Register new user with a user id
                
                //  Does work, deleted for testing only -- Start
                /*guard let uid = user?.uid else{
                    return
                }
                
                let newUser = User(firstN: userFirstN, lastN: userLastN, email: userEmail)
                
                let userReference = self.ref.child("User").child(uid)
                
                userReference.updateChildValues(newUser.basicUserInfo, withCompletionBlock:{ (error, ref) in
                    if (error != nil){
                        print(error?.localizedDescription ?? "Error Saving user data")
                    }
                    else{
                        print("\nUser Profile Successfully created\n")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "LogInView")
                        self.present(controller, animated: true, completion: nil)
                    }
                    
                })
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    
                    //  Register any tapping that the user makes when this process finishes.
                    UIApplication.shared.endIgnoringInteractionEvents()
                }*/
                //  Does work, deleted for testing only -- End

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
    
    /*  Functions from delegates - End */
}
