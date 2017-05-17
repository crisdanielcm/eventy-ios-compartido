//
//  preguntasTableViewCell.swift
//  eventy
//
//  Created by Cristian Cruz on 28/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit

class preguntasTableViewCell: UITableViewCell {

    @IBOutlet weak var pregunta: UILabel!
    @IBOutlet weak var numero: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(pregunta:String, numero:Int){
        self.pregunta.text = pregunta
        self.numero.text = "PREGUNTA \(numero)"
    }
}
