//
//  AlbumsView.swift
//  HW9
//
//  Created by Chengyu_Ovaltine on 4/13/17.
//  Copyright © 2017 Chengyu_Ovaltine. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import CoreData

class AlbumsView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var selectedIndex: IndexPath?
    
    @IBOutlet weak var noData: UILabel!
    
    @IBAction func back(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
            SwiftSpinner.show(duration:1.5, title:"Loading data...")
        }
        
    }
    @IBAction func alertMore(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Menu", preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share", style:.default){action in
            
            //configurate fb SHARE request
            let content = FBSDKShareLinkContent()
            content.contentDescription="FB Share for CSCI 571"
            content.contentTitle = MyGlobal.passedName
            content.imageURL = NSURL(string: MyGlobal.profileUrl) as URL!
            let shareDialog: FBSDKShareDialog = FBSDKShareDialog()
            
            shareDialog.shareContent = content
            
            shareDialog.delegate = nil
            shareDialog.fromViewController = self
            shareDialog.show()
            
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        let global = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        request.returnsObjectsAsFaults = false;
        var exist:Bool = false
        var betoRemoved:NSManagedObject?
        
        do{
            let results = try global.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let tempId = result.value(forKey: "id") as? String{
                        if tempId == MyGlobal.id{
                            betoRemoved=result
                            exist = true;
                            break;
                        }
                    }
                }
            }
        }
        catch{
            print("loops favorites fails")
        }
        
        let favoriteAction = UIAlertAction(title: "Add to favorites", style:.default){action in
            let newFavorite = NSEntityDescription.insertNewObject(forEntityName: "Favorite", into: global)
            newFavorite.setValue(MyGlobal.id, forKey: "id")
            newFavorite.setValue(MyGlobal.profileUrl, forKey: "url")
            newFavorite.setValue(MyGlobal.passedName, forKey: "name")
            newFavorite.setValue(MyGlobal.type, forKey: "type")
            do{
                try global.save();
                print("one favorite saved")
            } catch{
                print("fails to save favorite")
            }
        }
        let removeFavoriteAction = UIAlertAction(title: "Remove from favorites", style: .default){ action in
            global.delete(betoRemoved!)
            print("remove a favorite successfully" )
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive){ action in
            print("Cancel")
        }
        
        
        if exist{
            alertController.addAction(removeFavoriteAction)
            alertController.addAction(shareAction)
            alertController.addAction(cancelAction)
        }
        else{
            alertController.addAction(favoriteAction)
            alertController.addAction(shareAction)
            alertController.addAction(cancelAction)
        }
        
        
        self.present(alertController, animated: true) {
            // ...
        }
    }
    
    @IBOutlet weak var albumTable: UITableView!
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if json["albums"]["data"].count == 0{
            self.albumTable.alpha = 0;
            self.noData.alpha = 1;
        }
        else{
            self.albumTable.alpha = 1;
            self.noData.alpha = 0;
        }
        return json["albums"]["data"].count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Albums") as! ExpendingTableView
        cell.albumName.text = json["albums"]["data"][indexPath.row]["name"].rawString();
        cell.firstPic.image=nil
        cell.secondPic.image=nil
        //find the hi-rel picture
        if let picId = json["albums"]["data"][indexPath.row]["photos"]["data"][0]["id"].rawString() {
            Alamofire.request("https://graph.facebook.com/v2.8/" + picId + "/picture?redirect=false&access_token=EAAJvrTUjG3oBAPunL5N6OI0irmVe5ek5SeRyXVFdrA9l5wBIOpnxgEnrA2IprU6YshZC4d4EQ9XnpfLCXcHdPC3rk3kZC5qT0p0caZC0FdXsviOPRS0JzYDagSIkP7EOwCCGuZCrs6SHJNYOR1eYHNQkUze1iagZD").responseJSON { response in
                
                if let resultValue = response.result.value {
                    let tempJson = JSON(resultValue)
                    if let url = NSURL(string: tempJson["data"]["url"].rawString()!){
                        if let data = NSData(contentsOf: url as URL){
                            cell.firstPic.image=UIImage(data: data as Data)
                        }
                    }
                }
                
            }
        }
        
        if let picId = json["albums"]["data"][indexPath.row]["photos"]["data"][1]["id"].rawString() {
            Alamofire.request("https://graph.facebook.com/v2.8/" + picId + "/picture?redirect=false&access_token=EAAJvrTUjG3oBAPunL5N6OI0irmVe5ek5SeRyXVFdrA9l5wBIOpnxgEnrA2IprU6YshZC4d4EQ9XnpfLCXcHdPC3rk3kZC5qT0p0caZC0FdXsviOPRS0JzYDagSIkP7EOwCCGuZCrs6SHJNYOR1eYHNQkUze1iagZD").responseJSON { response in
                
                if let resultValue = response.result.value {
                    let tempJson = JSON(resultValue)
                    if let url = NSURL(string: tempJson["data"]["url"].rawString()!){
                        if let data = NSData(contentsOf: url as URL){
                            cell.secondPic.image=UIImage(data: data as Data)
                        }
                    }
                }
                
            }
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndex;
        if indexPath == selectedIndex{
            selectedIndex = nil
        }
        else{
            selectedIndex = indexPath
        }
        
        var indexPaths : Array<IndexPath> = []
        if let previous = previousIndexPath{
            indexPaths += [previous]
        }
        if let current = selectedIndex{
            indexPaths += [current]
        }
        if indexPaths.count>0{
            albumTable.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! ExpendingTableView).watchFrameChanges()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath != selectedIndex{
            return ExpendingTableView.defaultHeight
        }
        else{
            return ExpendingTableView.expendedHeight
        }
    }
    
    var passedId = ""
    var json : JSON = []
    override func viewDidLoad() {
        SwiftSpinner.show(duration: 1.5, title: "Loading data...")
        super.viewDidLoad()
//        print("id is " + MyGlobal.id)
        self.navigationController?.isNavigationBarHidden = true;
        //since the detail graph call contains some special character, we need to encode it before parse.
        let original = "http://sample-env-1.wtfjrqnkdf.us-west-2.elasticbeanstalk.com/php_script.php?url=https://graph.facebook.com/v2.8/"+MyGlobal.id+"?fields=albums.limit(5){name,photos.limit(2){name,picture}},posts.limit(5){message,created_time}!access_token=EAAJvrTUjG3oBAPunL5N6OI0irmVe5ek5SeRyXVFdrA9l5wBIOpnxgEnrA2IprU6YshZC4d4EQ9XnpfLCXcHdPC3rk3kZC5qT0p0caZC0FdXsviOPRS0JzYDagSIkP7EOwCCGuZCrs6SHJNYOR1eYHNQkUze1iagZD"
        if let encodedString = original.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        {
            Alamofire.request(encodedString).responseJSON { response in
                
                if let resultValue = response.result.value {
                    self.json = JSON(resultValue)
                    self.albumTable.reloadData()
                    self.albumTable.tableFooterView = UIView();
                }
                
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
