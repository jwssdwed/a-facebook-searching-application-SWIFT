//
//  PostsView.swift
//  HW9
//
//  Created by Chengyu_Ovaltine on 4/13/17.
//  Copyright © 2017 Chengyu_Ovaltine. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import EasyToast
import FBSDKShareKit

class PostsView: UIViewController,UITableViewDataSource, UITableViewDelegate, FBSDKSharingDelegate {
    @IBOutlet weak var noData: UILabel!
    
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
    
    @IBOutlet weak var postTable: UITableView!
    
    @IBAction func back(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
            SwiftSpinner.show(duration:1.5, title:"Loading data...")
        } else {
            self.dismiss(animated: true, completion: nil)
            SwiftSpinner.show(duration:1.5, title:"Loading data...")
        }
        
    }
    
    @IBAction func moreFunc(_ sender: Any) {
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

    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if json["posts"]["data"].count == 0 {
            self.postTable.alpha = 0;
            self.noData.alpha = 1;
        }
        else{
            self.postTable.alpha = 1;
            self.noData.alpha = 0;
        }
        return json["posts"]["data"].count;
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Posts", for: indexPath) as! PostTableCell
        cell.postProfile.image = profile
        cell.postMes.text = json["posts"]["data"][indexPath.row]["message"].rawString()
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = RFC3339DateFormatter.date(from: json["posts"]["data"][indexPath.row]["created_time"].rawString()!)
        RFC3339DateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
        let dateString = RFC3339DateFormatter.string(from: date!)
        cell.postDate.text = dateString;
        cell.postMes.numberOfLines = 0;
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    var json:JSON = []
    var profile:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show(duration: 1.5, title: "Loading data...")
        
        postTable.estimatedRowHeight = 100;
        postTable.rowHeight = UITableViewAutomaticDimension
        
        //get the profile of posts
        if let url = NSURL(string: MyGlobal.profileUrl){
            if let data = NSData(contentsOf: url as URL){
                self.profile=UIImage(data: data as Data)
            }
        }
        
        let original = "http://sample-env-1.wtfjrqnkdf.us-west-2.elasticbeanstalk.com/php_script.php?url=https://graph.facebook.com/v2.8/"+MyGlobal.id+"?fields=albums.limit(5){name,photos.limit(2){name,picture}},posts.limit(5){message,created_time}!access_token=EAAJvrTUjG3oBAE7Jd9lGZCon7UuHjY96nICOamYwgVVzkKYQrsqLSffzfzSZCCmfWyrO1oHdz4SAL08s66EvZCZCqTIwYn5suMEQh9MatXewbkxb9p7tlnEurcA8snpHtNW1MbA9Kn1jd26elTQEK7f6sdS1RuwZD"
        if let encodedString = original.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        {
            Alamofire.request(encodedString).responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                case .failure(let error):
                    print(error)
                }
                
                if let resultValue = response.result.value {
                    self.json = JSON(resultValue)
                    
                    self.postTable.reloadData()
                    self.postTable.tableFooterView = UIView();
                }
                
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
