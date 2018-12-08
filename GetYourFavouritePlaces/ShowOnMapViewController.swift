//
//  ShowOnMapViewController.swift
//  GetYourFavouritePlaces
//
//  Created by Aleksandra Konopka on 08/12/2018.
//  Copyright © 2018 Aleksandra Konopka. All rights reserved.
//

import UIKit

class ShowOnMapViewController: UIViewController {
    var array: [FavouritePlace]?

    override func viewDidLoad() {
        super.viewDidLoad()
        if array != nil {
            for element in array!{
                print(element.name)
            }
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion:nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
