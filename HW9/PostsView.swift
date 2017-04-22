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

class PostsView: UIViewController,UITableViewDataSource, UITableViewDelegate {
//    @IBOutlet weak var noData: UITableView!
    @IBOutlet weak var noData: UILabel!
    
    @IBOutlet weak var postTable: UITableView!
    
    @IBAction func back(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
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
        RFC3339DateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
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
        postTable.estimatedRowHeight = 100;
        postTable.rowHeight = UITableViewAutomaticDimension
        
        //get the profile of posts
        if let url = NSURL(string: MyGlobal.profileUrl){
            if let data = NSData(contentsOf: url as URL){
                self.profile=UIImage(data: data as Data)
            }
        }
        
        let original = "http://sample-env-1.wtfjrqnkdf.us-west-2.elasticbeanstalk.com/php_script.php?url=https://graph.facebook.com/v2.8/"+MyGlobal.id+"?fields=albums.limit(5){name,photos.limit(2){name,picture}},posts.limit(5){message,created_time}!access_token=EAAJvrTUjG3oBAPunL5N6OI0irmVe5ek5SeRyXVFdrA9l5wBIOpnxgEnrA2IprU6YshZC4d4EQ9XnpfLCXcHdPC3rk3kZC5qT0p0caZC0FdXsviOPRS0JzYDagSIkP7EOwCCGuZCrs6SHJNYOR1eYHNQkUze1iagZD"
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
