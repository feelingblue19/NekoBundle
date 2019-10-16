//
//  RegisController.swift
//  inet-reminder-ios
//
//  Created by Ryandi Widjaja on 07/11/18.
//  Copyright © 2018 Ryandi Widjaja. All rights reserved.
//

import UIKit
import Alamofire

class RegisController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtVerifPassword: UITextField!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    let URL_JSON_CREATE = "https://ios.project-tf.xyz/api/users/create"
    let URL_JSON_GET = "https://ios.project-tf.xyz/api/users/show/"
    
    var user: User? = nil
    var email_found: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUsername.delegate = self
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtVerifPassword.delegate = self
        // Do any additional setup after loading the view.
        
        txtEmail.keyboardType = UIKeyboardType.emailAddress
        txtPassword.isSecureTextEntry = true
        txtVerifPassword.isSecureTextEntry = true
        
        loadIndicator.hidesWhenStopped = true
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnRegis(_ sender: Any) {
        //if there is an duplicate email then cannot enter the email (alert)
        //checkEmail(email: txtEmail.text!)
        loadIndicator.startAnimating()
        self.view.endEditing(true)
        
        if txtPassword.text! != txtVerifPassword.text! {
            self.loadIndicator.stopAnimating()
            alertBox(text: "Password didn't match \nTry Again")
        }
        else if !isValidEmail(testStr: txtEmail.text!) {
            self.loadIndicator.stopAnimating()
            alertBox(text: "Email is not valid")
            self.txtEmail.becomeFirstResponder()
        }
        else {
            Alamofire.request(URL_JSON_GET + txtEmail.text!, method:.get).validate().responseString { response in
                switch response.result {
                case .success:
                    print(response)
                    self.loadIndicator.stopAnimating()
                    self.alertBox(text: "Email is already used")
                    break
                case .failure: //if the email is not used before, then will post the data
//                    postUser(name:txtName.text!, email:txtEmail.text!, password:txtPassword.text!)
                    
                    let parameters: Parameters = [
                        "username": self.txtUsername.text!,
                        "email": self.txtEmail.text!,
                        "password": self.txtPassword.text!
                    ]
                    
                    Alamofire.request(self.URL_JSON_CREATE, method:.post, parameters: parameters).validate()
                        .responseJSON { response in
                            switch response.result {
                            case .success:
                                print(response)
                                self.loadIndicator.stopAnimating()
                                self.dismissAlertBox(text: "Check your email to verify")
                                break
                            case .failure(let error):
                                self.loadIndicator.stopAnimating()
                                print(error)
                                break
                            }
                    }
                    break
                }
            }
        }
        
    }
    
    //dua dua nya buat yang nurunin keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
}
