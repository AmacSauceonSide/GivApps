//
//  InNeedViewController.swift
//  GivDapps
//
//  Created by Guillermo Colin on 8/7/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import UIKit

class InNeedViewController: UIViewController{
    
    var needDescription:String = ""
    
    var totalGoal:Double = 0.0

    var daysLeft:Int = 0
    
    var remaining:Double = 0
    
    var donors:Int = 0
    
    //var campaignsVC = CampaignsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTV.text = needDescription
        
        totalGoalLabel.text = "$" + String(totalGoal)
        
        daysLeftLabel.text = String(daysLeft)
        
        remainingLabel.text = "$" + String(remaining)
        
        donorsLabel.text = String(donors)
        
        //print("Getting description: \(needDescription)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var descriptionTV: UITextView!
    
    @IBOutlet weak var totalGoalLabel: UILabel!
    
    @IBOutlet weak var remainingLabel: UILabel!
    
    @IBOutlet weak var daysLeftLabel: UILabel!
    
    @IBOutlet weak var donorsLabel: UILabel!
    
    @IBAction func donate(_ sender: UIButton) {

    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    
    /*func calculateDaysLeft(date1: String, date2:String) ->Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/DD/YYYY"
        let startDate = dateFormatter.date(from: date1)
        let endDate = dateFormatter.date(from: date2)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate!, to: endDate!)
        
        let differenceInDays = components.day
        
        //daysLeft = differenceInDays!
        return differenceInDays!
    }*/
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "CauseDetailsSegue" {
            
            let VC:CampaignsViewController = segue.destination as! CampaignsViewController
            
            VC.delegate = self
            
            print("Segue called")
            
        }
        
    }
    */

}


