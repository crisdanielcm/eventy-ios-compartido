//
//  empresasTableViewCell.swift
//  eventy
//
//  Created by Cristian Cruz on 6/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit

class empresasTableViewCell: UITableViewCell {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var nombre: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(image:String, nombreOption:String){
        self.nombre.text = nombreOption
        let url = URL(string: "\(ip)\(image)")!
        self.logo.kf.setImage(with: url, placeholder: nil)
    }
}
