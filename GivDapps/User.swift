//
//  User.swift
//  GivDapps
//
//  Created by Guillermo Colin on 8/5/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import Foundation


class User{
    
    var firstName:String? = nil
    var lastName:String? = nil
    var email:String? = nil
    var foundationName:String? = nil
    var userType:String? = nil
    
    init(firstN:String, lastN:String, email:String) {
        self.firstName = firstN
        self.lastName = lastN
        self.email = email
    }
    
    var basicUserInfo:[String: AnyObject]{
        return [
            "First_Name": firstName! as AnyObject,
            "Last_Name":lastName! as AnyObject,
            "Email":email! as AnyObject
        ]
    }
    
}
