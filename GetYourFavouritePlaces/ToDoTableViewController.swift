//
//  ToDoTableViewController.swift
//  GetYourFavouritePlaces
//
//  Created by Aleksandra Konopka on 28/12/2018.
//  Copyright © 2018 Aleksandra Konopka. All rights reserved.
//

import UIKit

class ToDoTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var myTable: UITableView!
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ToDoItems.plist")
    var array: [ToDoItem]?
    //var array = [ToDoItem(placeName: "Place01", item: "Umyć Zęby"),ToDoItem(placeName: "Place02", item: "Podlać kwiatki"), ToDoItem(placeName: "Place03", item: "Zjeść Ser")]
    override func viewDidLoad() {
        array = []
        super.viewDidLoad()
        loadData()
        print(dataFilePath)
        print(array)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  array == nil {
            return 0
        }
        else
        {
            return array!.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "toDoCell")
        cell.textLabel?.text = array![indexPath.row].item
        return cell
    }

    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addButtonClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "New ToDoItem", message: "Enter new toDoItem", preferredStyle: .alert )
        alert.addTextField{textfield in}
        
        let ok = UIAlertAction(title: "OK", style: .default){ action in
            if let textfield = alert.textFields?.first{
                print(textfield.text!)
                let newItem = ToDoItem(placeName: "Place00", item: textfield.text!)
                print(newItem)
                if (self.array?.append(newItem)) == nil {
                    self.array = [newItem]
                }
                print(self.array)
                self.myTable.reloadData()
                self.saveToPlist()
                
                }
            }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel){
            action in
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert,animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            myTable.beginUpdates()
            myTable.deleteRows(at: [indexPath], with: .left)
            array?.remove(at: indexPath.row)
            myTable.endUpdates()
            saveToPlist()
        }
}
    func saveToPlist()
    {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.array)
            try data.write(to:self.dataFilePath!)
        }
        catch {
            print("Error encoding item array \(error)")
        }
    }
    func loadData()
    {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                array = try decoder.decode([ToDoItem].self, from: data)
            } catch{
                print("Error decoding item array: \(error)")
            }
        }
    }
}
