//
//  vista_17_popupPrivadoController.swift
//  eventy
//
//  Created by Cristian Cruz on 2/03/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift

class vista_17_popupPrivadoController: UIViewController {

    @IBOutlet weak var celular: UITextView!
    var id_evento:Int!
    var nombre_evento:String!
    var usuario = [String:Any]()
    typealias JSONStandard = [String : AnyObject]
    var navigation:UINavigationController! = nil
    
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
    

    
    @IBAction func cancelar(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.view.alpha = 0
        }) { (Bool) -> Void in
            self.dismiss(animated: false, completion: nil)
        }
    }

    @IBAction func enviar(_ sender: UIButton) {
        let celu:String = celular.text!
        if(celu == ""){
            
        }else{
            let parameter:Parameters = ["id_evento": id_evento, "celular":celu]
            request("\(ip)/ingresar_evento_privado/", method: .post,parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON{ response in
                switch response.result{
                case .success:
                    
                    self.parserdata(JSONData: response.data!)
                    
                case .failure:
                    self.celular.text = ""
                    self.view.makeToast("No se encontro un asistente con el numero de celular dado")
                }
            }
        }
    }
    
    func parserdata(JSONData: Data){
        
        do{
            var readableJSON = try (JSONSerialization.jsonObject(with: JSONData, options:JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] )!
                
            
                
            let id:Int = readableJSON["id"] as! Int!
            let nombre:String = readableJSON["nombre"] as! String!
            let apellido:String = readableJSON["apellido"] as! String!
            let celular:String = readableJSON["celular"] as! String!
            let email:String = readableJSON["email"] as! String!
            let cargo:String = readableJSON["cargo"] as! String!
            var foto:String = ""
            if let imagen = readableJSON["foto"] as? String{
                foto = "\(ip)\(imagen)"
            }
            let empresa = readableJSON["empresa"] as! JSONStandard
            let id_empresa = empresa["id"] as! Int!
            let nombre_empresa = empresa["nombre"]
            let infoOption:[String: Any]  = ["id":id as NSInteger!, "nombre": nombre, "apellido": apellido, "celular": celular, "email": email, "cargo":cargo, "foto": foto, "id_empresa": id_empresa!, "nombre_e": nombre_empresa!] as [String : Any]
            usuario=infoOption
            
            let preferences = UserDefaults.standard
            preferences.set(id, forKey: "id:\(id_evento)")
            preferences.set(nombre, forKey: "nombre:\(id_evento)")
            preferences.set(apellido, forKey: "apellido:\(id_evento)")
            preferences.set(celular, forKey: "celular:\(id_evento)")
            preferences.set(email, forKey: "email:\(id_evento)")
            preferences.set(cargo, forKey: "cargo:\(id_evento)")
            preferences.set(foto, forKey: "foto:\(id_evento)")
            preferences.set(id_empresa, forKey: "id_empresa:\(id_evento)")
            preferences.set(nombre_empresa, forKey: "nombre_empresa:\(id_evento)")
            preferences.synchronize()
                        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vistaEdicion = storyboard.instantiateViewController(withIdentifier: "edicionRegistro") as! vista_10_agendaController
            vistaEdicion.usuario = usuario
            vistaEdicion.id_evento = id_evento
            vistaEdicion.nombre_evento = nombre_evento
            self.navigation.pushViewController(vistaEdicion, animated: true)
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                self.view.alpha = 0
            }) { (Bool) -> Void in
                self.dismiss(animated: false, completion: nil)
            }
        }
        catch{
            print(error)
        }
    }
}
