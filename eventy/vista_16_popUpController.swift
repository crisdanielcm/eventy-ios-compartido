//
//  popUpController.swift
//  eventy
//
//  Created by Cristian Cruz on 1/03/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift

class popUpController: UIViewController {

    @IBOutlet weak var enviar: UIButton!
    @IBOutlet weak var cancelar: UIButton!
    @IBOutlet weak var texto: UITextView!
    var id_actividad:Int!
    var id_evento:Int!
    var id_asistente:Int!
    
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
    
    func displayMessage(){
        self.view.alpha = 0
        
        let delegate:UIApplicationDelegate = UIApplication.shared.delegate!
        let window:UIWindow! = delegate.window!
        window.rootViewController?.dismiss(animated: false, completion: nil)
        window.rootViewController!.present(self, animated: false, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.view.alpha = 1
        }) { (Bool) -> Void in
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.view.alpha = 0
        }) { (Bool) -> Void in
            self.dismiss(animated: false, completion: nil)
        }
    }
   
    @IBAction func enviar(_ sender: UIButton) {
        let texto:String = self.texto.text
        
        if(texto == ""){
            self.view.makeToast("Por favor ingrese su pregunta")
        }else{
            let parameter:Parameters = ["id_actividad": id_actividad!, "id_asistente": self.id_asistente!, "texto": texto]
            request("\(ip)/enviar_duda/", method: .post,parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON{ response in
                switch response.result{
                case .success:
                    
                    self.view.makeToast("Pregunta enviada con éxito")
                    UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                        self.view.alpha = 0
                    }) { (Bool) -> Void in
                        self.dismiss(animated: false, completion: nil)
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }

        }
        
        
    }
    

}
