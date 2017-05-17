//
//  vista_14_preguntasController.swift
//  eventy
//
//  Created by Cristian Cruz on 28/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit
import Alamofire

class vista_14_preguntasController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    typealias JSONStandard = [String : AnyObject]
    @IBOutlet weak var subview: UIView!
    var listPreguntas = [[String:Any]]()
    var id_actividad:Int?
    var id_evento:Int!
    var id_asistente:Int!
    
    @IBOutlet weak var tablePreguntas: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.white
        doRequest()
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
        
        let parameter:Parameters = ["id_evento": id_evento]
        request("\(ip)/obtener_patrocinadores/", method: .post,parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON{ response in
            switch response.result{
            case .success:
                
                self.paserDataPatrocinadores(JSONData: response.data!)
                
            case .failure(let error):
                print(error)
            }
        }
        
        let parameter1:Parameters = ["id_actividad": id_actividad!]
        request("\(ip)/obtener_dudas/", method: .post,parameters: parameter1, encoding: JSONEncoding.default).validate().responseJSON{ response in
            switch response.result{
            case .success:
                
                self.parserData(JSONData: response.data!)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func paserDataPatrocinadores(JSONData: Data){
        
        
        do{
            let readableJSON:NSArray = try (JSONSerialization.jsonObject(with: JSONData, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSArray)!
            let widthScreen = Int(self.subview.frame.width)
            let heightScreen = self.subview.frame.height
            var x = 0
            let widthImage = widthScreen/readableJSON.count
            for item in readableJSON {
                let datos = try JSONSerialization.data(withJSONObject: item, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                var itemJson = try JSONSerialization.jsonObject(with: datos, options: .mutableContainers) as! JSONStandard
                
                let logo:String = itemJson["logo"] as! String
                let urlImage = "\(ip)\(logo)"
                
                let imageView = UIImageView()
                imageView.contentMode = UIViewContentMode.scaleAspectFit
                imageView.kf.setImage(with: URL(string:urlImage), placeholder:nil)
                imageView.frame = CGRect(x: x, y: Int(heightScreen)/8, width: widthImage, height: Int(Double(heightScreen)/1.3))
                subview.addSubview(imageView)
                x = x + widthImage
            }
            
        }
        catch{
            print(error)
        }
    }
    
    func parserData(JSONData:Data){
        
        do{
            let readableJSON:NSArray = try (JSONSerialization.jsonObject(with: JSONData, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSArray)!
            
            for item in readableJSON {
                let datos = try JSONSerialization.data(withJSONObject: item, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                var itemJson = try JSONSerialization.jsonObject(with: datos, options: .mutableContainers) as! JSONStandard
                
                print(itemJson)
                let pregunta = itemJson["texto"] as! String
                let infoOption:[String: Any]  = ["texto":pregunta] as [String : Any]
                listPreguntas.append(infoOption)
            }
            tablePreguntas.reloadData()
        }
        catch{
            print(error)
        }
    }
    
    /*func popup (){
        
        let alert = UIAlertController(title: "Escribe tu pregunta", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Enviar", style: UIAlertActionStyle.default){
            UIAlertAction in
            
        })
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default){
            UIAlertAction in
            
        })
        alert.addTextField { (textField) -> Void in
            let searchTextField = textField
            searchTextField.placeholder = "Enter your search terms"
        }
        alert.view.backgroundColor = UIColor.white
        alert.view.layer.cornerRadius = 5;
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }*/
    
    @IBAction func actioPopUp(_ sender: UIButton) {
        //popup()
        let pop = popUpController(nibName: "popUpController", bundle: nil)
        pop.id_actividad = self.id_actividad
        pop.id_evento = self.id_evento
        pop.id_asistente = self.id_asistente
        pop.view.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        present(pop, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Table
    */
    
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return listPreguntas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "preguntasCell", for: indexPath) as! preguntasTableViewCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: preguntasTableViewCell, indexPath: NSIndexPath){
        let pregunta:String = listPreguntas[indexPath.row]["texto"] as! String
        cell.configureCell(pregunta:pregunta, numero: indexPath.row+1)
    }
    @IBAction func close(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
}
