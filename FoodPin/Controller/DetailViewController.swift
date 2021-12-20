//
//  DetailViewController.swift
//  FoodPin
//
//  Created by NDHU_CSIE on 2021/11/8.
//

import UIKit

class DetailViewController: UIViewController {
    
    /* Declare a tableView variable pointing to the tableview object, and
     this is required because the controller is not a tableview controller
    */
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: DetailHeaderView!
  
    //This variable will be set with the passed data from the segue
    var restaurant: Restaurant!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect the tableview to the controller itself that provides the method implementation
        tableView.dataSource = self
        tableView.delegate = self
        
        // Config data on the table header
        headerView.headerImageView.image = UIImage(data: restaurant.image)
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        let heartImage = restaurant.isFavorite ? "heart.fill" : "heart"
        headerView.heartButton.tintColor = restaurant.isFavorite ? .systemYellow : .white
        headerView.heartButton.setImage(UIImage(systemName: heartImage), for: .normal)
        
        if let rating = restaurant.rating {
        headerView.ratingImageView.image = UIImage(named: rating)
        }
        
        // Disable the navigation title text
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - Proceed Segues for Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = restaurant
        }
        else if segue.identifier == "showReview" {
            let destinationController = segue.destination as! ReviewViewController
            destinationController.restaurant = restaurant
        }
    }
    
    //unwind from the review view controller (tap the cross button)
    @IBAction func close(segue: UIStoryboardSegue) {
    dismiss(animated: true, completion: nil)
    }
    
    //unwind from the review view controller (tap any rating button)
    @IBAction func rateRestaurant(segue: UIStoryboardSegue) {
        if let rating = segue.identifier {
            // store the rating result (local but not global copy)
            self.restaurant.rating = rating
            //save the change to the data store
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            appDelegate.saveContext()
            // show the rating on the image view
            self.headerView.ratingImageView.image = UIImage(named: rating)
        }
        
        dismiss(animated: true, completion: nil)
    }

    
}


// Method implementations for the tableview data source
extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:  //for prototype cell 1
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailTextCell.self), for: indexPath) as! DetailTextCell
            
            cell.descriptionLabel.text = restaurant.summary
            cell.selectionStyle = .none
            
            return cell
            
        case 1:  //for prototype cell 2
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailTwoColumnCell.self), for: indexPath) as! DetailTwoColumnCell
            
            cell.column1TitleLabel.text = "Address"
            cell.column1TextLabel.text = restaurant.location
            cell.column2TitleLabel.text = "Phone"
            cell.column2TextLabel.text = restaurant.phone
            cell.selectionStyle = .none
            
            return cell
            
        case 2: // for prototype cell 3
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailMapCell.self), for: indexPath) as! DetailMapCell
            cell.selectionStyle = .none
            cell.configure(location: restaurant.location)
            
            return cell
            
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
            
        }
    }
}

