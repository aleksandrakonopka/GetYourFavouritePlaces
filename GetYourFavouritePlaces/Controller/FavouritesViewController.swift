//
//  FavouritesViewController.swift
//  GetYourFavouritePlaces
//
//  Created by Aleksandra Konopka on 02/12/2018.
//  Copyright © 2018 Aleksandra Konopka. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


protocol ReceiveDeletedPlace{
    func deletedPlaceReceived(deletedPlace:FavouritePlace)
}
protocol SendBackToDoListArrayFromFavVCToVC
{
    func toDoListArrayReceivedFromFavVC(data:[ToDoItem])
}
class FavouritesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, SendBackToDoListArray{
    var placeId = "noId"
    let dataFilePathToDoItems = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ToDoItems.plist")
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("FavouritePlaces.plist")
    var array: [FavouritePlace]?
    var deletedPlaces: [FavouritePlace]?
    //To Do Item
    var arrayToDoItem: [ToDoItem]?
    //var arrayToDoItems = [ToDoItem(placeName:"warszawa", item: "umyc kwiatki")]
    //var delegate : ReceiveModifiedArray?
    var delegate : ReceiveDeletedPlace?
    var delegateSendBack : SendBackToDoListArrayFromFavVCToVC?
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
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = array![indexPath.row].name
        return cell
    }
    
    @IBOutlet weak var myTable: UITableView!
    override func viewDidLoad() {
       // loadDataToDoItem()
       print("ARRAY TO DO ITEMS IN FAVOURITES \(arrayToDoItem!)")
        print(dataFilePathToDoItems!)
        super.viewDidLoad()
        
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
//        if array != nil {
//        delegate?.arrayReceived(array: array!)
//        }
//        else
//        {
//          delegate?.arrayReceived(array: [])
//        }
        delegateSendBack?.toDoListArrayReceivedFromFavVC(data: arrayToDoItem!)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let alert = UIAlertController(title: "Are you sure?", message: "Would you like to delete this favourite place - '\(array![indexPath.row].name)' with all related ToDoItems?", preferredStyle: .alert )
            let yesButton = UIAlertAction(title: "Yes", style: .default){ action in
                print("Yes")
               // NIE USUWAC
                self.myTable.beginUpdates()
                self.myTable.deleteRows(at: [indexPath], with: .left)
                var number = 0
                for element in self.arrayToDoItem!
                {
                    if(element.placeName == self.array![indexPath.row].name)
                    {
                        self.arrayToDoItem?.remove(at: number)
                    }
                    else
                    {
                        number = number + 1
                    }
                }
                self.delegate?.deletedPlaceReceived(deletedPlace:self.array![indexPath.row])
                self.array?.remove(at: indexPath.row)
                self.myTable.endUpdates()
                self.saveToPlistToDoItem()
            }
            
            let noButton = UIAlertAction(title: "No", style: .cancel){
                action in
                print("No")
            }
            alert.addAction(yesButton)
            alert.addAction(noButton)
            self.present(alert,animated: true, completion: nil)
            
            //NIE USUWAC
//            myTable.beginUpdates()
//            myTable.deleteRows(at: [indexPath], with: .left)
//            self.delegate?.deletedPlaceReceived(deletedPlace:array![indexPath.row])
//            array?.remove(at: indexPath.row)
//            myTable.endUpdates()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("INDEX PATH: \(indexPath.row), ELEMENT ID: \(array![indexPath.row].name)")
        placeId = array![indexPath.row].name
        performSegue(withIdentifier: "goToToDoList", sender: self)
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToToDoList"
        {
            let toDoVC = segue.destination as! ToDoTableViewController
            toDoVC.placeId = placeId
            toDoVC.array = arrayToDoItem
            print("ARRAYTODOITEMS FAV \(arrayToDoItem!)")
            toDoVC.delegate = self
        }
    }
   func toDoListArrayReceived(data: [ToDoItem]){
        arrayToDoItem = data
        print("Zadziałało!")
    }
    func saveToPlistToDoItem()
    {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.arrayToDoItem)
            try data.write(to:self.dataFilePathToDoItems!)
        }
        catch {
            print("Error encoding item array \(error)")
        }
    }
//    func loadDataToDoItem()
//    {
//        if let data = try? Data(contentsOf: dataFilePathToDoItems!) {
//            let decoder = PropertyListDecoder()
//            do{
//                arrayToDoItem = try decoder.decode([ToDoItem].self, from: data)
//            } catch{
//                print("Error decoding item array: \(error)")
//            }
//        }
//    }


}
