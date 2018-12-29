//
//  ToDoTableViewController.swift
//  GetYourFavouritePlaces
//
//  Created by Aleksandra Konopka on 28/12/2018.
//  Copyright © 2018 Aleksandra Konopka. All rights reserved.
//

import UIKit

class ToDoTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let array = ["Hello","Darknes","My","Old","Friend"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "toDoCell")
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }

    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addButtonClicked(_ sender: UIButton) {
        
    }
    
}
