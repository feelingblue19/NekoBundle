//
//  TableBundle.swift
//  NekoBundle-ios
//
//  Created by Lab_PK_20 on 26/11/18.
//  Copyright © 2018 Ryandi Widjaja. All rights reserved.
//

import UIKit

class TableBundle: UITableViewCell {

    @IBOutlet weak var gambarBundle: UIImageView!
    @IBOutlet weak var labelHarga: UILabel!
    @IBOutlet weak var labelNama: UILabel!
    var idBundle: Int!
    var stock: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
