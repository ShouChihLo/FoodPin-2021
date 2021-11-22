//
//  DetailHeaderView.swift
//  FoodPin
//
//  Created by NDHU_CSIE on 2021/11/22.
//

import UIKit

class DetailHeaderView: UIView {

    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.numberOfLines = 0
        }
    }
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var heartButton: UIButton! 

}
