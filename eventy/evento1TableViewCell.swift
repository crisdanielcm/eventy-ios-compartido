//
//  evento1TableViewCell.swift
//  eventy
//
//  Created by Cristian Cruz on 26/01/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit

class evento1TableViewCell: UITableViewCell {
    @IBOutlet weak var nameOption: UITextView!
    @IBOutlet weak var imageEvento: UIImageView!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var descriptionOption: UITextView!
    
    override func awakeFromNib() {
      
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(imageEvento:String, nombreOption:String, descriptionOption:String){
        self.nameOption.text = nombreOption
        self.descriptionOption.text = descriptionOption
        self.imageEvento.image = UIImage(named: imageEvento)
    }
}
