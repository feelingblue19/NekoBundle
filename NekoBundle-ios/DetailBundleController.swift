//
//  DetailBundleController.swift
//  NekoBundle-ios
//
//  Created by Lab_PK_20 on 26/11/18.
//  Copyright © 2018 Ryandi Widjaja. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DetailBundleController: UIViewController {
    
    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var labelHarga: UILabel!
    @IBOutlet weak var labelStok: UILabel!
    @IBOutlet weak var gambarBundle: UIImageView!
    @IBOutlet weak var labelTotal: UILabel!
    var idBundle: Int!
    var userID: Int!
    @IBOutlet weak var btnBeli: UIButton!
    @IBOutlet weak var txtJumlah: UITextField!
    @IBOutlet weak var roundedButtonBeli: UIButton!
    
    let key = UserDefaults.standard.string(forKey: "login_key")
    let URL_GET_BUNDLE = "https://ios.project-tf.xyz/api/bundle/show/"
    let URL_JSON_GET_USERID  = "https://ios.project-tf.xyz/api/users/show/"
    let URL_JSON_CREATE = "https://ios.project-tf.xyz/api/transaksibundle/create"
    let URL_JSON_UPDATE = "https://ios.project-tf.xyz/api/bundle/"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundedButtonBeli.layer.cornerRadius = 12

        Alamofire.request(URL_GET_BUNDLE + String(idBundle), method: .get).validate().responseJSON { response in
            switch response.result {
            case .success:
                let json = response.result.value
                let bundles = Bundle.init(json: json as! [String: Any])
                self.labelNama.text=bundles.nama
                self.labelHarga.text=bundles.harga
                self.labelStok.text=bundles.stock
                Alamofire.request(bundles.gambar!).responseImage { response in
                    if let image = response.result.value {
                        self.gambarBundle.image = image
                    }
                }
                
            case .failure(let error):
                print(error)
                break
            }
        }
        
        if key == "nil" {
            dismiss(animated: false, completion: nil)
        }
        else {
            Alamofire.request(URL_JSON_GET_USERID + key!).responseJSON { response in
                if let json = response.result.value {
                    let user = User.init(json: json as! [String: Any])
                    self.userID=user.id
                    print(self.userID)
                }
            }
        }
    }
    
    @IBAction func buttonBeli(_ sender: Any) {
        let parameters: Parameters = [
            "user_id": self.userID,
            "bundle_id": self.idBundle,
            "jumlah": Int(self.txtJumlah.text!)!,
            "total_harga": Int(self.labelTotal.text!)!
        ]
        
        Alamofire.request(self.URL_JSON_CREATE, method: .post, parameters: parameters).validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print(response)
                    
                    break
                case .failure:
                    break
                }
        }
        
        let parameters_update: Parameters = [
            "jumlah": Int(self.txtJumlah.text!)!
            
        ]
        
        Alamofire.request(URL_JSON_UPDATE + String(idBundle), method: .put, parameters: parameters_update).validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print(response)
                    self.dismissAlertBox(text: "Bundle has been bought!")
                    break
                case .failure:
                    break
                }
        }
        
        let update: Int = Int(self.labelStok.text!)!-Int(self.txtJumlah.text!)!
        self.labelStok.text=String(update)
        
        
        
        
    }
    
    @IBAction func actionJumlah(_ sender: UITextField) {
        let jumlah: Int = Int(sender.text ?? "") ?? 0
        let harga: Int = Int(self.labelHarga.text!)!
        let total: Int = jumlah*harga
        self.labelTotal.text=String(total)
        if sender.text == "" {
            btnBeli.isEnabled=false
        }
        else{
            btnBeli.isEnabled=true
        }
        
        
    }
    
    
    @IBAction func buttonBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
