//
//  Slide4ViewController.swift
//  GivDapps
//
//  Created by Guillermo Colin on 7/26/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import UIKit



class Slide4ViewController: UIViewController{



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  Dismiss the TourSlideViewController. This button should be located on the last slide/ViewController.
    @IBAction func done(_ sender: UIButton) {
        
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        
    }


}
