//
//  splashController.swift
//  eventy
//
//  Created by Cristian Cruz on 2/03/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit

class splashController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        perform(#selector(splashController.showmainmenu), with: nil, afterDelay: 0.0001)

    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showmainmenu(){
        let defaults = UserDefaults.standard
        let value = defaults.bool(forKey: "inicio")
        if(value){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let view = storyBoard.instantiateViewController(withIdentifier: "vistamenu") as! UINavigationController
            self.present(view, animated: true, completion: nil)
            
            
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let view = storyBoard.instantiateViewController(withIdentifier: "advertenciaVC") as! advertenciaController
            self.present(view, animated: true, completion: nil)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
}
