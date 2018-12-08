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

class ViewController: UIViewController,ReceiveArrayElement {
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
        }
    }
    func dataReceived(element: FavouritePlace) {
        //print("Element : \(element)")
        if (tabFav?.append(element)) == nil {
            tabFav = [element]
        }
        print("Tablica: \(tabFav!)")
    }

}

