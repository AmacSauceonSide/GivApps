//
//  InNeedViewController.swift
//  GivDapps
//
//  Created by Guillermo Colin on 8/7/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import UIKit

class InNeedViewController: UIViewController{
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*  Set the proper text on these UILabels.  --Start*/
        
        descriptionTV.text = needDescription
        
        totalGoalLabel.text = "$" + String(totalGoal)
        
        daysLeftLabel.text = String(daysLeft)
        
        remainingLabel.text = "$" + String(remaining)
        
        donorsLabel.text = String(donors)
        
        /*  Set the proper text on these UILabels.  --Start*/
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    /* All of the user's attributes -- Start*/
    var needDescription:String = ""
    
    var totalGoal:Double = 0.0
    
    var daysLeft:Int = 0
    
    var remaining:Double = 0
    
    var donors:Int = 0
    /* All of the user's attributes -- End*/
    
    /*  Outlets to the UITextFields of this View -- Start*/
    @IBOutlet weak var descriptionTV: UITextView!
    /*  Outlets to the UITextFields of this View -- End*/
    
    /*  Outlets to the UILabels of this View -- Start*/
    @IBOutlet weak var totalGoalLabel: UILabel!
    
    @IBOutlet weak var remainingLabel: UILabel!
    
    @IBOutlet weak var daysLeftLabel: UILabel!
    
    @IBOutlet weak var donorsLabel: UILabel!
    /*  Outlets to the UILabels of this View -- End*/
    
    /* IMPORTANT -- This is where the user will pay. I'm assuming that STRIPE goes here*/
    @IBAction func donate(_ sender: UIButton) {

    }
    
    //  User taps on Cancel, dismiss this ViewController.
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }



}


