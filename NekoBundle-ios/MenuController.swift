//
//  MenuController.swift
//  NekoBundle-ios
//
//  Created by Ryandi Widjaja on 23/11/18.
//  Copyright © 2018 Ryandi Widjaja. All rights reserved.
//

import UIKit
import Alamofire

class MenuController: UIViewController {
    @IBOutlet weak var lblUsernameHome: UILabel!
    var key:String = ""
    
    
    let URL_JSON_GET_USERNAME = "https://ios.project-tf.xyz/api/users/show/"
    
    override func viewWillAppear(_ animated: Bool) { //buat nampilin yang updated
        key = UserDefaults.standard.string(forKey: "login_key")!
        
        if key == "nil" {
            dismiss(animated: false, completion: nil)
        }
        else {
            Alamofire.request(URL_JSON_GET_USERNAME + key).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                //print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization 
                if let data = response.result.value {
                    print("JSON: \(data)") // serialized json response
                    let user = User.init(json: data as! [String : Any])
                    self.lblUsernameHome.text = user.username
                    
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         //ini login key buat ngambil data email, ini fungsi buat ngambil data yang ada di aplikasi nya dengan nama "login_key", si "login_key" aku set nilainya di viewcontroller
        
        print(key) // ini buat ngecek aja nilai key itu isinya apaan (yang pasti tipe datanya string)
        
        
        //pending (buat nampilin username di homepage)
//        Alamofire.request(URL_JSON_GET_USERNAME + key).responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            //print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
//            let status = response.response?.statusCode
//            print(status as! Int)
//
//            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
//                self.lblUsernameHome.text = json as! String
//            }
//        }
    }
    
    @IBAction func btnHome(_ sender: Any) {
        performSegue(withIdentifier: "home_segue", sender: nil)
    }
    @IBAction func btnEditProfile(_ sender: Any) {
        performSegue(withIdentifier: "editprofile_segue", sender: nil)
    }
    @IBAction func btnBundle(_ sender: Any) {
        performSegue(withIdentifier: "bundle_segue", sender: nil)
    }
    @IBAction func btnStore(_ sender: Any) {
        performSegue(withIdentifier: "store_segue", sender: nil)
    }
    @IBAction func btnAbout(_ sender: Any) {
        performSegue(withIdentifier: "about_segue", sender: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
