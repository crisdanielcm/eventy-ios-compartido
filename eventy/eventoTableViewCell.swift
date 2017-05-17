//
//  eventoTableViewCell.swift
//  eventy
//
//  Created by Cristian Cruz on 22/12/16.
//  Copyright © 2016 Apliko. All rights reserved.
//

import UIKit
import Kingfisher

class eventoTableViewCell: UITableViewCell {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var logoCirculo: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(logo:String, nombre:String){
        self.nombre.text = nombre
        let url = URL(string: logo)!
        self.logo.kf.setImage(with: url, placeholder: nil)
    }

}
