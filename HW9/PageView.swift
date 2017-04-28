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

class PageView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var pageTable: UITableView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var open: UIBarButtonItem!
    
    @IBAction func previous(_ sender: Any) {
        Alamofire.request(self.previousPage).responseJSON { response in
            if let resultValue = response.result.value {
                self.json = JSON(resultValue)
                self.pageTable.reloadData()
                self.jsonReload()
            }
        }

    }
    @IBAction func next(_ sender: Any) {
        Alamofire.request(self.nextPage).responseJSON { response in
            if let resultValue = response.result.value {
                self.json = JSON(resultValue)
                self.pageTable.reloadData()
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
            Alamofire.request(nexPage).responseJSON { response in
                if let resultValue = response.result.value {
                    let tempJson = JSON(resultValue)
                    if tempJson["data"].count > 0{
                        self.nextButton.isEnabled = true
                        self.nextPage = nexPage;
                    }else{
                        self.nextButton.isEnabled = false
                    }
                }
                else{
                    self.nextButton.isEnabled = false;
                }
            }
        }
        else{
            self.nextButton.isEnabled = false;
        }
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return json["data"].count;
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:FbItems = tableView.dequeueReusableCell(withIdentifier: "pageResult", for: indexPath)as! FbItems;
        if let url = NSURL(string: json["data"][indexPath.row]["picture"]["data"]["url"].rawString()!){
            if let data = NSData(contentsOf: url as URL){
                cell.pageProfile.image=UIImage(data: data as Data)
            }
        }
        cell.pageName.text = json["data"][indexPath.row]["name"].rawString();
        cell.pageFavoriteButton.id = json["data"][indexPath.row]["id"].rawString()!
        cell.pageFavoriteButton.url = json["data"][indexPath.row]["picture"]["data"]["url"].rawString()!
        cell.pageFavoriteButton.name = json["data"][indexPath.row]["name"].rawString()!
        cell.pageFavoriteButton.type = "page"
        
        cell.pageFavoriteButton.addTarget(self, action: #selector(SearchView.like(sender:)), for: .touchUpInside)
        
        //check whether the item is favorited or not
        let idListObj = UserDefaults.standard.object(forKey: "favoriteId")
        if let idList = idListObj as? Array<String>{
            for id in idList {
                if id == cell.pageFavoriteButton.id{
                    cell.pageFavoriteButton.setImage(UIImage(named:"filled.png"), for: .normal)
                    return cell
                }
            }
        }
        
        cell.pageFavoriteButton.setImage(UIImage(named:"empty.png"), for: .normal)
        
        return cell;
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
                    if let image = UIImage(named: "empty.png"){
                        sender.setImage(image, for: .normal)
                    }
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
                    self.view.showToast("Removed from favorites!", position: .bottom, popTime: 1, dismissOnTap: false);
                    return
                }
                i+=1
            }
        }
        
        if var idList = idListObj as? Array<String>{
            idList.append(sender.id!)
            UserDefaults.standard.set(idList, forKey: "favoriteId")
        }
        else{
            let idList = [sender.id!]
            UserDefaults.standard.set(idList, forKey: "favoriteId")
        }
        
        if var nameList = nameListObj as? Array<String>{
            nameList.append(sender.name!)
            UserDefaults.standard.set(nameList, forKey: "favoriteName")
        }
        else{
            let nameList = [sender.name!]
            UserDefaults.standard.set(nameList, forKey: "favoriteName")
        }
        
        if var urlList = urlListObj as? Array<String>{
            urlList.append(sender.url!)
            UserDefaults.standard.set(urlList, forKey: "favoriteUrl")
        }
        else{
            let urlList = [sender.url!]
            UserDefaults.standard.set(urlList, forKey: "favoriteUrl")
        }
        
        if var typeList = typeListObj as? Array<String>{
            typeList.append(sender.type)
            UserDefaults.standard.set(typeList, forKey: "favoriteType")
        }
        else{
            let typeList = [sender.type]
            UserDefaults.standard.set(typeList, forKey: "favoriteType")
        }
        
        if let image = UIImage(named: "filled.png"){
            sender.setImage(image, for: .normal)
        }
        self.view.showToast("Add to favorites!", position: .bottom, popTime: 1, dismissOnTap: false);
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MyGlobal.id = json["data"][indexPath.row]["id"].rawString()!
        MyGlobal.profileUrl = json["data"][indexPath.row]["picture"]["data"]["url"].rawString()!
        MyGlobal.passedName = json["data"][indexPath.row]["name"].rawString()!
        MyGlobal.type = "page"
    }
    
    
    
    var stringPassed = "usc"
    var json = JSON("abc")
    var previousPage = "null"
    var nextPage = "null"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show(duration:1.5, title:"Loading data...")
        if self.revealViewController() != nil {
            open.target = self.revealViewController()
            open.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
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
        
        Alamofire.request("http://sample-env-1.wtfjrqnkdf.us-west-2.elasticbeanstalk.com/php_script.php?url=https://graph.facebook.com/v2.8/search?q="+self.stringPassed+"!type=page!fields=id,name,picture.width(700).height(700)!limit=10!access_token=EAAJvrTUjG3oBAE7Jd9lGZCon7UuHjY96nICOamYwgVVzkKYQrsqLSffzfzSZCCmfWyrO1oHdz4SAL08s66EvZCZCqTIwYn5suMEQh9MatXewbkxb9p7tlnEurcA8snpHtNW1MbA9Kn1jd26elTQEK7f6sdS1RuwZD&isDetail=0").responseJSON { response in
            
            if let resultValue = response.result.value {
                self.json = JSON(resultValue)
                self.pageTable.reloadData()
            }
            
            self.jsonReload();
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.pageTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromRight
//        
//        self.view.window!.layer.add(transition, forKey: kCATransition)
//        self.present(segue.destination, animated: false, completion: nil)
//    }
}
