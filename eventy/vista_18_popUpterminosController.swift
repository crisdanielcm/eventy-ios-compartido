//
//  vista_18_popUpterminosController.swift
//  eventy
//
//  Created by Cristian Cruz on 2/03/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit

class vista_18_popUpterminosController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func aceptar(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.view.alpha = 0
        }) { (Bool) -> Void in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func displayMessage(){
        self.view.alpha = 0
        let delegate:UIApplicationDelegate = UIApplication.shared.delegate!
        let window:UIWindow! = delegate.window!
        window.rootViewController!.present(self, animated: true, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.view.alpha = 1
        }) { (Bool) -> Void in
        }
    }
}
