//
//  memoriasTableViewCell.swift
//  eventy
//
//  Created by Cristian Cruz on 10/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit

class memoriasTableViewCell: UITableViewCell {

    @IBOutlet weak var nombreMemoria: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(nombre:String){
        self.nombreMemoria.text = nombre
    }
}
