//
//  vista_8_carneController.swift
//  eventy
//
//  Created by Cristian Cruz on 9/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit
import QRCode

class vista_8_carneController: BaseViewController {

    @IBOutlet weak var imageCarne: UIImageView!
    var id_evento:Int!
    @IBOutlet weak var nombreEvento: UILabel!
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var nombreView: UILabel!
    @IBOutlet weak var cargoView: UILabel!
    @IBOutlet weak var empresaView: UILabel!
    @IBOutlet weak var codeQR: UIImageView!
    @IBOutlet weak var editarRegistro: UIButton!
    
    var usuario = [String:Any]()
    var celular:String! = nil
    var navigation:UINavigationController! = nil
    let preference = UserDefaults.standard
    var nombreEvent:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 0.96 , green: 0.08, blue: 0.33, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.init(red: 0.96 , green: 0.08, blue: 0.33, alpha: 1)
        
        
        if preference.object(forKey: "id:\(id_evento)") != nil {
            //  exist
            editarRegistro.isEnabled = true
            let nombre = preference.object(forKey: "nombre:\(id_evento)") as! String
            let apellido = preference.object(forKey: "apellido:\(id_evento)") as! String
            let cargo = preference.object(forKey: "cargo:\(id_evento)") as! String
            let empresa = preference.object(forKey: "nombre_empresa:\(id_evento)") as! String
            let foto = preference.object(forKey: "foto:\(id_evento)") as! String
            let celular = preference.object(forKey: "celular:\(id_evento)") as! String
            let email = preference.object(forKey: "email:\(id_evento)") as! String
            let id_empresa = preference.object(forKey: "id_empresa:\(id_evento)") as! Int
            let id_usuario = preference.object(forKey: "id:\(id_evento)") as! Int
            let dataDecoded : Data = Data(base64Encoded: foto, options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            self.imageCarne.image = decodedimage
            self.nombreView.text = "\(nombre) \(apellido)"
            self.cargoView.text = cargo
            self.empresaView.text = empresa
            usuario = ["nombre": nombre, "apellido": apellido,"email": email, "celular": celular, "cargo":cargo, "foto": foto, "nombre_e": empresa, "id_empresa": id_empresa, "id": id_usuario] as [String : Any]
        }else{
            editarRegistro.isEnabled = false
        }
        if(celular != nil){
            let qrCode = QRCode(celular)
            self.codeQR.image = qrCode?.image
        }else{
            let celular = preference.object(forKey: "celular:\(id_evento)") as! String
            let qrCode = QRCode(celular)
            self.codeQR.image = qrCode?.image
        }
        
        
        self.imageCarne.layer.cornerRadius = self.imageCarne.frame.size.width/2;
        self.imageCarne.clipsToBounds = true
        self.nombreEvento.text = self.nombreEvent
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
    
    @IBAction func close(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editarRegistro(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vistaEdicion = storyboard.instantiateViewController(withIdentifier: "edicionRegistro") as! vista_10_agendaController
        vistaEdicion.usuario = usuario
        vistaEdicion.id_evento = id_evento
        self.navigationController?.pushViewController(vistaEdicion, animated: true)

    }
    
}
