//
//  ToDoTableViewController.swift
//  GetYourFavouritePlaces
//
//  Created by Aleksandra Konopka on 28/12/2018.
//  Copyright © 2018 Aleksandra Konopka. All rights reserved.
//

import UIKit

protocol SendBackToDoListArray
{
    func toDoListArrayReceived(data:[ToDoItem])
}

class ToDoTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var myTable: UITableView!
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ToDoItems.plist")
    var array: [ToDoItem]?
    var arrayInPlace: [ToDoItem]?
    var placeId = "noPlaceId"
    var delegate : SendBackToDoListArray?
    //var array = [ToDoItem(placeName: "Place01", item: "Umyć Zęby"),ToDoItem(placeName: "Place02", item: "Podlać kwiatki"), ToDoItem(placeName: "Place03", item: "Zjeść Ser")]
    override func viewDidLoad() {
        //array = []
        super.viewDidLoad()
        //loadData()
        fillArrayInPlace()
        print("PLACEID: \(placeId)")
        //print(dataFilePath)
        print("Array to do items in ToDo: \(array!)")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  arrayInPlace == nil {
            return 0
        }
        else
        {
            return arrayInPlace!.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "toDoCell")
        if arrayInPlace != nil
        {
        cell.textLabel?.text = arrayInPlace![indexPath.row].item
        }
        return cell
    }

    @IBAction func backButtonClicked(_ sender: UIButton) {
        if array != nil
        {
        delegate?.toDoListArrayReceived(data: self.array!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addButtonClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "New ToDoItem", message: "Enter new toDoItem", preferredStyle: .alert )
        alert.addTextField{textfield in}
        
        let ok = UIAlertAction(title: "OK", style: .default){ action in
            if let textfield = alert.textFields?.first{
                print(textfield.text!)
                let newItem = ToDoItem(placeName: self.placeId, item: textfield.text!)
                print(newItem)
                if (self.array?.append(newItem)) == nil {
                    self.array = [newItem]
                }
                if (self.arrayInPlace?.append(newItem)) == nil {
                    self.arrayInPlace = [newItem]
                }
                print("NOWY ITEM:\(newItem)")
                print(self.array!)
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
            var number = 0
            for element in array!
            {
                if arrayInPlace![indexPath.row].item == element.item
                {
                    print("ELEMENT DO USUNIECIA: \(element)")
                    print("CZY TO TEN SAM?: \(array![number])")
                    array!.remove(at: number)
                }
                number = number+1
            }
            arrayInPlace?.remove(at: indexPath.row)
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
//    func loadData()
//    {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do{
//                array = try decoder.decode([ToDoItem].self, from: data)
//            } catch{
//                print("Error decoding item array: \(error)")
//            }
//        }
//    }
    func fillArrayInPlace()
    {
        if array != nil{
            for element in array!
            {
                if(element.placeName == placeId){
                    if (self.arrayInPlace?.append(element)) == nil {
                        self.arrayInPlace = [element]
                    }
                }
            }
        }
       // print("ARRAYINPLACE:\(arrayInPlace!)")
    }
}
