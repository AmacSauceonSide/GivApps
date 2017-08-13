//
//  CampaignsViewController.swift
//  GivDapps
//
//  Created by Guillermo Colin on 7/22/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import UIKit
import Firebase




class CampaignsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        getCauses(ref: ref)
        //menuView.layer.shadowOpacity = 1
        //menuView.layer.shadowRadius = 6
        displayMenu = false
        // Do any additional setup after loading the view.
        
        campaignCollectionView.delegate = self
        campaignCollectionView.dataSource = self
       
        // testing
        //setUpMenuBar()
        // end testing
        
        menu.target = self.revealViewController()
        menu.action = Selector("revealToggle:")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    var ref:DatabaseReference!
    
    var campaings = [Cause]()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    
    var displayMenu:Bool = false

    @IBOutlet weak var campaignCollectionView: UICollectionView!
    
    
    @IBOutlet var menu: UIBarButtonItem!
    
    
    /*@IBAction func menu(_ sender: UIBarButtonItem) {
        
        
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
    }*/
    
    
    /*let menuBar:MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func setUpMenuBar(){
        view.addSubview(menuBar)
        
        let heightConstraint = menuBar.heightAnchor.constraint(equalToConstant: CGFloat(0))
        let widthConstraint = menuBar.widthAnchor.constraint(equalToConstant: CGFloat(50))
           
        view.addConstraints([heightConstraint, widthConstraint])
        
    }*/
    
    
    
    
    
    
    
    
    
    
    
    func setUpHorizontalBar(){
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        //horizontalBarView.leftAnchor.constraint(equalTo: self.left)
        
        
    }
    
    
    
    
    
    // Testing
    
    var optionArray:[String] = ["Nearby","Popular","Almost Funded","Special",""]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case campaignCollectionView:
            return campaings.count
        default:
            return optionArray.count
        }
        //return optionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case campaignCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CampaignCell", for: indexPath) as! CampaignCollectionViewCell
            
            if(campaings.count > 0){
                
                cell.userNameLabel.text = campaings[indexPath.row].userName
                cell.descriptionLabel.text = campaings[indexPath.row].description
                cell.companyLabel.text = campaings[indexPath.row].nonProfit
                
            }
            
            return cell
            
        default:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MenuCollectionViewCell
            
            cell.cellButton.setTitle(optionArray[indexPath.row], for: .normal)
            
            return cell
        }

        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //<#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CampaignCollectionViewCell

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let inNeedVC = storyboard.instantiateViewController(withIdentifier: "InNeedView") as! InNeedViewController

        inNeedVC.needDescription = campaings[indexPath.row].description!
        inNeedVC.totalGoal = campaings[indexPath.row].totalGoal!
        inNeedVC.daysLeft = calculateDaysLeft(date1: campaings[indexPath.row].timeStart!, date2: campaings[indexPath.row].timeEnd!)
        inNeedVC.remaining = campaings[indexPath.row].remaining!
        
        
        self.present(inNeedVC, animated: true, completion: nil)
        
        
    }
    
    
    //  Function to retrieve all the causes that exist in the database.
    func getCauses(ref:DatabaseReference) {
        
        //  Retrieve all Causes within Campaigns.
        ref.child("Campaign/Cause").observe(.value, with: { snapshot in
            
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                
                //  Iterate through all causes.
                for child in result{
                    
                    let causeValues = child.value as! [String:Any]
                    
                    //  Create a cause.
                    let cause = Cause()
                    
                    //  Compose a cause based on the data retrieved using this query.
                    cause.composeCause(valueDict: causeValues)
                    
                    self.campaings.append(cause)
                    
                }
                
            }
                //  Reload data to display all causes.
                DispatchQueue.main.async {
                    self.campaignCollectionView.reloadData()
                }
            
        })
        
    }
    
    //End testing
    
    
    // MARK: - Navigation
    /*(
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "CauseDetailsSegue"){
            
            if let vc = segue.destination as? InNeedViewController{
                vc.descriptionTV.textColor = UIColor.red
            }
            
            

            /*let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell)
            let cell = collectionView.cellForItem(at: indexPath!) as! CampaignCollectionViewCell
            let newViewController = segue.destination as! InNeedViewController*/
            

            //let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell)
            
          
            //let indexPath = sender as! NSIndexPath
            //let selectedRow: NSManagedObject = locationsList[indexPath.row] as! NSManagedObject
            //newViewController.passedTrip = selectedRow as! Trips
            
            /*if let indexPath = collectionView.indexPathsForSelectedItems{
                delegate? = self as! NeedsDelegate
            }*/
            
            
            /*let indexPath = sender as! NSIndexPath
            let selectedRow*/
            
        }
    }*/
    
    func calculateDaysLeft(date1: String, date2:String) ->Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let startDate = dateFormatter.date(from: date1)!
        let endDate = dateFormatter.date(from: date2)!
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate).day
        
        return components!
    }
    

}
