//
//  encuestaTableViewCell.swift
//  eventy
//
//  Created by Cristian Cruz on 27/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit

class encuestaTableViewCell: UITableViewCell {

    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var check: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func changeImagen(seleccion:Bool){
        if(seleccion){
            check.image = UIImage(named: "radiobot")
        }else{
            check.image = UIImage(named: "radiobotover")
        }
    }
    
    func configureCell(nombre: String, seleccion:Bool){
        self.nombre.text = nombre
        if(seleccion){
            check.image = UIImage(named: "radiobot")
        }else{
            check.image = UIImage(named: "radiobotover")
        }
    }
}
