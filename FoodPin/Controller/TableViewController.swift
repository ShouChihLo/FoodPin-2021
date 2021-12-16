//
//  TableViewController.swift
//  FoodPin
//
//  Created by NDHU_CSIE on 2021/11/1.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var fetchResultController: NSFetchedResultsController<Restaurant>!
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!

    var restaurants:[Restaurant] = []
        
    lazy var dataSource = configureDataSource()

    // MARK: - UITableView Life's Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // write initial data entries into the database if empty
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let count = try? managedContext.count(for: fetchRequest)
        if count == 0 { Restaurant.generateData() }

        // set the data source to the tableview
        tableView.dataSource = dataSource
                
        //Create the snapshot for the table view
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
//        snapshot.appendSections([.all])
//        snapshot.appendItems(restaurants, toSection: .all)
//        dataSource.apply(snapshot, animatingDifferences: false)
        
        //configure the navigation title
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // fetch data from the data store
        fetchRestaurantData()   //will refresh the table view
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
                cell.thumbnailImageView.image = UIImage(data: restaurant.image)
                cell.locationLabel.text = restaurant.location
                cell.typeLabel.text = restaurant.type
                cell.accessoryType = restaurant.isFavorite ? .checkmark : .none
                
                return cell
            }
        )
        
        return dataSource
    }
    
// handle the table cell selection
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) //return the currently slected cell
//        cell?.accessoryType = .checkmark
//        restaurants[indexPath.row].isFavorite = true
//        
//        tableView.deselectRow(at: indexPath, animated: false)  //de-selection
//    }
    
    
    // MARK: - UITableView Swipe Actions
    
    //swipe-to-right
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

    // Mark as favorite action
    let actionTitle = restaurants[indexPath.row].isFavorite ? "uncheck" : "check"
    let favoriteAction = UIContextualAction(style: .destructive, title: actionTitle) { (action, sourceView, completionHandler) in

    let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
    //update source array
    self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false : true

    //re-generate snapshot and apply again
    var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
    snapshot.appendSections([.all])
    snapshot.appendItems(self.restaurants, toSection: .all)
    self.dataSource.apply(snapshot, animatingDifferences: false)

    //update the cell's accessoryType
    cell.accessoryType = self.restaurants[indexPath.row].isFavorite ? .checkmark : .none

    // Call completion handler to dismiss the action button
    completionHandler(true)
    }

    // change the background color of the action button
    favoriteAction.backgroundColor = UIColor.systemYellow
//    favoriteAction.image = UIImage(systemName: self.restaurants[indexPath.row].isFavorite ? "heart.slash.fill" : "heart.fill")
        
    let swipeConfiguration = UISwipeActionsConfiguration(actions: [favoriteAction])

    return swipeConfiguration
    }
    
    //swipe-to-left
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
        
        // Change the button's color
//        deleteAction.backgroundColor = UIColor.systemRed
//        deleteAction.image = UIImage(systemName: "trash")

        
        // Configure the action as swipe action
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration

    }
    
    // MARK: - For Segue's function
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                //get the destination's view controller
                let destinationController = segue.destination as! DetailViewController
                //pass the data from the source side to the destination side
                destinationController.restaurant = restaurants[indexPath.row]
            }
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Core Data
    
    func fetchRestaurantData() {
        
        // Get the NSFetchRequest object and set the sorting criteria (at least once)
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //Use the NSFetchedResultController to fetch and monitor the managed objects
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        //Start fetching data (run once and be monitored during the lifetime of the app)
        do {
            try fetchResultController.performFetch()
            updateSnapshot()  //create the snapshot for the table view
        } catch {
            print(error)
        }
    }
    
    func updateSnapshot() {
        // redirect the newly fetched objects to the restaurants array
        if let fetchedObjects = fetchResultController.fetchedObjects {
            restaurants = fetchedObjects
        }
        
        // Create a snapshot and refresh the tableview
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}


extension TableViewController: NSFetchedResultsControllerDelegate {
    
    // this method will be called when the FetchedResultsController detects any data changes on fetched objects
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot()
    }
    
}

