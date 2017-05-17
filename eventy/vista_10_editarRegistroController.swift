//
//  vista_10_agendaController.swift
//  eventy
//
//  Created by Cristian Cruz on 13/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift

class vista_10_agendaController: BaseViewController {

    @IBOutlet weak var image: UIImageView!
    var usuario = [String:Any]()
    var mensaje:String!
    var id_evento:Int!
    var nombre_evento:String!
    
    @IBOutlet weak var cargo: UITextField!
    @IBOutlet weak var empresa: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var apellido: UITextField!
    @IBOutlet weak var nombre: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 0.96 , green: 0.08, blue: 0.33, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.init(red: 0.96 , green: 0.08, blue: 0.33, alpha: 1)
        self.image.layer.cornerRadius = self.image.frame.size.width/2;
        self.image.clipsToBounds = true
        
        empresa.text = usuario["cargo"] as! String!
        email.text = usuario["email"] as! String!
        nombre.text = usuario["nombre"] as! String!
        apellido.text = usuario["apellido"] as! String!
        let foto:String = usuario["foto"] as! String!
        if(foto != ""){
            if(foto.contains("http://")){
                let url = URL(string: (foto))!
                self.image.kf.setImage(with: url, placeholder: nil)
            }else{
                let datacode:Data = Data(base64Encoded: foto, options: .ignoreUnknownCharacters)!
                let decodeImage:UIImage = UIImage(data: datacode)!
                self.image.image = decodeImage
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let nav = self.navigationController?.navigationBar {
            nav.setBackgroundImage(UIImage(), for: .default)
            nav.shadowImage = UIImage()
            nav.isTranslucent = true
        }
    }
    
    func doRequest(){
        
        let id = usuario["id"] as! Int!
        let nombre = self.nombre.text as String!
        let apellido = self.apellido.text as String!
        let email = self.email.text as String!
        let cargo = self.empresa.text as String!
        
        let imagen : UIImage = self.image.image!
        let imageData:NSData = UIImagePNGRepresentation(imagen)! as NSData
        let strBase64 = imageData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
        let id_emp = usuario["id_empresa"] as! Int!
        let preference = UserDefaults.standard
        preference.set(nombre, forKey: "nombre:\(id_evento)")
        preference.set(apellido, forKey: "apellido:\(id_evento)")
        preference.set(cargo, forKey: "cargo:\(id_evento)")
        preference.set(email, forKey: "email:\(id_evento)")
        preference.set(strBase64, forKey: "foto:\(id_evento)")
        
        preference.synchronize()
        
        let parameter:Parameters = ["id_asistente": id!, "nombre": nombre!, "apellido": apellido!, "email": email!, "cargo": cargo!, "foto": strBase64, "id_empresa": id_emp!]
        request("\(ip)/editar_datos/", method: .post,parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON{ response in
            switch response.result{
            case .success:
                
                self.parserdata(JSONData: response.data!)
                self.view.makeToast(self.mensaje)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func parserdata(JSONData:Data){
        
        do{
            let readableJSON = try (JSONSerialization.jsonObject(with: JSONData, options:JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] )!
            mensaje = readableJSON["mensaje"] as! String!
            
            let vistaevento = storyboard?.instantiateViewController(withIdentifier: "evento") as! eventoController
            let id = id_evento
            let nombre = nombre_evento 
            vistaevento.itemToShow = id
            vistaevento.nombre = nombre
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.pushViewController(vistaevento, animated: true)
        }
        catch{
            print(error)
        }
        
    }
    
    @IBAction func crear(_ sender: UIButton) {
        
        doRequest()
    }
    @IBAction func close(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
}
