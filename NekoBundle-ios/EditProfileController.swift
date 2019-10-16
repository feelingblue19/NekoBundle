//
//  EditProfileController.swift
//  inet-reminder-ios
//
//  Created by Ryandi Widjaja on 07/11/18.
//  Copyright © 2018 Ryandi Widjaja. All rights reserved.
//

import UIKit
import Alamofire

class EditProfile: UIViewController {
    @IBOutlet weak var roundedCornerButtonSave: UIButton!
    @IBOutlet weak var roundedCornerButtonDelete: UIButton!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var swEdit: UISwitch!
    
    let URL_JSON_UPDATE = "https://ios.project-tf.xyz/api/users/update/"
    let URL_JSON_GET = "https://ios.project-tf.xyz/api/users/show/"
    let URL_JSON_DELETE = "https://ios.project-tf.xyz/api/users/delete/"
    
    let genderString = ["Male", "Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundedCornerButtonSave.layer.cornerRadius = 12
        roundedCornerButtonDelete.layer.cornerRadius = 12
        
        let key:String = UserDefaults.standard.string(forKey: "login_key")!
        txtEmail.text = key
        
        txtIsOn(boolean: false) //ini prosedur buatan sendiri ada di bawah buat nonaktifin txt field, masih mau direvisi karena menurutku, email sama password gantinya bukan di sini.
        
        txtEmail.isUserInteractionEnabled = false
        txtEmail.backgroundColor = UIColor.lightGray
        
        swEdit.isOn = false //ini buat set switch yang ada di main storyboard supaya diset nilai awalnya itu false yang berarti posisinya dia di off
        
        Alamofire.request(URL_JSON_GET + key, method:.get).responseJSON { response in
            switch response.result {
            case .success:
                print("Request: \(String(describing: response.request))")
                if let data = response.result.value {
                    //print(data)
                    //                    let user = User.init(json: json as! [String : Any])
                    print("JSON: \(data)") // serialized json response
                    let user = User.init(json: data as! [String : Any])
                    self.txtUsername.text = user.username
                    self.txtName.text = user.nama
                    self.txtGender.text = user.gender
                    
                }
                
                break
                
            case .failure:
                break
            }
        }
    }
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnSave(_ sender: Any) {
        
        let parameters: Parameters = [
            "nama": self.txtName.text!,
            "username": self.txtUsername.text!,
            "email": self.txtEmail.text!,
            "gender": self.txtGender.text!
        ]
        
        Alamofire.request(URL_JSON_GET + self.txtEmail.text!, method:.get).validate().responseString { response in
            switch response.result {
            case .success: //success found the email
                print("Success found the email")
                
                Alamofire.request(self.URL_JSON_UPDATE + self.txtEmail.text!, method:.put, parameters: parameters).validate()
                    .responseJSON { response in
                        print("Request: \(String(describing: response.request))")
                        switch response.result {
                        case .success:
                            print(response)
                            self.dismissAlertBox(text: "User updated!")
                            break
                        case .failure(let error):
                            print(error)
                            break
                        }
                }
                
                break
                
            case .failure:
                self.alertBox(text: "Email is not found!")
                break
            }
        }
    }
    @IBAction func btnDelete(_ sender: Any) {
        let alertVC : UIAlertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        
        let agreeAction = UIAlertAction.init(title: "Yes", style: .destructive) { (UIAlertAction) -> Void in
            
            Alamofire.request(self.URL_JSON_DELETE + self.txtEmail.text!, method:.delete).responseString { response in
                switch response.result {
                case .success:
                    //self.alertBox(text: "Your Account has been deleted!")
                    UserDefaults.standard.set("nil", forKey: "login_key")
                    print("delete button pressed")
                    self.dismiss(animated: false, completion: nil)
                    
                    break
                case .failure:
                    break
                }
            }
            
        }
        let cancelAction = UIAlertAction.init(title: "No", style: .default, handler: nil)
        
        alertVC.addAction(agreeAction)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func swEdit(_ sender: UISwitch) {
        if sender.isOn == true {
            txtIsOn(boolean: true)
        }
        else {
            txtIsOn(boolean: false)
        }
    }
    
    func createGenderPicker() {
        let genderPicker = UIPickerView()
        genderPicker.delegate = self as! UIPickerViewDelegate
        
        txtGender.inputView = genderPicker
    }
    
    func txtIsOn(boolean: Bool) {
        txtUsername.isUserInteractionEnabled = boolean
        txtName.isUserInteractionEnabled = boolean
        txtGender.isUserInteractionEnabled = boolean
        roundedCornerButtonSave.isUserInteractionEnabled = boolean
        
        if boolean == false {
            txtUsername.backgroundColor = UIColor.lightGray
            txtName.backgroundColor = UIColor.lightGray
            txtGender.backgroundColor = UIColor.lightGray
        }
        else {
            txtUsername.backgroundColor = UIColor.white
            txtName.backgroundColor = UIColor.white
            txtGender.backgroundColor = UIColor.white
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
