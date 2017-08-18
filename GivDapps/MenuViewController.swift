//
//  MenuViewController.swift
//  GivDapps
//
//  Created by Guillermo Colin on 8/13/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
  
        //  Set the profile picture as soon as the user gets to this view.
        setProfilePic(user: currentUser, imgView: profileImage)
        
        //  Custom setup for the profile image -- Circular image.
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        //  activityIndicator setup.
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  Outlet to the tableView.
    @IBOutlet var tableView: UITableView!
    
    //  Outlet to the profileImage.
    @IBOutlet weak var profileImage: UIImageView!
    
    //  Outlet to the activityIndicator.
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //  Temporary array of settings available.
    lazy var settingArray:[String] = {
        return ["Account", "About"]
    }()
    
    // Variable used for manipulation of the profile image.
    var img:UIImage? = UIImage(named: "blank_profile_pic")
    
    //  User taps on the sign out button.
    @IBAction func signOut(_ sender: UIButton) {
        
        if Auth.auth().currentUser != nil {
            
            do {
                //  Sign the user out.
                try Auth.auth().signOut()
                
                //  Set the currentUser to nil.
                currentUser = nil
                
                //  Present the LogInView once again.
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInView")
                present(vc, animated: true, completion: nil)
                
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    //  User taps on the + button to add a profile image.
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
    
    /* UITableView functions -- Start */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.textLabel?.text = settingArray[indexPath.row]
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected some row!")
    }
    /* UITableView functions -- End */
    
    //  Function to perform operations, such as choosing the profile picture, once an image is selected.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //  User selects an original image from the camera roll.
        if let currentImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            img = currentImage

            changeProfileImg(user: currentUser, activityInd: activityIndicator)
        }
        
        //  Dismiss the imagePickerController when done.
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
    }
    
    //  Function to set the user's profile picture.
    func setProfilePic(user:User?, imgView: UIImageView){
        
        //  Get the image from the Firebase storage if the user has one.
        if let imgURL:String = user?.profileImgURL{
            imgView.loadIMG(URL_String: imgURL)
        }
        //  Else, just use the blank_profile_pic
        else{
            imgView.image = UIImage(named: "blank_profile_pic")
        }
        
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
    
    
    //  Function to set a new profile picture while on menu.
    func changeProfileImg(user: User?, activityInd:UIActivityIndicatorView) {
        
        //  Boolean flag to check if user has a profile picture.
        var hasProfilePic:Bool = false
        
        //  If the user currently has a profileImgURL, then the user has a picture in the storage too.
        if (user?.profileImgURL) != nil {
            hasProfilePic = true
        }
        
        //  Switch based on the hasProfilePic boolean flag.
        switch hasProfilePic{
        
            //  User does have a profile image
            case true:
                deleteAndReplaceProfilePic(user: currentUser!, imgView: profileImage, image: img!, activityInd: activityIndicator)
                break
            
            //  User does NOT have a profile image
            default:
                setNewProfileImg(activityInd: activityInd, image: img!)
                break
            
        }
        
    }
    
    
    //  Function to set a new profile image, assuming that the user does not have a current profile image.
    func setNewProfileImg(activityInd: UIActivityIndicatorView, image: UIImage){
        
        activityInd.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let imgUUID = NSUUID().uuidString
        
        let storage = Storage.storage().reference().child("profilePic").child("\(imgUUID).png")
        
        if let uploadData = UIImagePNGRepresentation(image){
            
            storage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                    
                    let userID = Auth.auth().currentUser?.uid
                    
                    let userReference = Database.database().reference().child("User").child(userID!)
                    
                    userReference.updateChildValues(["ProfileIMGURL": profileImageURL], withCompletionBlock:{ (error, ref) in
                        
                        if (error != nil){
                            self.activityIndicator.stopAnimating()
                            print(error?.localizedDescription ?? "Error Saving user data")
                        }
                        else{
                            self.activityIndicator.stopAnimating()
                            print("User's new profile pic uploaded succesfully!")
                            self.profileImage.image = image
                            
                        }
                        
                    })
                    
                    DispatchQueue.main.async {
                        activityInd.stopAnimating()
                        
                        //  Register any tapping that the user makes when this process finishes.
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                }
            })
        }
        
    }
    
    
    //  Function to delete the current profile picture. Also delete the URL reference to that picture from the user.
    func deleteAndReplaceProfilePic(user: User, imgView: UIImageView, image: UIImage,activityInd: UIActivityIndicatorView){
        
        //  Reference to the database.
        let ref = Database.database().reference()
        
        //  Referance to the storage with reference to the URL of the profile image.
        let storageRef = Storage.storage().reference(forURL: user.profileImgURL!)
        
        //  Delete the image from storage.
        storageRef.delete(completion: { error in
            
            //  Error exits.
            if error != nil{
                
                //  Alert the user there was an error deleting the profile image.
                let alert = UIAlertController(title: "Error", message: "There was an error deleting your image. Please try again later.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
            }
            //  Everything okay, no errors.
            else{
                
                //  Set user's profileImgURL back to nil
                user.profileImgURL = nil
                
                //  Change profile's UIImageView to the standard blank profile pic.
                imgView.image = UIImage(named: "blank_profile_pic")
                
                    DispatchQueue.main.async {
                        
                        //  Also delete the ProfileIMGURL from the user so that there's no reference to the image just deleted.
                        if let uid = Auth.auth().currentUser?.uid{
                            
                            ref.child("User").child(uid).child("ProfileIMGURL").removeValue(completionBlock: { (error, ref) in
                                
                                if error != nil {
                                    print(error?.localizedDescription ?? "Error, perhaps?")
                                }
                                else{
                                    
                                    print("Success!! Image reference also deleted from the user.")
                                    
                                    //  If everything so far goes well, set the new profile image.
                                    self.setNewProfileImg(activityInd: activityInd, image: image)
                                
                                }
                           })
                    }
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

}
