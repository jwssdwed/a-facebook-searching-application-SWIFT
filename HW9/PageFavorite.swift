//
//  pageFavorite.swift
//  HW9
//
//  Created by Chengyu_Ovaltine on 4/17/17.
//  Copyright © 2017 Chengyu_Ovaltine. All rights reserved.
//

import UIKit
import CoreData

class PageFavorite: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageFavTable: UITableView!

    var ids:[String] = []
    var names:[String] = []
    var profiles:[String] = []
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ids.count
    }
    @IBOutlet weak var open: UIBarButtonItem!
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:FbItems = tableView.dequeueReusableCell(withIdentifier: "pageFavorite", for: indexPath)as! FbItems;
        cell.pageFavName.text=names[indexPath.row]
        
        let url = NSURL(string: profiles[indexPath.row])
        if let data = NSData(contentsOf: url! as URL){
            cell.pageFavProfile.image=UIImage(data: data as Data)
        }
        cell.pageFavFavoriteButton.id = ids[indexPath.row]
        cell.pageFavFavoriteButton.addTarget(self, action: #selector(SearchView.like(sender:)), for: .touchUpInside)
        return cell
    }
    
    func like(sender: FavoriteButton){
        //get global object
        let idListObj = UserDefaults.standard.object(forKey: "favoriteId")
        let nameListObj = UserDefaults.standard.object(forKey: "favoriteName")
        let urlListObj = UserDefaults.standard.object(forKey: "favoriteUrl")
        let typeListObj = UserDefaults.standard.object(forKey: "favoriteType")
        if var idList = idListObj as? Array<String>{
            var i = 0
            while i<idList.count{
                if idList[i] == sender.id{
                    idList.remove(at: i)
                    if var nameList = nameListObj as? Array<String>{
                        nameList.remove(at: i)
                        UserDefaults.standard.set(nameList, forKey: "favoriteName")
                    }
                    if var urlList = urlListObj as? Array<String>{
                        urlList.remove(at: i)
                        UserDefaults.standard.set(urlList, forKey: "favoriteUrl")
                    }
                    if var typeList = typeListObj as? Array<String>{
                        typeList.remove(at: i)
                        UserDefaults.standard.set(typeList, forKey: "favoriteType")
                    }
                    UserDefaults.standard.set(idList, forKey: "favoriteId")
                    updateTable()
                    return
                }
                i+=1
            }
        }
        
    }
    
    //update global variables
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MyGlobal.id = ids[indexPath.row]
        MyGlobal.profileUrl = profiles[indexPath.row]
        MyGlobal.passedName = names[indexPath.row]
        MyGlobal.type = "page"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            open.target = self.revealViewController()
            open.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        //initialize
        previousButton.isEnabled = false
        nextButton.isEnabled = false
        
        // Do any additional setup after loading the view.
        updateTable()
    }
    
    func updateTable(){
        ids.removeAll()
        names.removeAll()
        profiles.removeAll()
        
        let idListObj = UserDefaults.standard.object(forKey: "favoriteId")
        let nameListObj = UserDefaults.standard.object(forKey: "favoriteName")
        let urlListObj = UserDefaults.standard.object(forKey: "favoriteUrl")
        let typeListObj = UserDefaults.standard.object(forKey: "favoriteType")
        if var typeList = typeListObj as? Array<String>{
            var i = 0
            while i<typeList.count{
                if typeList[i] == "page"{
                    if var idList = idListObj as? Array<String>{
                        ids.append(idList[i])
                    }
                    if var urlList = urlListObj as? Array<String>{
                        profiles.append(urlList[i])
                    }
                    if var nameList = nameListObj as? Array<String>{
                        names.append(nameList[i])
                    }
                }
                i+=1
            }
        }
        self.pageFavTable.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateTable()
    }
}
