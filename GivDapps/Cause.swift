//
//  Cause.swift
//  GivDapps
//
//  Created by Guillermo Colin on 8/9/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import Foundation

//  Class Cause - defines the attributes and behavior for the causes that exist in the database.
class Cause{
    
    /* All of the user's attributes -- Start*/
    var causeName:String?
    
    var nonProfit:String?
    
    var description:String?
    
    var userName:String?
    
    var category:String?
    
    var totalGoal:Double?
    
    var timeStart:String?
    
    var timeEnd:String?
    
    var remaining:Double?
    
    var nOfDonors:Int?
    /* All of the user's attributes -- End*/
    
    
    
    //  Function to compose a cause with the information retrieved from Firebase. Using a dict as a parameter.
    func composeCause(valueDict: [String:Any]) {
        
        self.causeName = valueDict["Name"] as? String
        self.nonProfit = valueDict["NonProfit"] as? String
        self.description = valueDict["Description"] as? String
        self.userName = valueDict["UserName"] as? String
        self.category = valueDict["Category"] as? String
        self.totalGoal = valueDict["Total_Goal"] as? Double
        self.timeStart = valueDict["Time_Start"] as? String
        self.timeEnd = valueDict["Time_End"] as? String
        self.remaining = valueDict["Remaining"] as? Double
        self.nOfDonors = valueDict["Donors"] as? Int
        
    }
}
