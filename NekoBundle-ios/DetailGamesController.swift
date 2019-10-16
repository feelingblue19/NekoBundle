//
//  DetailGamesController.swift
//  NekoBundle-ios
//
//  Created by Lab_PK_20 on 26/11/18.
//  Copyright © 2018 Ryandi Widjaja. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DetailGamesController: UIViewController {
    
    @IBOutlet weak var gambar: UIImageView!
    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var labelHarga: UILabel!
    @IBOutlet weak var labelJumlah: UILabel!
    var idGames: Int!
    var userID: Int!
    var totalHarga: Int!
    @IBOutlet weak var btnBeli: UIButton!
    
    
    let key = UserDefaults.standard.string(forKey: "login_key")
    
    let URL_GET_GAMES = "https://ios.project-tf.xyz/api/games/show/"
    let URL_JSON_GET_USERID  = "https://ios.project-tf.xyz/api/users/show/"
    let URL_JSON_CREATE = "https://ios.project-tf.xyz/api/transaksi/create"
    let URL_JSON_UPDATE = "https://ios.project-tf.xyz/api/games/"
    
    @IBOutlet weak var buttonBeli: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //buttonBeli.isEnabled=false
        btnBeli.layer.cornerRadius = 12
        
        Alamofire.request(URL_GET_GAMES + String(idGames), method: .get).validate().responseJSON { response in
            switch response.result {
            case .success:
                let json = response.result.value
                let games = Games.init(json: json as! [String: Any])
                self.labelNama.text=games.nama
                self.labelHarga.text=games.harga
                self.labelJumlah.text=games.stock
                self.totalHarga = Int(games.harga)
                Alamofire.request(games.gambar!).responseImage { response in
                    if let image = response.result.value {
                        self.gambar.image = image
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
                print("Request: \(String(describing: response.request))")
                print("Result: \(response.result)")
                if let data = response.result.value {
                    print("JSON: \(data)")
                    let user = User.init(json: data as! [String : Any])
                    self.userID = user.id
                    print(self.userID)
                    
                }
            }
            
        }
        
    }
    
    @IBAction func btnBeli(_ sender: Any) {
        
        let parameters_update: Parameters = [
            "jumlah": 1
            
        ]
        
        Alamofire.request(URL_JSON_UPDATE + String(idGames), method: .put, parameters: parameters_update).validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("response update")
                    print(response)
                    
                    let parameters: Parameters = [
                        "user_id": self.userID,
                        "game_id": self.idGames,
                        "jumlah": 1,
                        "total_harga": self.totalHarga
                    ]
                    
                    print(parameters)
                    
                    Alamofire.request(self.URL_JSON_CREATE, method: .post, parameters: parameters).validate()
                        .responseJSON { response in
                            switch response.result {
                            case .success:
                                print("post ke trans")
                                print(response)
                                
                                self.dismissAlertBox(text: "Game has been bought!")
                                break
                            case .failure:
                                break
                            }
                    }
                    
                    break
                case .failure:
                    break
                }
        }
        
        
        let update: Int = Int(self.labelJumlah.text!)!-Int(1)
        self.labelJumlah.text=String(update)
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
