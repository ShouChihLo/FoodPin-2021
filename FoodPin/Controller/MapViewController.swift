//
//  MapViewController.swift
//  FoodPin
//
//  Created by NDHU_CSIE on 2021/11/29.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!

    var restaurant = Restaurant()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure map view
        //mapView.delegate = self
        //mapView.showsCompass = true
        //mapView.showsScale = true
        //mapView.showsTraffic = true
        
        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location, completionHandler: { placemarks, error in
            if let error = error {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                
                // Create annotation object
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    // Display the annotation view
                    self.mapView.showAnnotations([annotation], animated: true)
                    //select the annotation marker to turn it into the selected state
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
            
        })
        
        
    }
    

    
}
