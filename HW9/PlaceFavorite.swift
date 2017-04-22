//
//  PlaceFavorite.swift
//  HW9
//
//  Created by Chengyu_Ovaltine on 4/17/17.
//  Copyright © 2017 Chengyu_Ovaltine. All rights reserved.
//

import UIKit
import CoreData

class PlaceFavorite: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var placeFavTable: UITableView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var open: UIBarButtonItem!

    var ids:[String] = []
    var names:[String] = []
    var profiles:[String] = []
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ids.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:FbItems = tableView.dequeueReusableCell(withIdentifier: "placeFavorite", for: indexPath)as! FbItems;
        cell.placeFavName.text=names[indexPath.row]
        
        let url = NSURL(string: profiles[indexPath.row])
        if let data = NSData(contentsOf: url! as URL){
            cell.placeFavProfile.image=UIImage(data: data as Data)
        }
        cell.placeFavFavoriteButton.id = ids[indexPath.row]
        cell.placeFavFavoriteButton.addTarget(self, action: #selector(SearchView.like(sender:)), for: .touchUpInside)
        return cell
    }
    
    func like(sender: FavoriteButton){
        //get global object
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        let global = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        request.returnsObjectsAsFaults = false;
        do{
            let results = try global.fetch(request)
            if results.count>0{
                for result in results as! [NSManagedObject]{
                    if let tempId = result.value(forKey: "id") as? String{
                        if tempId == sender.id{
                            global.delete(result)
                            print("favorite removed")
                            updateTable()
                            return;
                        }
                    }
                }
            }
        }catch{
            print("fetch favorite result failing")
        }
        
    }
    
    //update global variables
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MyGlobal.id = ids[indexPath.row]
        MyGlobal.profileUrl = profiles[indexPath.row]
        MyGlobal.passedName = names[indexPath.row]
        MyGlobal.type = "place"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        open.target = self.revealViewController()
        open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //initialize
        previousButton.isEnabled = false
        nextButton.isEnabled = false
        
        // Do any additional setup after loading the view.
        updateTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTable(){
        ids.removeAll()
        names.removeAll()
        profiles.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        let global = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        request.returnsObjectsAsFaults = false;
        do{
            let results = try global.fetch(request)
            if results.count>0{
                for result in results as! [NSManagedObject]{
                    if let tempType = result.value(forKey: "type") as? String{
                        if tempType == "place"{
                            if let tempId = result.value(forKey: "id") as? String{
                                ids.append(tempId)
                            }
                            if let tempName = result.value(forKey: "name") as? String{
                                names.append(tempName)
                            }
                            if let tempUrl = result.value(forKey: "url") as? String{
                                profiles.append(tempUrl)
                            }
                        }
                    }
                }
            }
        }
        catch{
            print("fails to fetch favorite data")
        }
        self.placeFavTable.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        updateTable()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
