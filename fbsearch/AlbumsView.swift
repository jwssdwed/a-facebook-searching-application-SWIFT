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
import FBSDKShareKit

class AlbumsView: UIViewController, UITableViewDataSource, UITableViewDelegate, FBSDKSharingDelegate {
    var selectedIndex: IndexPath?
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        self.view.showToast("Shared!", position: .bottom, popTime: 1, dismissOnTap: false)
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        self.view.showToast("Share failed!", position: .bottom, popTime: 1, dismissOnTap: false)
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("Cancel")
        self.view.showToast("Cancelled!", position: .bottom, popTime: 1, dismissOnTap: false)
    }
    
    @IBOutlet weak var noData: UILabel!
    
    @IBAction func back(_ sender: Any) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
            SwiftSpinner.show(duration:1, title:"Loading data...")
        } else {
            let transition: CATransition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionReveal
            transition.subtype = kCATransitionFromLeft
            self.view.window!.layer.add(transition, forKey: nil)
            self.dismiss(animated: false, completion: nil)
            //            SwiftSpinner.show(duration:1, title:"Loading data...")
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
            
            shareDialog.delegate = self as  FBSDKSharingDelegate
            shareDialog.fromViewController = self
            shareDialog.show()
            
            
        }
        
        let idListObj = UserDefaults.standard.object(forKey: "favoriteId")
        let nameListObj = UserDefaults.standard.object(forKey: "favoriteName")
        let urlListObj = UserDefaults.standard.object(forKey: "favoriteUrl")
        let typeListObj = UserDefaults.standard.object(forKey: "favoriteType")

        var exist:Bool = false
        
        if var idList = idListObj as? Array<String>{
            var i = 0
            while i<idList.count{
                if idList[i] == MyGlobal.id{
                    exist = true
                    break
                }
                i+=1
            }
        }
        
        let favoriteAction = UIAlertAction(title: "Add to favorites", style:.default){action in
            if var idList = idListObj as? Array<String>{
                idList.append(MyGlobal.id)
                UserDefaults.standard.set(idList, forKey: "favoriteId")
            }
            else{
                let idList = [MyGlobal.id]
                UserDefaults.standard.set(idList, forKey: "favoriteId")
            }
            
            if var nameList = nameListObj as? Array<String>{
                nameList.append(MyGlobal.passedName)
                UserDefaults.standard.set(nameList, forKey: "favoriteName")
            }
            else{
                let nameList = [MyGlobal.passedName]
                UserDefaults.standard.set(nameList, forKey: "favoriteName")
            }
            
            if var urlList = urlListObj as? Array<String>{
                urlList.append(MyGlobal.profileUrl)
                UserDefaults.standard.set(urlList, forKey: "favoriteUrl")
            }
            else{
                let urlList = [MyGlobal.profileUrl]
                UserDefaults.standard.set(urlList, forKey: "favoriteUrl")
            }
            
            if var typeList = typeListObj as? Array<String>{
                typeList.append(MyGlobal.type)
                UserDefaults.standard.set(typeList, forKey: "favoriteType")
            }
            else{
                let typeList = [MyGlobal.type]
                UserDefaults.standard.set(typeList, forKey: "favoriteType")
            }
            self.view.showToast("Add to favorites!", position: .bottom, popTime: 1, dismissOnTap: false)
        }
        let removeFavoriteAction = UIAlertAction(title: "Remove from favorites", style: .default){ action in
            if var idList = idListObj as? Array<String>{
                var i = 0
                while i<idList.count{
                    if idList[i] == MyGlobal.id{
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
                        break;
                    }
                    i+=1
                }
            }
            self.view.showToast("Remove from favorites!", position: .bottom, popTime: 1, dismissOnTap: false)
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
            Alamofire.request("https://graph.facebook.com/v2.8/" + picId + "/picture?redirect=false&access_token=EAAJvrTUjG3oBAE7Jd9lGZCon7UuHjY96nICOamYwgVVzkKYQrsqLSffzfzSZCCmfWyrO1oHdz4SAL08s66EvZCZCqTIwYn5suMEQh9MatXewbkxb9p7tlnEurcA8snpHtNW1MbA9Kn1jd26elTQEK7f6sdS1RuwZD").responseJSON { response in
                
                if let resultValue = response.result.value {
                    let tempJson = JSON(resultValue)
                    if let url = NSURL(string: tempJson["data"]["url"].rawString()!){
                        if let data = NSData(contentsOf: url as URL){
                            cell.firstPic.image=UIImage(data: data as Data)
                            cell.firstPic.contentMode = .scaleAspectFit
                        }
                    }
                }
                
            }
        }
        
        if let picId = json["albums"]["data"][indexPath.row]["photos"]["data"][1]["id"].rawString() {
            Alamofire.request("https://graph.facebook.com/v2.8/" + picId + "/picture?redirect=false&access_token=EAAJvrTUjG3oBAE7Jd9lGZCon7UuHjY96nICOamYwgVVzkKYQrsqLSffzfzSZCCmfWyrO1oHdz4SAL08s66EvZCZCqTIwYn5suMEQh9MatXewbkxb9p7tlnEurcA8snpHtNW1MbA9Kn1jd26elTQEK7f6sdS1RuwZD").responseJSON { response in
                
                if let resultValue = response.result.value {
                    let tempJson = JSON(resultValue)
                    if let url = NSURL(string: tempJson["data"]["url"].rawString()!){
                        if let data = NSData(contentsOf: url as URL){
                            cell.secondPic.image=UIImage(data: data as Data)
                            cell.secondPic.contentMode = .scaleAspectFit
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
        self.navigationItem.title = "Detail"
        //since the detail graph call contains some special character, we need to encode it before parse.
        let original = "http://sample-env-1.wtfjrqnkdf.us-west-2.elasticbeanstalk.com/php_script.php?url=https://graph.facebook.com/v2.8/"+MyGlobal.id+"?fields=albums.limit(5){name,photos.limit(2){name,picture}},posts.limit(5){message,created_time}!access_token=EAAJvrTUjG3oBAE7Jd9lGZCon7UuHjY96nICOamYwgVVzkKYQrsqLSffzfzSZCCmfWyrO1oHdz4SAL08s66EvZCZCqTIwYn5suMEQh9MatXewbkxb9p7tlnEurcA8snpHtNW1MbA9Kn1jd26elTQEK7f6sdS1RuwZD"
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
