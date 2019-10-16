//
//  File.swift
//  inet-reminder-ios
//
//  Created by Ryandi Widjaja on 07/11/18.
//  Copyright © 2018 Ryandi Widjaja. All rights reserved.
//

import Foundation
class User : NSObject{
    var id:Int;
    var username:String;
    var nama:String;
    var email:String;
    var password:String;
    var gender:String;
    
    init(json: [String: Any]) {
        
        self.id = json["id"] as? Int ?? 0
        self.username = json["username"] as? String ?? ""
        self.nama = json["nama"] as? String ?? ""
        self.email = json["email"] as? String ?? ""
        self.password = json["password"] as? String ?? ""
        self.gender = json["gender"] as? String ?? ""
        
    }
    
    func printData(){
        
        print(
            "username: ",self.username,
            "nama : ",self.nama,
            "email : ",self.email,
            "password : ",self.password,
            "gender: ", self.gender
        )
    }
    
    
}
