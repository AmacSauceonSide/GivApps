//
//  DummyCauseViewController.swift
//  GivDapps
//
//  Created by Guillermo Colin on 8/8/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import UIKit
import Firebase

class DummyCauseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var causeNameTF: UITextField!
    
    @IBOutlet weak var categoryTF: UITextField!
    
    @IBOutlet weak var descriptionTF: UITextField!
    
    @IBOutlet weak var timeStartTF: UITextField!
    
    
    @IBOutlet weak var timeEndTF: UITextField!
    
    @IBOutlet weak var totalGoalTF: UITextField!
    
    var ref:DatabaseReference!
    
    
    @IBAction func save(_ sender: UIButton) {
        
        let values:[String:AnyObject] = [
            "Name": causeNameTF.text as AnyObject,
            "Category" : categoryTF.text as AnyObject,
            "Description" : descriptionTF.text as AnyObject,
            "Time_Start" : timeStartTF.text as AnyObject,
            "Time_End" : timeEndTF.text as AnyObject,
            "Total_Goal": Double(totalGoalTF.text!)! as AnyObject
        ]
        
        ref.child("Campaign/Cause").childByAutoId().setValue(values, withCompletionBlock: { (error, ref) in
            
            if(error != nil){
                print("Error saving your data")
            }else{
                print("Data Saved")
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
