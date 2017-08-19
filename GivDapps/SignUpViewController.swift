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
        
        //  Set up the reference to the database.
        ref = Database.database().reference()
        
        //  activityIndicator setup.
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  Reference to the database.
    var ref:DatabaseReference!
    
    /*  Outlets to the UITextFields of this View -- Start*/
    @IBOutlet weak var firstNameTF: UITextField!
    
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    /*  Outlets to the UITextFields of this View -- End*/
    
    //  Outlet to the UIActivityIndicatorView of this View.
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //  Outlet to the profileImage
    @IBOutlet weak var profileImage: UIImageView!
    
    //  ScrollView to adjust the view when typing requires it.
    @IBOutlet weak var scrollView: UIScrollView!
    
    //  Additional Views.
    @IBOutlet weak var innerView: UIView!
    
    // Variable used for manipulation of the profile image.
    var img:UIImage? //= UIImage(named: "blank_profile_pic")
    
    //  Action to add a profile pic when the plus symbol is tapped on.
    @IBAction func addProfilePic(_ sender: UIButton) {
        
        //  Create an alertController to allow the user to select a picture from the Camera Roll.
        let alertController = UIAlertController(title: "Choose image", message: nil, preferredStyle: .actionSheet)
        
        //  Offer the Camera Roll option.
        alertController.addAction(UIAlertAction(title: "Camera Roll", style: .default, handler: { (action) -> Void in
            self.showPicker(sourceType: .photoLibrary)
        }))
        
        //  Allow to cancel.
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //  Present alertController.
        self.present(alertController, animated: true, completion: nil)
    }
    
    //  User taps on the Done button.
    @IBAction func done(_ sender: UIButton) {
        
        //  If all fields were completed grant access to the next step.
        if completedFields(){
            
            //  Register the user with his/her basic info.
            registerUser(firstN: firstNameTF, lastN: lastNameTF, email: emailTF, password: passwordTF)
            
        }
            
        //  Else alert the user.
        else{
            
            //  Create alert for the user to be notified of error.
            let alert = UIAlertController(title: "Incomplete Fields", message: "Make sure you fill out every field.", preferredStyle: .alert)
            
            //  Add an OK button to dismiss it.
            alert.addAction(UIAlertAction(title:"OK", style: .cancel, handler:{ (UIAlertAction) in
            }))
            
            //  Present it.
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    //  If the user taps on 'Already have an account?' then dismiss the Sign Up View.
    @IBAction func alreadyHaveAccount(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    
    //  Function to allo the user to show the picture
    func showPicker(sourceType: UIImagePickerControllerSourceType){
        
        //  Create an imagePicker to be presented.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        
        //  Present the UIImagePickerController to the user.
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
                        break
                    
                    //  Default: just break
                    default:
                        break
                }
            }
        }
        
        //  If all textfields were completed, set allFieldsCompleted to true.
        if(numberOfEmptyFields <= 0){
            allFieldsCompleted = true
        }
        
        return allFieldsCompleted
    }
    

    
    
    
    /*  Functions from delegates - Start */
    
    
    
    //  Function to perform operations, such as choosing the profile picture, once an image is selected.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        //  User selects an original image from the camera roll.
        if let currentImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //  Set the image equals to the currentImage (the image just chosen)
            img = currentImage
            
            //  Set profileImage.image equals to the currentImage (the image just chosen)
            profileImage.image = img
            
        }
       
        //  Dismiss the imagePickerController when done.
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
    }

    
    //  Function to remove the keyboard if the user taps on Remove button.
    func doneClicking(){
        view.endEditing(true)
    }
    
    
    //  Function to readjust the view if the keyboard covers the current UITextField.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //  Move the innerView a little higher so that the textField can be seen.
        switch textField {
            
            case emailTF:
                
                self.scrollView.setContentOffset(CGPoint(x:0, y:250) , animated: true)
                break
            
            case passwordTF:
                
                self.scrollView.setContentOffset(CGPoint(x:0, y:250) , animated: true)
                break
            
            default:
                break
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
                    
                    //  Stop animating the activityIndicator, the process has finished.
                    self.activityIndicator.stopAnimating()
                    
                    //  Register any tapping that the user makes when this process finishes.
                    UIApplication.shared.endIgnoringInteractionEvents()
                }

            }else{
                
                //Testing
                
                
                switch self.img {
                    case nil:
                        
                        guard let uid = user?.uid else{
                            return
                        }
                        
                        let userReference = self.ref.child("User").child(uid)
                        
                        let newUser = User(firstN: userFirstN, lastN: userLastN, email: userEmail, profilePicURL: nil)
                        userReference.updateChildValues(newUser.basicUserInfo, withCompletionBlock:{ (error, ref) in
                            if (error != nil){
                                print(error?.localizedDescription ?? "Error Saving user data")
                            }
                            else{
                                print("\nUser Profile Successfully created\n")
                                
                                /*  Navigate user to the LogInView  */
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                
                                let controller = storyboard.instantiateViewController(withIdentifier: "LogInView")
                                
                                self.present(controller, animated: true, completion: nil)
                            }
                            DispatchQueue.main.async {
                                
                                //  Stop animating the activityIndicator, the process has finished.
                                self.activityIndicator.stopAnimating()
                                
                                //  Register any tapping that the user makes when this process finishes.
                                UIApplication.shared.endIgnoringInteractionEvents()
                            }
                            
                        })

                            break
                    default:
                        let imgUUID = NSUUID().uuidString
                        let storage = Storage.storage().reference().child("profilePic").child("\(imgUUID).png")
                        
                        if let uploadData = UIImagePNGRepresentation(self.img!){
                            storage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                if error != nil{
                                    print(error.debugDescription)
                                    return
                                }
                                if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                                    
                                    let newUser = User(firstN: userFirstN, lastN: userLastN, email: userEmail, profilePicURL: profileImageURL)
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
                                        
                                        //  Stop animating the activityIndicator, the process has finished.
                                        self.activityIndicator.stopAnimating()
                                        
                                        //  Register any tapping that the user makes when this process finishes.
                                        UIApplication.shared.endIgnoringInteractionEvents()
                                    }
                                }
                            })
                        }
                            break
                }
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
