//
//  vista_4_empresasController.swift
//  eventy
//
//  Created by Cristian Cruz on 4/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit
import Alamofire

class vista_4_empresasController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableEmpresas: UITableView!
    var listEmpresas = [[String:Any]]()
    typealias JSONStandard = [String : AnyObject]
    var id_evento:Int!
    var nombreEvento:String!
    @IBOutlet weak var evento: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        self.evento.text = self.nombreEvento
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.white
        doRequest()
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
    
    //MARK: Actions
    func doRequest(){
        
        let parameter:Parameters = ["id_evento": id_evento]
        request("\(ip)/obtener_muestra_comercial/", method: .post,parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON{ response in
            switch response.result{
            case .success:
                
                self.parserData(JSONData: response.data!)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func parserData(JSONData: Data){
        
        do{
            let readableJSON:NSArray = try (JSONSerialization.jsonObject(with: JSONData, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSArray)!
            
            for item in readableJSON {
                let datos = try JSONSerialization.data(withJSONObject: item, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                var itemJson = try JSONSerialization.jsonObject(with: datos, options: .mutableContainers) as! JSONStandard
                
                let id = itemJson["id"] as! Int!
                let nombre = itemJson["nombre_empresa"] as! String!
                let descripcion = itemJson["hipervinculo"] as! String!
                let logo = itemJson["logo"] as! String
                let infoOption:[String: Any]  = ["id":id as NSInteger!,"nombre":nombre!, "descripcion": "http://\(descripcion!)", "logo":logo] as [String : Any]
                listEmpresas.append(infoOption)
            }
            
            tableEmpresas.reloadData()
        }
        catch{
            print(error)
        }
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
            return listEmpresas.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let archivo = listEmpresas[indexPath.row]["descripcion"] as! String
        UIApplication.shared.openURL(URL(string: archivo as! String)!)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellEmpresas", for: indexPath) as! empresasTableViewCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    func configureCell(cell: empresasTableViewCell, indexPath: NSIndexPath){
        
        let nombre:String = listEmpresas[indexPath.row]["nombre"] as! String
        let logo:String = listEmpresas[indexPath.row]["logo"] as! String
        cell.configureCell(image:logo, nombreOption:nombre)
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
