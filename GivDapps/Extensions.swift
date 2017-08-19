//
//  Extensions.swift
//  GivDapps
//
//  Created by Guillermo Colin on 8/14/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import Foundation
import FirebaseStorage

//  Declare imgCache of type NSCache.
let imgCache = NSCache<NSString, AnyObject>()

/*  Helper Extension for the UIIMageView*/
extension UIImageView {
    
    /*
        Might use this for the collection view in the campaigns controller.
     */

    //  Function to load the image.
    func loadIMG(URL_String: String){
        
        //  Set image to the blank_profile_pic.
        self.image = UIImage(named: "blank_profile_pic")
        
        //  Check if image exists in cache first. If it does then do NOT trigger a dataTask.
        if let cachedImage = imgCache.object(forKey: URL_String as NSString) as? UIImage{
            print("Thinks it's already cached")
            self.image = cachedImage
            return
        }
        
        //  Else perform a download wit the given URL.
        let url = URL(string: URL_String)
            print("Profile img needed to be fetched")
        
        
            URLSession.shared.dataTask( with: url!, completionHandler: { (data, response, error) in
                print("getting in URLSession")
                if error != nil {
                    print(error.debugDescription)
                    return
                }
            
                    DispatchQueue.main.async {
                
                        if let downloadedImage = UIImage(data: data!){
                    
                            imgCache.setObject(downloadedImage, forKey: URL_String as NSString)
                    
                            self.image = downloadedImage
                    
                        }
                
                    }
                }).resume()
        
    }
}


/*  Helper Extension for the UIViewController   */
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

