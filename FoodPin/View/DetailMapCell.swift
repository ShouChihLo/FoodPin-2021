//
//  DetailMapCell.swift
//  FoodPin
//
//  Created by NDHU_CSIE on 2021/11/29.
//

import UIKit
import MapKit

class DetailMapCell: UITableViewCell {
    
    var targetPlacemark: CLPlacemark!

    
    @IBOutlet var mapView: MKMapView! {
        didSet {
//            let gesture = UITapGestureRecognizer(target: self, action: #selector(openMap))
//            mapView.addGestureRecognizer(gesture)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(location: String) {
        // Get location
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(location, completionHandler: { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                self.targetPlacemark = placemark
                
                // Add annotation
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location {
                    // Display the annotation
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    // Set the zoom level
                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                    self.mapView.setRegion(region, animated: false)
                }
            }
            
        })
    }
    
// Proceed the route to the destination using the Apple Maps
    
//    @objc func openMap(sender: UITapGestureRecognizer) {

//    let voiceText = AVSpeechUtterance(string: "Start navigation")
//    voiceText.voice = AVSpeechSynthesisVoice(language: "en-US")
//    let syn = AVSpeechSynthesizer()
//    syn.speak(sound)
    
//        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: targetPlacemark.location!.coordinate, addressDictionary: nil))
//
//        //mapItem.name = "Destination“
//        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
//    }

}
