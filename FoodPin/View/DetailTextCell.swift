//
//  DetailTextCell.swift
//  FoodPin
//
//  Created by NDHU_CSIE on 2021/11/22.
//

import UIKit

/* This class is for modeling views on the prototype cell 1 of the detailview controller */

class DetailTextCell: UITableViewCell {
    
    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
