//
//  CampaignCollectionViewCell.swift
//  GivDapps
//
//  Created by Guillermo Colin on 7/29/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import UIKit
import Firebase

/*  This CampaignCollectionViewCell.swift file if for creating a custom cell to be displayed in the CampaignsViewController*/
class CampaignCollectionViewCell: UICollectionViewCell {
    
    /*  All of the CampaignCollectionViewCell attributes -- Start*/
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var userProfilePic: UIImageView!
    
    @IBOutlet weak var campaignPic: UIImageView!
    /*  All of the CampaignCollectionViewCell attributes -- End*/
        
}
