//
//  Extensions.swift
//  GivDapps
//
//  Created by Guillermo Colin on 8/14/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import Foundation
import FirebaseStorage

let imgCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    /*
        Might need this for the collection view in the campaigns controller
        https://www.youtube.com/watch?v=GX4mcOOUrWQ&spfreload=5
     */

    func loadIMG(URL_String: String){
        
        //self.image = nil
        self.image = UIImage(named: "blank_profile_pic")
        
        //  Check if image exists in cache first
        if let cachedImage = imgCache.object(forKey: URL_String as NSString) as? UIImage{
            print("Thinks it's already cached")
            self.image = cachedImage
            return
        }
        
        //  Else perform a download
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
                    
                    print("We might be getting a picture")
                }
                
            }
        }).resume()
        
    }
}

/*extension UIImage{
    func getProfilePic(URL_String: String) -> UIImage{
        var someIMG:UIImage?
        //  Else perform a download
        let URL = NSURL(string: URL_String)
        URLSession.shared.dataTask( with: URL! as URL, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!){
                    
                    imgCache.setObject(downloadedImage, forKey: URL_String as AnyObject)
                    
                    someIMG = downloadedImage
                }
                
                
            }
            return someIMG
        })
        
    }
}*/
