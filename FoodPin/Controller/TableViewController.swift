//
//  TableViewController.swift
//  FoodPin
//
//  Created by NDHU_CSIE on 2021/11/1.
//

import UIKit


class TableViewController: UITableViewController {
    
    var restaurants:[Restaurant] = []
        
    lazy var dataSource = configureDataSource()

    // MARK: - UITableView Life's Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialized the data source
        Restaurant.generateData(sourceArray: &restaurants)

        tableView.dataSource = dataSource
                
        //Create the snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)

        dataSource.apply(snapshot, animatingDifferences: false)
        
        //configure the navigation title
        navigationController?.navigationBar.prefersLargeTitles = true
    }

  
    // MARK: - UITableView Diffable Data Source

    func configureDataSource() -> DiffableDataSource {
        let cellIdentifier = "datacell"
        
        let dataSource = DiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, restaurant in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
                
                //configure the cell's data
                cell.nameLabel.text = restaurant.name
                cell.thumbnailImageView.image = UIImage(named: restaurant.image)
                cell.locationLabel.text = restaurant.location
                cell.typeLabel.text = restaurant.type
                cell.accessoryType = restaurant.isFavorite ? .checkmark : .none
                
                return cell
            }
        )
        
        return dataSource
    }
    
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) //return the currently slected cell
//        cell?.accessoryType = .checkmark
//        restaurants[indexPath.row].isFavorite = true
//        
//        tableView.deselectRow(at: indexPath, animated: false)  //de-selection
//    }
    
    
    // MARK: - UITableView Swipe Actions
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

    // Mark as favorite action
    let actionTitle = restaurants[indexPath.row].isFavorite ? "uncheck" : "check"
    let favoriteAction = UIContextualAction(style: .destructive, title: actionTitle) { (action, sourceView, completionHandler) in

    let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
    //update source array
    self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false : true

    //update data source of the tableview
    var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
    snapshot.appendSections([.all])
    snapshot.appendItems(self.restaurants, toSection: .all)
    self.dataSource.apply(snapshot, animatingDifferences: false)

    //update cell
    cell.accessoryType = self.restaurants[indexPath.row].isFavorite ? .checkmark : .none

    // Call completion handler to dismiss the action button
    completionHandler(true)
    }

    let swipeConfiguration = UISwipeActionsConfiguration(actions: [favoriteAction])

    return swipeConfiguration
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Get the selected restaurant
        guard let restaurant = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        //Delete Action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            //delete from the table view (datasource and source array are separated: structure type)
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([restaurant])
            self.dataSource.apply(snapshot, animatingDifferences: true)
            //delete from the source array
            self.restaurants.remove(at: indexPath.row)
            
            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        // Configure both actions as swipe action
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration

    }
    
    // MARK: - For Segue's function
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! DetailViewController
                destinationController.restaurantImageName = restaurants[indexPath.row].image
            }
        }
    }
    
}
