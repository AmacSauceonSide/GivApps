//
//  MenuViewController.swift
//  GivDapps
//
//  Created by Guillermo Colin on 8/13/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import UIKit
import FirebaseAuth

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet var tableView: UITableView!
    
    lazy var settingArray:[String] = {
        return ["Account", "About"]
    }()
    
    
    @IBAction func signOut(_ sender: UIButton) {
        
        if Auth.auth().currentUser != nil {
            
            do {
                
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInView")
                present(vc, animated: true, completion: nil)
                
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.textLabel?.text = settingArray[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected some row!")
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
