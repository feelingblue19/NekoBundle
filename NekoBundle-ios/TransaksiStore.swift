//
//  TransaksiStore.swift
//  NekoBundle-ios
//
//  Created by lab_pk_23 on 26/11/18.
//  Copyright © 2018 Ryandi Widjaja. All rights reserved.
//

import Foundation
class TransaksiStore : NSObject{
    var id: Int!;
    var user_id:Int!;
    var game_id:Int!;
    var jumlah:Int!;
    var total_harga:Int!;
    
    init(json: [String: Any]) {
        
        self.id = json["id"] as? Int ?? 0
        self.user_id = json["nama"] as? Int ?? 0
        self.game_id = json["stock"] as? Int ?? 0
        self.jumlah = json["harga"] as? Int ?? 0
        self.total_harga = json["gambar"] as? Int ?? 0
    }
}
