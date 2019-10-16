//
//  CheckLoginController.swift
//  NekoBundle-ios
//
//  Created by Ryandi Widjaja on 25/11/18.
//  Copyright © 2018 Ryandi Widjaja. All rights reserved.
//

import UIKit

class CheckLoginController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let key:String = UserDefaults.standard.string(forKey: "login_key")!
        print(key)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if key == "nil" {
                self.performSegue(withIdentifier: "checkLogin_segue", sender: nil)
            }
            else {
                self.performSegue(withIdentifier: "loginSuccess_segue", sender: nil)
            }
        }
        
    }

}
