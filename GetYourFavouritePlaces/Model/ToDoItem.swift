//
//  ToDoItem.swift
//  GetYourFavouritePlaces
//
//  Created by Aleksandra Konopka on 29/12/2018.
//  Copyright © 2018 Aleksandra Konopka. All rights reserved.
//
import Foundation
import UIKit

struct ToDoItem:Codable {
    var placeName: String
    var item: String
    init(placeName: String, item: String) {
        self.placeName = placeName
        self.item = item
    }
}
