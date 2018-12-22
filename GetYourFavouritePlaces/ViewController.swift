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

class ViewController: UIViewController, ReceiveDeletedPlace, CLLocationManagerDelegate,ReceiveNewFavouritePlace {
    
    @IBOutlet weak var whereAmILabel: UILabel!
    @IBOutlet weak var whereAmILabeltwo: UILabel!
    
    var tabFav: [FavouritePlace]?
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("FavouritePlaces.plist")
    private let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
//
//        for region in locationManager.monitoredRegions {
//            locationManager.stopMonitoring(for: region)
//        }
        locationManager.startUpdatingLocation()
        print(locationManager.monitoredRegions)
        loadData() // * wczytuje dane i zaczynam dla nich obserwowac na początku działania aplikacji
    }
    override func viewDidAppear(_ animated: Bool) {
        print("Dla nich monitorujemy: \(locationManager.monitoredRegions)")
        var regionyMonitorowane: String = "Regiony monitorowane: "
        for region in locationManager.monitoredRegions
        {
            regionyMonitorowane += " " + region.identifier
        }
        whereAmILabeltwo.text = regionyMonitorowane
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //loadData()
        if segue.identifier == "addPlace"
        {
            let secondVC = segue.destination as! AddViewController
            secondVC.delegate = self
            secondVC.array = tabFav
        }
        if segue.identifier == "goToFavourites"
        {
            let favouritesVC = segue.destination as! FavouritesViewController
//            if tabFav != nil
//            {
//            print("We send this:\(tabFav!)")
//            }
            favouritesVC.array = tabFav
            favouritesVC.delegate = self

        }
    }
    func placeReceived(place: FavouritePlace){
        if (self.tabFav?.append(place)) == nil {
            self.tabFav = [place]
        }
        startMonitoring(places: [place])
        print("Tab Fav \(self.tabFav!)")
        self.saveToPlist()
    }
    func deletedPlaceReceived(deletedPlace: FavouritePlace) {
        self.tabFav?.removeAll(where: { (place) in
            if(place.name == deletedPlace.name)
            {
            stopMonitoring(place:place)
            }
            return place.name == deletedPlace.name
        })
        self.saveToPlist()
        print("Dla nich monitorujemy po usunieciu: \(locationManager.monitoredRegions)")
        
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
    func stopMonitoring(place: FavouritePlace)
    {
        for region in self.locationManager.monitoredRegions {
            if region.identifier == place.name {
            self.locationManager.stopMonitoring(for: region)
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        whereAmILabel.text = "You entered \(region.identifier)"
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        whereAmILabel.text = "You left \(region.identifier)"
    }
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        whereAmILabel.text = "Error: \(error) Error for region: \(region!.identifier))"
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        whereAmILabel.text = "I cannot use your location!"
    }
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        // whereAmILabeltwo.text = "Did start monitoring for \(region)"
    }
    func saveToPlist()
    {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.tabFav)
            try data.write(to:self.dataFilePath!)
        }
        catch {
            print("Error encoding item array \(error)")
        }
    }
}

