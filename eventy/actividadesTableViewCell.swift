//
//  actividadesTableViewCell.swift
//  eventy
//
//  Created by Cristian Cruz on 26/01/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit

class actividadesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameEvent: UITextView!
    @IBOutlet weak var hourEvent: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(nameEvent:String, hourEvent:String){
        self.nameEvent.text = nameEvent
        self.hourEvent.text = hourEvent
    }
}
