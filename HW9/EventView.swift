//
//  SearchView.swift
//  HW9
//
//  Created by Chengyu_Ovaltine on 4/12/17.
//  Copyright © 2017 Chengyu_Ovaltine. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import CoreData

class EventView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var eventTable: UITableView!
    @IBOutlet weak var open: UIBarButtonItem!
    
    @IBAction func previous(_ sender: Any) {
        Alamofire.request(self.previousPage).responseJSON { response in
            if let resultValue = response.result.value {
                self.json = JSON(resultValue)
                self.eventTable.reloadData()
                self.jsonReload()
            }
        }
        
    }
    
    @IBAction func next(_ sender: Any) {
        Alamofire.request(self.nextPage).responseJSON { response in
            if let resultValue = response.result.value {
                self.json = JSON(resultValue)
                self.eventTable.reloadData()
                self.jsonReload()
            }
        }
    }
    
    
    
    
    
    func jsonReload() {
        //judge whether we are supposed to enable previous button
        if let prePage = self.json["paging"]["previous"].rawString() {
            if (prePage != "null") {
                //                print(prePage)
                self.previousPage = prePage;
                self.previousButton.isEnabled = true;
            }
            else{
                self.previousButton.isEnabled = false;
            }
        }
        else{
            self.previousButton.isEnabled = false;
        }
        //judge whether we are supposed to enable next button
        if let nexPage = self.json["paging"]["next"].rawString() {
            if (nexPage != "null") {
                self.nextPage = nexPage;
                self.nextButton.isEnabled = true
            }
            else{
                self.nextButton.isEnabled = false;
            }
        }
        else{
            self.nextButton.isEnabled = false;
        }
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if json["data"].count == 0{
            SwiftSpinner.hide()
        }
        return json["data"].count;
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:FbItems = tableView.dequeueReusableCell(withIdentifier: "eventResult", for: indexPath)as! FbItems;
        if let url = NSURL(string: json["data"][indexPath.row]["picture"]["data"]["url"].rawString()!){
            if let data = NSData(contentsOf: url as URL){
                cell.eventProfile.image=UIImage(data: data as Data)
            }
        }
        cell.eventName.text = json["data"][indexPath.row]["name"].rawString();
        cell.eventFavoriteButton.id = json["data"][indexPath.row]["id"].rawString()!
        cell.eventFavoriteButton.url = json["data"][indexPath.row]["picture"]["data"]["url"].rawString()!
        cell.eventFavoriteButton.name = json["data"][indexPath.row]["name"].rawString()!
        cell.eventFavoriteButton.type = "event"
        
        cell.eventFavoriteButton.addTarget(self, action: #selector(SearchView.like(sender:)), for: .touchUpInside)
        
        //check whether the item is favorited or not
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        let global = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        request.returnsObjectsAsFaults = false;
        do{
            let results = try global.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let tempId = result.value(forKey: "id") as? String{
                        if tempId == cell.eventFavoriteButton.id{
                            if let image = UIImage(named: "filled.png"){
                                cell.eventFavoriteButton.setImage(image, for: .normal)
                                return cell;
                            }
                        }
                    }
                }
            }
        }
        catch{
            print("fails to fetch all favorited information")
        }
        cell.eventFavoriteButton.setImage(UIImage(named:"empty.png"), for: .normal)
        
        if indexPath.row == json["data"].count-1 {
            print("hide")
            SwiftSpinner.hide()
        }
        
        return cell;
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
                            if let image = UIImage(named: "empty.png"){
                                sender.setImage(image, for: .normal)
                            }
                            global.delete(result)
                            print("favorite removed")
                            return
                        }
                    }
                }
            }
            let newFavorite = NSEntityDescription.insertNewObject(forEntityName: "Favorite", into: global)
            newFavorite.setValue(sender.id, forKey: "id")
            newFavorite.setValue(sender.url, forKey: "url")
            newFavorite.setValue(sender.name, forKey: "name")
            newFavorite.setValue(sender.type, forKey: "type")
            
            do{
                try global.save();
                print("favorite saved")
                if let image = UIImage(named: "filled.png"){
                    sender.setImage(image, for: .normal)
                }
            } catch{
                print("fails to save favorite")
            }
        }catch{
            print("fetch favorite result failing")
        }
        
        do{
            let results = try global.fetch(request)
            if results.count>0{
                for result in results as! [NSManagedObject]{
                    if let temp = result.value(forKey: "name") as? String{
                        print("user name = " + temp)
                    }
                }
            }
        }
        catch{
            print("show all favorite result fails")
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MyGlobal.id = json["data"][indexPath.row]["id"].rawString()!
        MyGlobal.profileUrl = json["data"][indexPath.row]["picture"]["data"]["url"].rawString()!
        MyGlobal.passedName = json["data"][indexPath.row]["name"].rawString()!
        MyGlobal.type = "event"
    }
    
    var stringPassed = "usc"
    var json = JSON("abc")
    var previousPage = "null"
    var nextPage = "null"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        open.target = self.revealViewController()
        open.action = #selector(SWRevealViewController.revealToggle(_:))
        //get global object
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        let global = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Query")
        request.returnsObjectsAsFaults = false;
        do{
            let result = try global.fetch(request)
            if result.count>0{
                if let myStr = (result[result.count-1] as! NSManagedObject).value(forKey: "keyword") as? String{
                    self.stringPassed = myStr;
                }
            }
            
        }catch{
            print("fetch result failing")
        }
        
        Alamofire.request("http://sample-env-1.wtfjrqnkdf.us-west-2.elasticbeanstalk.com/php_script.php?url=https://graph.facebook.com/v2.8/search?q="+self.stringPassed+"!type=event!fields=id,name,picture.width(700).height(700)!limit=10!access_token=EAAJvrTUjG3oBAPunL5N6OI0irmVe5ek5SeRyXVFdrA9l5wBIOpnxgEnrA2IprU6YshZC4d4EQ9XnpfLCXcHdPC3rk3kZC5qT0p0caZC0FdXsviOPRS0JzYDagSIkP7EOwCCGuZCrs6SHJNYOR1eYHNQkUze1iagZD&isDetail=0").responseJSON { response in
            
            if let resultValue = response.result.value {
                self.json = JSON(resultValue)
                self.eventTable.reloadData()
            }
            
            self.jsonReload();
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.eventTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
