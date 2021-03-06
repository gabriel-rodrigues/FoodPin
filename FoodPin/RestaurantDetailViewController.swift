//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Gabriel Rodrigues on 10/07/17.
//  Copyright © 2017 Gabriel Rodrigues. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController {

    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var nomeLabel: UILabel!
    @IBOutlet var tipoLabel: UILabel!
    @IBOutlet var localLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    
    var restaurant: RestaurantMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        title = restaurant.name
        
        restaurantImageView.image = UIImage(data: restaurant.image! as Data)

        tableView.backgroundColor = UIColor(red: 240.0/255, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        tableView.separatorColor  = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.8)
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(tapGestureReconizer)
        
        let geoCorder = CLGeocoder()
        geoCorder.geocodeAddressString(restaurant.location!) { (placemarks, error) in
            if error != nil {
                print(error!)
                return
            }
            
            if let placemarks = placemarks {
                
                let placemark = placemarks[0]
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    // set the zoom level
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                    self.mapView.setRegion(region, animated: false)
                }
                
            }
        }
        
    }
    
    func showMap() {
        
        self.performSegue(withIdentifier: "showMap", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func close(segue: UIStoryboardSegue) {
        
    }

    @IBAction func ratingButtonTapped(segue: UIStoryboardSegue) {
        
        
        if let rating = segue.identifier {
            
            restaurant.isVisited = true
            
            switch rating {
                case "great": restaurant.rating = "Absolutely love it! Must try."
                case "good": restaurant.rating  = "Pretty good."
                case "dislike": restaurant.rating  = "I don't like it."
                default: break
            }
            
            tableView.reloadData()
        }
    
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.saveContext()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showReview" {
         let controller = segue.destination as! ReviewViewController
            controller.restaurant = restaurant
        }
        else if segue.identifier == "showMap" {
            let controller = segue.destination as! MapViewController
            controller.restaurant = restaurant
        }
    }

    
}


extension RestaurantDetailViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantDetailTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurant.type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = restaurant.phone
        case 4:
            cell.fieldLabel.text = "Been here"
            
            if restaurant.isVisited {
                if let rating = restaurant.rating {
                    cell.valueLabel.text = "Yes, I've been here before. \(rating)"
                }
                else {
                    cell.valueLabel.text = "Yes, I've been here before."
                }
            }
            else {
                cell.valueLabel.text  = "No"
            }
            
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = .clear
        
        return cell
    }
}
