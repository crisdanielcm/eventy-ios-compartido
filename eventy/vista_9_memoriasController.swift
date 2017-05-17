//
//  vista_9_memoriasController.swift
//  eventy
//
//  Created by Cristian Cruz on 10/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit
import Alamofire

class vista_9_memoriasController: BaseViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableMemorias: UITableView!
    typealias JSONStandard = [String : AnyObject]
    var listMemorias=[[String:Any]]()
    var id_evento:Int!
    
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
        
        let parameter1:Parameters = ["id_evento": id_evento]
        request("\(ip)/obtener_memorias/", method: .post,parameters: parameter1, encoding: JSONEncoding.default).validate().responseJSON{ response in
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
                
                print(itemJson)
                let nombreMemoria = itemJson["nombre"] as! String
                let memoria = itemJson["memoria_set"] as! NSArray
                var memoriasArray=[[String:Any]]()
                for item2 in memoria {
                    let json = item2 as! JSONStandard
                    let id = json["id"] as! Int!
                    let nombre = json["nombre"] as! String
                    let archivo = json["archivo"] as! String
                    let descripcion = " "
                    let infoOption2:[String: Any]  = ["nombre" : nombre, "id":id!, "archivo": "\(ip)\(archivo)", "descripcion":descripcion]
                    memoriasArray.append(infoOption2)

                }
                let infoOption:[String: Any]  = ["nombre":nombreMemoria,"memorias": memoriasArray] as [String : Any]
                listMemorias.append(infoOption)
            }
            self.tableMemorias.reloadData()
        }
        catch{
            print(error)
        }
    }
    
    //MARK: Tableview
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return listMemorias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memoriasCell", for: indexPath) as! memoriasTableViewCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableMemorias{
            
            let vistaMemoriasA = storyboard?.instantiateViewController(withIdentifier: "memoriasA") as! vista_12_memoriasArchivosController
            let select = self.listMemorias[indexPath.row]["memorias"] as! [[String:Any]]
            vistaMemoriasA.listMemoriasA = select
            vistaMemoriasA.nombreA = self.listMemorias[indexPath.row]["nombre"] as! String
            self.navigationController?.pushViewController(vistaMemoriasA, animated: true)
        }
        else{
            
        }
    }
    
    func configureCell(cell: memoriasTableViewCell, indexPath: NSIndexPath){
        
        let nombre:String = listMemorias[indexPath.row]["nombre"] as! String
        cell.configureCell(nombre:nombre )
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
