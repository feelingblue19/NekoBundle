//
//  Bundle.swift
//  NekoBundle-ios
//
//  Created by Lab_PK_20 on 26/11/18.
//  Copyright © 2018 Ryandi Widjaja. All rights reserved.
//

import Foundation
class Bundle : NSObject{
    var id: Int!;
    var nama:String!;
    var stock:String!;
    var harga:String!;
    var gambar:String!;
    
    //    init(id: String?, nama: String?, stock: String?, harga: String?, gambar: String?) {
    //
    //        self.id = id
    //        self.nama = nama
    //        self.stock = stock
    //        self.harga = harga
    //        self.gambar = gambar
    //    }
    
    init(json: [String: Any]) {
        
        self.id = json["id"] as? Int ?? 0
        self.nama = json["nama"] as? String ?? ""
        self.stock = json["stock"] as? String ?? ""
        self.harga = json["harga"] as? String ?? ""
        self.gambar = json["gambar"] as? String ?? ""
        
        
        
    }
    
    //    func printData(){
    //
    //        print(
    //            "id: ",self.id,
    //            "nama : ",self.nama,
    //            "stock : ",self.stock,
    //            "harga : ",self.harga,
    //            "gambar: ", self.gambar
    //        )
    //    }
}
