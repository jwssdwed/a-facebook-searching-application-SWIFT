//
//  AboutMe.swift
//  HW9
//
//  Created by Chengyu_Ovaltine on 4/17/17.
//  Copyright © 2017 Chengyu_Ovaltine. All rights reserved.
//

import UIKit

class AboutMe: UIViewController {
    @IBOutlet weak var open: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            open.target = self.revealViewController()
            open.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
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
