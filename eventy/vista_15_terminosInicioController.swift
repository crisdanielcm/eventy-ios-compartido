//
//  vista_15_terminosInicioController.swift
//  eventy
//
//  Created by Cristian Cruz on 2/03/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit

class vista_15_terminosInicioController: UIViewController {
    
    @IBOutlet weak var check: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pressed(_ sender: UIButton) {
        let imagename = sender.currentImage
        let uncheck = UIImage(named: "vista_1_recuadro_terminos")
        let check = UIImage(named: "vista_1_check")
        if(imagename == uncheck){
            self.check.setImage(uncheck, for: .normal)
            self.check.setImage(check, for: .highlighted)
        }else if(imagename == check){
            self.check.setImage(check, for: .normal)
            self.check.setImage(uncheck, for: .highlighted)
        }
    }
    
    @IBAction func continuarPressed(_ sender: UIButton) {
        
        if(check.currentImage == UIImage(named: "vista_1_check")){
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "inicio")
            let storyBoard : UIStoryboard = UIStoryboard(name: "PrimeraParte", bundle:nil)
            let view = storyBoard.instantiateViewController(withIdentifier: "vistamenu") as! UINavigationController
            self.present(view, animated: true, completion: nil)
        }else{
            let pop = vista_18_popUpterminosController(nibName: "vista_18_popUpterminosController", bundle: nil)
            pop.view.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            present(pop, animated: true, completion: nil)
        }
    }

}
