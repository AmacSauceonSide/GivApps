//
//  CampaignsViewController.swift
//  GivDapps
//
//  Created by Guillermo Colin on 7/22/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import UIKit

class CampaignsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 6
        displayMenu = false
        // Do any additional setup after loading the view.
        
        
        
        // testing
        //setUpMenuBar()
        // end testing
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
        return optionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MenuCollectionViewCell
        
        cell.cellButton.setTitle(optionArray[indexPath.row], for: .normal)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //<#code#>
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
