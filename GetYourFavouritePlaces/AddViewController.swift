//
//  AddViewController.swift
//  GetYourFavouritePlaces
//
//  Created by Aleksandra Konopka on 02/12/2018.
//  Copyright © 2018 Aleksandra Konopka. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var zoom = true
    var favLongitude:Double?
    var favLatitude:Double?
    @IBOutlet weak var myMap: MKMapView!
    private let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myMap.delegate = self
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        self.myMap.showsUserLocation = true
    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if zoom == true {
        zoomOnMe()
        }
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func zoomButtonClicked(_ sender: Any) {
        if zoom == true
        {
            zoom = false
        }
        else
        {
            zoom = true
            zoomOnMe()
        }
        
    }
    
    func zoomOnMe()
    {
        let region = MKCoordinateRegion(center: myMap.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008))
        myMap.setRegion(region,animated:true)
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        zoom = false
        let alert = UIAlertController(title: "Find the place", message: "Enter the address of the location", preferredStyle: .alert )
        alert.addTextField{textfield in}
        
        let ok = UIAlertAction(title: "OK", style: .default){ action in
            if let textfield = alert.textFields?.first{
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(textfield.text!){ (placemarks,error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    guard let placemarks = placemarks,
                        let placemark = placemarks.first else {
                            return
                    }
                    let coordinate = placemark.location?.coordinate
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate!
                    self.myMap.addAnnotation(annotation)
                    
                    self.favLatitude = coordinate!.latitude
                    self.favLongitude = coordinate!.longitude
                    
                    let regionFav = MKCoordinateRegion(center: coordinate!, span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008))
                    self.myMap.setRegion(regionFav,animated:true)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel){
            action in
            }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert,animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let favLat = favLatitude{
            let favLong = favLongitude!
            let alert = UIAlertController(title: "Name your favourite Location", message: nil, preferredStyle: .alert )
            alert.addTextField{textfield in}
            
            let save = UIAlertAction(title: "Save", style: .default){ action in
                if let textfield = alert.textFields?.first{
                    let favName = textfield.text!
                    print(favName)
                    print(favLat)
                    print(favLong)
                }
                
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel){
                action in
            }
            alert.addAction(save)
            alert.addAction(cancel)
            self.present(alert,animated: true, completion: nil)
            
        }
        else {
            let alert = UIAlertController(title: "Oh no!", message: "You need to add a place first.", preferredStyle: .alert )
            let ok = UIAlertAction(title: "OK", style: .cancel){
                        action in
                    }
            alert.addAction(ok)
            self.present(alert,animated: true, completion: nil)
        }
    }
}
