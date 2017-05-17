//
//  vista_7_registroController.swift
//  eventy
//
//  Created by Cristian Cruz on 8/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit
import AVFoundation

class vista_7_registroController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var buttonCheck: UIButton!
    @IBOutlet weak var camara: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alert(){
        let alertController = UIAlertController(title: "Cargar imagen", message: "", preferredStyle: .alert)
        let gallery = UIAlertAction(title: "Seleccionar de la galeria", style: .default, handler: {(action:UIAlertAction)-> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        let camera = UIAlertAction(title: "Tomar una foto", style: .default, handler: {(action:UIAlertAction)-> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        let cancel = UIAlertAction(title: "Cancelar", style: .default, handler: {(action:UIAlertAction)-> Void in
            
        })
        alertController.addAction(gallery)
        alertController.addAction(camera)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func checkBox(_ sender: UIButton) {
       
        let imagename = sender.currentImage
        let uncheck = UIImage(named: "vista_1_recuadro_terminos")
        let check = UIImage(named: "vista_1_check")
        if(imagename == uncheck){
            self.buttonCheck.setImage(uncheck, for: .normal)
            self.buttonCheck.setImage(check, for: .highlighted)
        }else if(imagename == check){
            self.buttonCheck.setImage(check, for: .normal)
            self.buttonCheck.setImage(uncheck, for: .highlighted)
        }
    }
    @IBAction func actionCameraG(_ sender: UIButton) {
        
        alert()
    }
}
