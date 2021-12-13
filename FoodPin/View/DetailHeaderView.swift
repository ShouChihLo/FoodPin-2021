//
//  DetailHeaderView.swift
//  FoodPin
//
//  Created by NDHU_CSIE on 2021/11/22.
//

import UIKit

/* This class is for modeling views on the table header of the detailview controller */

class DetailHeaderView: UIView {

    @IBOutlet var headerImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var typeLabel: UILabel!
    
    @IBOutlet var heartButton: UIButton!
    
    @IBOutlet var ratingImageView: UIImageView!

}
