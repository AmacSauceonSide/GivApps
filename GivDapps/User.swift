//
//  User.swift
//  GivDapps
//
//  Created by Guillermo Colin on 8/5/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import Foundation
import FirebaseDatabase

class User{
    
    var firstName:String? = nil
    var lastName:String? = nil
    var email:String? = nil
//    var foundationName:String? = nil
//    var userType:String? = nil                    //This one might be set to "Donor" eventually
    var profileImgURL:String? = nil
    
    //  Init for when creating a user to be registered.
    init(firstN:String, lastN:String, email:String, profilePicURL: String?) {
        self.firstName = firstN
        self.lastName = lastN
        self.email = email
        self.profileImgURL = profilePicURL
    }
    
    convenience init?(snapshot:DataSnapshot){
        
        let userDict = snapshot.value as! [String:Any]
        
        if let first = userDict["First_Name"] as? String{
            if let last = userDict["Last_Name"] as? String{
                if let email = userDict["Email"] as? String{
                    if let profileImgURL = userDict["ProfileIMGURL"] as? String{
                        self.init(firstN:first, lastN:last, email: email, profilePicURL: profileImgURL)
                        return
                    }
                }
            }
        }
        
        /*if let uid = snapshot.key{
            
            /*let userDict = snapshot.value as! [String:Any]
            
            if let first = userDict["First_Name"] as? String{
                
            }*/

        }*/
        
        self.init(firstN: "", lastN: "", email: "", profilePicURL: "")
        return nil
    }
    
    //  Return the user's basic info -- used for when registering a user.
    var basicUserInfo:[String: AnyObject]{
        return [
            "First_Name": firstName! as AnyObject,
            "Last_Name":lastName! as AnyObject,
            "Email":email! as AnyObject,
            "ProfileIMGURL":profileImgURL as AnyObject
        ]
    }
    
}
