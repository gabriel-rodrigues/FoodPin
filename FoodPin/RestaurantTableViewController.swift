//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Gabriel Rodrigues on 09/07/17.
//  Copyright © 2017 Gabriel Rodrigues. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController {

    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    var restaurants: [RestaurantMO] = []
    var searchResults: [RestaurantMO] = []
    var searchController: UISearchController!
    
    var restaurantIsVisited = Array(repeating: false, count: 21)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController                                  = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView                         = searchController.searchBar
        searchController.searchResultsUpdater             = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder            = "Search restaurants..."
        searchController.searchBar.tintColor              = UIColor.white
        searchController.searchBar.barTintColor           = UIColor(red: 218/255, green: 100/255, blue: 70/255, alpha: 1.0)
        
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.estimatedRowHeight     = 80
        tableView.rowHeight              = UITableViewAutomaticDimension
        
        
        // fetch data from data store
        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context    = appDelegate.persistentContainer.viewContext
            
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                               managedObjectContext: context,
                                                               sectionNameKeyPath: nil,
                                                               cacheName: nil)
            
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    restaurants = fetchedObjects
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return searchResults.count
        }
        
        return restaurants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestauranteTableViewCell

        // Configure the cell...
        let restaurant = (searchController.isActive) ? searchResults[indexPath.row] :  restaurants[indexPath.row]
        
        cell.nameLabel.text           = restaurant.name
        cell.locationLabel.text       = restaurant.location
        cell.typeLabel.text           = restaurant.type
        cell.thumbnailImageView.image = UIImage(data: restaurant.image! as Data)
        cell.accessoryType            = restaurant.isVisited ? .checkmark : .none
        
        return cell
    }
    
    func filterContent(for searchText: String) {
        
        searchResults = restaurants.filter({ (restaurant) -> Bool in
            
            if let name = restaurant.name, let location = restaurant.location {
                let isMatchName     = name.localizedCaseInsensitiveContains(searchText)
                let isMatchLocation = location.localizedCaseInsensitiveContains(searchText)
                
                return isMatchName || isMatchLocation
            }
            
            return false
        })
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return !searchController.isActive
    }
    
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Social Sharing button
        let shareAction = UITableViewRowAction(style: .default,
                                               title: "Share") { (action, indexPath) in
                                                
                                                let defaultText = "Just checking in at " + self.restaurants[indexPath.row].name!
                                                if let imageToShare = UIImage(data: self.restaurants[indexPath.row].image! as Data) {
                                                    let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare],
                                                                                                      applicationActivities: nil)
                                                    
                                                    self.present(activityController, animated: true, completion: nil)
                                                }
        }
        
        // delete button
        let deleteAction = UITableViewRowAction(style: .default,
                                                title: "Delete") { (action, indexPath) in
                                                    
                                                    if let appDelete = UIApplication.shared.delegate as? AppDelegate {
                                                        let context = appDelete.persistentContainer.viewContext
                                                        let restaurantToDelete = self.fetchResultController.object(at: indexPath)
                                                        
                                                        context.delete(restaurantToDelete)
                                                        
                                                        appDelete.saveContext()
                                                    }
        }
        
        shareAction.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction, shareAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = (searchController.isActive) ? searchResults[indexPath.row] : self.restaurants[indexPath.row]
            }
        }
    }
    
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RestaurantTableViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
}

extension RestaurantTableViewController : NSFetchedResultsControllerDelegate {
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        
        if let fetchedObjects = controller.fetchedObjects {
            restaurants = fetchedObjects as! [RestaurantMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

