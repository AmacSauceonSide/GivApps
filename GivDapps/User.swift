//
//  User.swift
//  GivDapps
//
//  Created by Guillermo Colin on 8/5/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import Foundation
import FirebaseDatabase

//  The class User composes the donor using the app.
class User{
    
    /* All of the user's attributes -- Start*/
    var firstName:String? = nil
    
    var lastName:String? = nil
    
    var email:String? = nil
    
    var profileImgURL:String? = nil
    /* All of the user's attributes -- End*/
    
    
    //  Init the user for when creating a user to be registered.
    init(firstN:String, lastN:String, email:String, profilePicURL: String?) {
        
        self.firstName = firstN
        
        self.lastName = lastN
        
        self.email = email
        
        self.profileImgURL = profilePicURL
    }
    
    // Init the user when retrieve user data from a Firebase snapshot. User MUST exist in the database to do this.
    convenience init?(snapshot:DataSnapshot){
        
        //  Get the results using a userDict.
        let userDict = snapshot.value as! [String:Any]
        
        //  Collect all the essential data.
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

        //  Return nil if there's any errors along the way.
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
