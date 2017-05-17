//
//  memoriasArchivosTableViewCell.swift
//  eventy
//
//  Created by Cristian Cruz on 24/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit

class memoriasArchivosTableViewCell: UITableViewCell {

    @IBOutlet weak var nombre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(nombre:String){
        self.nombre.text = nombre
    }

}
