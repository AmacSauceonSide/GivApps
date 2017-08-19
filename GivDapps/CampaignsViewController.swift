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
        
        //  Set up the reference to the database.
        ref = Database.database().reference()
        
        
        getCauses(ref: ref)


        
        //  Instantiate the delegate and dataSource for the campaignCollectionView (type UICollectionView)
        campaignCollectionView.delegate = self
        campaignCollectionView.dataSource = self
        
        /*  IMPORTANT - This is the 'menu' set up   */
        menu.target = self.revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*  Outlet to the campaignCollectionView of type UICollectionView   */
    @IBOutlet weak var campaignCollectionView: UICollectionView!
    
    /*  Outlet to the menu button of type UIBarButtonItem   */
    @IBOutlet var menu: UIBarButtonItem!
    
    //  Reference to the database.
    var ref:DatabaseReference!
    
    //  Array to hold all the campaing causes retrieved from Firebase.
    var campaings = [Cause]()
    
    
    
//    func setUpHorizontalBar(){
//        
//        let horizontalBarView = UIView()
//        horizontalBarView.backgroundColor = UIColor(white: 0.95, alpha: 1)
//        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
//        
//    }
    

    /*  Delegate methods for collectionView (used for campaignCollectionView)--Start    */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //  Switch based on the collectionView. Return the appropriate number of cell count.
        switch collectionView {
            
            case campaignCollectionView:
                
                return campaings.count
            
            default:

                return 0
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //  Instantiate cell as CampaignCollectionViewCell.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CampaignCell", for: indexPath) as! CampaignCollectionViewCell
        
        //  If there were campaigns retrieved, then set them up.
        if(campaings.count > 0){
            
            cell.userNameLabel.text = campaings[indexPath.row].userName
            cell.descriptionLabel.text = campaings[indexPath.row].description
            cell.companyLabel.text = campaings[indexPath.row].nonProfit
            
        }
        
        return cell

        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //  Nothing yet/
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //  Not using cell currently.
        //let cell = collectionView.cellForItem(at: indexPath) as! CampaignCollectionViewCell

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let inNeedVC = storyboard.instantiateViewController(withIdentifier: "InNeedView") as! InNeedViewController

        inNeedVC.needDescription = campaings[indexPath.row].description!
        inNeedVC.totalGoal = campaings[indexPath.row].totalGoal!
        inNeedVC.daysLeft = calculateDaysLeft(date1: campaings[indexPath.row].timeStart!, date2: campaings[indexPath.row].timeEnd!)
        inNeedVC.remaining = campaings[indexPath.row].remaining!
        
        
        self.present(inNeedVC, animated: true, completion: nil)
        
        
    }
    /*  Delegate methods for collectionView (used for campaignCollectionView)--End    */
    
    
    //  Function to retrieve all the causes that exist in the database.
    func getCauses(ref:DatabaseReference) {
        
        //  Retrieve all Causes within Campaigns.
        ref.child("Campaign/Cause").observe(.value, with: { snapshot in
            
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                
                //  Iterate through all causes.
                for child in result{
                    
                    //  Collect values in a Dictionary [String:Any]
                    let causeValues = child.value as! [String:Any]
                    
                    //  Create a cause.
                    let cause = Cause()
                    
                    //  Compose a cause based on the data retrieved using this query.
                    cause.composeCause(valueDict: causeValues)
                    
                    //  append to the campaigns array.
                    self.campaings.append(cause)
                    
                }
                
            }
                //  Reload data to display all causes. You need this in order to display data correctly.
                DispatchQueue.main.async {
                    
                    self.campaignCollectionView.reloadData()
                    
                }
            
        })
        
    }
    

    //  Function to calculate the number of days left from the two dates retrieved (Starting/Ending dates).
    func calculateDaysLeft(date1: String, date2:String) ->Int {
        
        //  date formatter used.
        let dateFormatter = DateFormatter()
        
        /*  IMPORTANT - You need to have the date formatted in this manner, otherwise difference in days is not computed correctly.    */
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        //  Initialize the start date.
        let startDate = dateFormatter.date(from: date1)!
        
        //  Initialize the end date.
        let endDate = dateFormatter.date(from: date2)!
        
        //  Initialize a current calendar.
        let calendar = Calendar.current
        
        //  Get the components (difference) in days.
        let components = calendar.dateComponents([.day], from: startDate, to: endDate).day
        
        return components!
    }
    

}
