//
//  asistentesTableViewCell.swift
//  eventy
//
//  Created by Cristian Cruz on 6/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit

class asistentesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nombre: UITextView!
    @IBOutlet weak var logo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(image:String, nombreOption:String){
        self.nombre.text = nombreOption
        if(image != "none"){
            let url = URL(string: "\(ip)\(image)")!
            self.logo.kf.setImage(with: url, placeholder: nil)
        }
        self.logo.layer.cornerRadius = self.logo.frame.size.width/2;
        self.logo.clipsToBounds = true
    }

}
