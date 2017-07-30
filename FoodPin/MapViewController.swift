//
//  MapViewController.swift
//  FoodPin
//
//  Created by Gabriel Rodrigues on 29/07/17.
//  Copyright © 2017 Gabriel Rodrigues. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    var restaurant: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
        
        // Converta um endereco para um coordinate e crie uma anotacao no map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location) { (placemarks, error) in
            if error != nil {
                print(error)
                
                return
            }
            
            if let placemarks = placemarks {
                
                // Obter o primeiro marcador
                let placemark = placemarks[0]
                
                // adiciona uma anotacao (pino)
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    // exibir a anotacao (pino)
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // Reusa a anotacao se possivel
        var annotationVeiw = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationVeiw == nil {
            annotationVeiw = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationVeiw?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
        leftIconView.image = UIImage(named: restaurant.image)
        annotationVeiw?.leftCalloutAccessoryView = leftIconView
        annotationVeiw?.pinTintColor = UIColor.orange
        
        
        
        return annotationVeiw
    }
}
