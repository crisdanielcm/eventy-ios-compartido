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
import MobileCoreServices

class vista_10_agendaController: BaseViewController, UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate {
    
    @IBOutlet weak var image: UIImageView!
    var usuario = [String:Any]()
    var mensaje:String!
    var id_evento:Int!
    var nombre_evento:String!
    
    @IBOutlet weak var btnClickMe: UIButton!
    @IBOutlet weak var cargo: UITextField!
    @IBOutlet weak var empresa: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var apellido: UITextField!
    @IBOutlet weak var nombre: UITextField!
    
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    
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
        border(textField: empresa)
        border(textField: email!)
        border(textField: nombre)
        border(textField: apellido)
        
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
        picker!.delegate=self
        // Do any additional setup after loading the view.
    }
    func border(textField:UITextField){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
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
        
        
        let parameter1:Parameters =
        [
            "id_asistente": id!,
            "nombre": nombre!,
            "apellido": apellido!,
            "email": email!,
            "cargo": cargo!,
            "foto": strBase64,
            "id_empresa": id_emp!
        ]
        
        request("\(ip)/editar_datos/", method: .post,parameters: parameter1, encoding: JSONEncoding.default).validate().responseJSON {
            response in
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
            let storyboard2 = UIStoryboard(name: "PrimeraParte", bundle: nil)
            let vistaevento = storyboard2.instantiateViewController(withIdentifier: "evento") as! eventoController
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
    
    @IBAction func action(_ sender: UIButton) {
        let alert:UIAlertController=UIAlertController(title: "Elegir Imagen", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camara", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
            
        }
        let gallaryAction = UIAlertAction(title: "Galeria", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
            
        }
        
        // Add the actions
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: alert)
            popover!.present(from: btnClickMe.frame, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
        }

    }
    
    func openCamera(){
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            self.present(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallery()
        }

    }
    
    func openGallery(){
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(picker!, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker!)
            popover!.present(from: btnClickMe.frame, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
        }

    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        picker .dismiss(animated: true, completion: nil)
        image.image=info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
   
    
}

