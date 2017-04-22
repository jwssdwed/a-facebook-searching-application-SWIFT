//
//  ViewController.swift
//  HW9
//
//  Created by Chengyu_Ovaltine on 4/11/17.
//  Copyright © 2017 Chengyu_Ovaltine. All rights reserved.
//

import UIKit
import CoreData
import EasyToast

struct MyGlobal {
    static var id = "123";
    static var profileUrl = "";
    static var passedName = ""
    static var type="user"
}

class ViewController: UIViewController {
    
    @IBOutlet weak var keyword: UITextField!
    @IBOutlet weak var open: UIBarButtonItem!
    
    @IBAction func clear(_ sender: Any) {
        keyword.text = ""
    }
    
    @IBAction func search(_ sender: Any) {
        if keyword.text == "" {
            self.view.showToast("Enter a valid Query", position: .bottom, popTime: kToastNoPopTime, dismissOnTap: true)
        }
        else{
            //replace space with "%20"
            let regext = try! NSRegularExpression(pattern: "\\s+", options: .caseInsensitive)
            let range = NSMakeRange(0, (keyword.text?.characters.count)!)
            let processedKeyword = regext.stringByReplacingMatches(in: keyword.text!, options: [], range: range, withTemplate: "%20")
            let global = appDelegate.persistentContainer.viewContext
            let newKeyword = NSEntityDescription.insertNewObject(forEntityName: "Query", into: global)
            newKeyword.setValue(processedKeyword, forKey: "keyword")
            do{
                try global.save();
                print("saved")
            } catch{
                print("save the keyword failing")
            }
            print(self.revealViewController())
            self.performSegue(withIdentifier: "searchNow", sender: self)
        }
    }
    
    func showToast(message : String) {
        toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2-100, y: self.view.frame.size.height, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .showHideTransitionViews, animations: {
            self.toastLabel.center.y -= 100
        },
            completion: nil
        )
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    var toastLabel:UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true;
        open.target = self.revealViewController()
        open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        let global = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Query")
        request.returnsObjectsAsFaults = false;
        do{
            let results = try global.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    
                    global.delete(result)
                }
            }
        }catch{
            print("delete global variable failing")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

