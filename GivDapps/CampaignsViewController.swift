//
//  CampaignsViewController.swift
//  GivDapps
//
//  Created by Guillermo Colin on 7/22/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import UIKit

class CampaignsViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 6
        displayMenu = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    var displayMenu:Bool = false

    
    
    @IBAction func menu(_ sender: UIBarButtonItem) {
        
        if(displayMenu){
            leadingConstraint.constant = -250
        }
        else{
            leadingConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        displayMenu = !displayMenu
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
