//
//  HomeController.swift
//  NekoBundle-ios
//
//  Created by lab_pk_29 on 24/11/18.
//  Copyright © 2018 Ryandi Widjaja. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    @IBOutlet weak var roundedCornerButtonLogout: UIButton! //aku lepas dulu soalnya kalo disambung ke storyboardnya dia error dan aku blm tau errornya di mana
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundedCornerButtonLogout.layer.cornerRadius = 12
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnLogout(_ sender: Any) {
        
        let alertVC : UIAlertController = UIAlertController(title: "Alert", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        let agreeAction = UIAlertAction.init(title: "Yes", style: .destructive) { (UIAlertAction) -> Void in
            UserDefaults.standard.set("nil", forKey: "login_key")
            print("logout button pressed")
            self.dismiss(animated: false, completion: nil)
        }
        let cancelAction = UIAlertAction.init(title: "No", style: .default, handler: nil)
        
        alertVC.addAction(agreeAction)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
    }
}
