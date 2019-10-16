//
//  ViewController.swift
//  inet-reminder-ios
//
//  Created by Ryandi Widjaja on 07/11/18.
//  Copyright © 2018 Ryandi Widjaja. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class ViewController: UIViewController ,UITextFieldDelegate, NVActivityIndicatorViewable{
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var roundedCornerButton: UIButton!
    @IBOutlet weak var roundedCornerButtonRegister: UIButton!
    
    
    @IBOutlet weak var txtPassword: UITextField!
    var activityIndicatorView: NVActivityIndicatorView!
    
    let URL_JSON_LOGIN = "https://ios.project-tf.xyz/api/users/login"
    
    override func viewDidLoad() {
        
        roundedCornerButton.layer.cornerRadius = 12
        roundedCornerButtonRegister.layer.cornerRadius = 12
        super.viewDidLoad()
        txtEmail.delegate = self
        txtPassword.delegate = self
        
        txtEmail.keyboardType = UIKeyboardType.emailAddress
        txtPassword.isSecureTextEntry = true
        

        
        loadIndicator.hidesWhenStopped = true
    }
    
    @IBAction func btnForgot(_ sender: Any) {
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        if txtEmail.text == "" {
            alertBox(text: "Email is empty")
            self.txtEmail.becomeFirstResponder()
        }
        else if txtPassword.text == "" {
            alertBox(text: "Password is empty")
            self.txtEmail.becomeFirstResponder()
        }
        else if !isValidEmail(testStr: txtEmail.text!) {
            alertBox(text: "Email is not valid")
            self.txtEmail.becomeFirstResponder()
        }
        else { //perform login
            let parameters : Parameters = [
            "email": self.txtEmail.text!,
            "password": self.txtPassword.text!
            ]
            loadIndicator.startAnimating()
            
            Alamofire.request(URL_JSON_LOGIN, method:.post, parameters:parameters).validate().responseJSON { response in
                switch response.result {
                case .success:
                    let string_response = "\(response)"
                    print(string_response)
                    
                    if string_response == "SUCCESS: Akun belum diverifikasi" {
                        self.loadIndicator.stopAnimating()
                        self.alertBox(text: "Your Account has not been verified")
                    }
             
                    
                    else if string_response == "SUCCESS: salah" {
                        self.loadIndicator.stopAnimating()
                        self.alertBox(text: "Wrong email or password")
                    }
                    else if string_response == "SUCCESS: benar" {
                        //masuk login
                        self.loadIndicator.stopAnimating()
                        let email: String = self.txtEmail.text!
                        self.performSegue(withIdentifier: "login_segue", sender: nil)
                        
                        //save email
                        UserDefaults.standard.set(email, forKey: "login_key")
                        print(email)
                        //ini buat masukkin data si email ke variabel "login_key", ini datanya disimpen di hp, jadi kalo misalnya nanti aplikasinya dibuka lagi, selama nilai dari "login_key" ngak diapus, isinya masih ada
                    }
                    
                    break
                case .failure(let error):
                    print(error)
                    self.loadIndicator.stopAnimating()
                    self.alertBox(text: error.localizedDescription)
                    break
                }
            }
        }
    }
    
    @IBAction func btnRegis(_ sender: Any) {
        performSegue(withIdentifier: "regisVC", sender: (Any).self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

extension UIViewController {
    func alertBox(text: String) {
        let alertVC : UIAlertController = UIAlertController(title: "Alert", message: text, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction.init(title: "Okay", style: .default, handler: nil)
        
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func dismissAlertBox(text: String) {
        let alertVC : UIAlertController = UIAlertController(title: "Alert", message: text, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction.init(title: "Okay", style: .default) { (UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertVC.addAction(dismissAction)
        
        present(alertVC, animated: true, completion: nil)
    }
}
