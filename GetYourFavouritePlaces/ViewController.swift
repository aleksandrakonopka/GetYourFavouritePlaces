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

class ViewController: UIViewController,ReceiveArrayElement, ReceiveModifiedArray {
    var tabFav: [FavouritePlace]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
}

