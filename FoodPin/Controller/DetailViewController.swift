//
//  DetailViewController.swift
//  FoodPin
//
//  Created by NDHU_CSIE on 2021/11/8.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: DetailHeaderView!
    
    var restaurant = Restaurant()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        headerView.headerImageView.image = UIImage(named: restaurant.image)
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        
        let heartImage = restaurant.isFavorite ? "heart.fill" : "heart"
        headerView.heartButton.tintColor = restaurant.isFavorite ? .systemYellow : .white
        headerView.heartButton.setImage(UIImage(systemName: heartImage), for: .normal)
        
        navigationItem.largeTitleDisplayMode = .never
    }
}


extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailTextCell.self), for: indexPath) as! DetailTextCell

        cell.descriptionLabel.text = restaurant.summary
        //cell.selectionStyle = .none

        return cell

        case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailTwoColumnCell.self), for: indexPath) as! DetailTwoColumnCell

        cell.column1TitleLabel.text = "Address"
        cell.column1TextLabel.text = restaurant.location
        cell.column2TitleLabel.text = "Phone"
        cell.column2TextLabel.text = restaurant.phone
        //cell.selectionStyle = .none

        return cell

        default:
        fatalError("Failed to instantiate the table view cell for detail view controller")

        }
    }
}

