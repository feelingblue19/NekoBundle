//
//  TableGames.swift
//  NekoBundle-ios
//
//  Created by Lab_PK_20 on 26/11/18.
//  Copyright © 2018 Ryandi Widjaja. All rights reserved.
//

import UIKit

class TableGames: UITableViewCell {
    @IBOutlet weak var gambarGames: UIImageView!
    @IBOutlet weak var labelJudul: UILabel!
    @IBOutlet weak var labelHarga: UILabel!
    var stock: String!
    var id: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
