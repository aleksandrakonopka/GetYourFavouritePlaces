//
//  ViewController.swift
//  GetYourFavouritePlaces
//
//  Created by Aleksandra Konopka on 02/12/2018.
//  Copyright © 2018 Aleksandra Konopka. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController,ReceiveArrayElement, ReceiveModifiedArray, CLLocationManagerDelegate {
    
    @IBOutlet weak var whereAmILabel: UILabel!
    var tabFav: [FavouritePlace]?
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("FavouritePlaces.plist")
    private let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view, typically from a nib.
       //print(dataFilePath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        loadData()
        if segue.identifier == "addPlace"
        {
            let secondVC = segue.destination as! AddViewController
            secondVC.delegate=self
            secondVC.array = tabFav
        }
        if segue.identifier == "goToFavourites"
        {
            let favouritesVC = segue.destination as! FavouritesViewController
            favouritesVC.array = tabFav
            favouritesVC.delegate = self
            
        }
    }
    func dataReceived(array:[FavouritePlace]) {
        tabFav = array
        print("Tablica: \(tabFav!)")
    }
    func arrayReceived(array: [FavouritePlace]) {
        tabFav = array
        print("Array received \(array) ")
    }
    func loadData()
    {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                tabFav = try decoder.decode([FavouritePlace].self, from: data)
                if tabFav != nil && tabFav!.count > 0
                {
                startMonitoring(places:tabFav!)
                }
            } catch{
                print("Error decoding item array: \(error)")
            }
        }
    }
    func startMonitoring(places: [FavouritePlace])
   {
        for place in places
        {
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude:place.lat,longitude:place.long), radius: 1000, identifier: place.name)
            region.notifyOnEntry = true
            region.notifyOnExit = true
            locationManager.startMonitoring(for: region)

        }
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        whereAmILabel.text = "You entered \(region.identifier)"
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        whereAmILabel.text = "You left \(region.identifier)"
    }
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        whereAmILabel.text = "Error: \(error) Error for region: \(region?.identifier)"
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        whereAmILabel.text = "Second Error: \(error)"
    }
}

