//
//  ViewController.swift
//  eventy
//
//  Created by Cristian Cruz on 20/12/16.
//  Copyright © 2016 Apliko. All rights reserved.
//

import UIKit
import Alamofire

class menuController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var tableEvento: UITableView!
    @IBOutlet weak var arrow: UIImageView!
    
    typealias JSONStandard = [String : AnyObject]
    var listEventos = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.white
        doRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    //MARK: Actions
    func doRequest(){
        
        let headers: HTTPHeaders = [
            "Authorization": "Token 38d2a86f616377e30befa2378dab58db902a66c6",
            "Content-Type": "application/json"
        ]
        request("\(ip)/obtener_eventos/", method: .get, encoding: JSONEncoding.default,headers: headers).validate().responseJSON{ response in
            switch response.result{
            case .success:
                
                self.paserData(JSONData: response.data!)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func paserData(JSONData: Data){
        
        
        do{
            let readableJSON:NSArray = try (JSONSerialization.jsonObject(with: JSONData, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSArray)!
            
            for item in readableJSON {
                let datos = try JSONSerialization.data(withJSONObject: item, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                var itemJson = try JSONSerialization.jsonObject(with: datos, options: .mutableContainers) as! JSONStandard
                
                let evento = itemJson["evento"] as? JSONStandard
                let id = evento?["id"] as! Int!
                let nombre = evento?["nombre"] as! String!
                let tipo = evento?["tipo"] as! String
            
                let fecha_inicio = itemJson["fecha_inicio"] as! String
                let fecha_fin = itemJson["fecha_fin"] as! String
                let logo = itemJson["logo"] as! String
                let localizacion = itemJson["localizacion"] as! String
                let infoOption:[String: Any]  = ["id":id as NSInteger!,"nombre":nombre!, "tipo":tipo, "fecha_inicio": fecha_inicio, "fecha_fin": fecha_fin, "logo": logo, "localizacion": localizacion] as [String : Any]
                
                listEventos.append(infoOption)
            }
            
        }
        catch{
            print(error)
        }
        self.tableEvento.reloadData()
    }
    
    func parserDataPublico(JSONData:Data, id_evento:Int, nombre_evento:String){
        
        do{
            let preferences = UserDefaults.standard

            var id_asis = preferences.object(forKey: "id:\(id_evento)") as! Int!

            var readableJSON = try (JSONSerialization.jsonObject(with: JSONData, options:JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] )!
            let id_asistente:Int = readableJSON["id_asistente"] as! Int
            let celular:String = readableJSON["celular"] as! String

            preferences.set(id_asistente, forKey: "id:\(id_evento)")
            preferences.set(celular, forKey: "celular:\(id_evento)")
            preferences.synchronize()
            
            let vistaevento = storyboard?.instantiateViewController(withIdentifier: "evento") as! eventoController
            let id = id_evento
            let nombre = nombre_evento
            vistaevento.itemToShow = id
            vistaevento.nombre = nombre
            id_asis = preferences.object(forKey: "id:\(id_evento)") as! Int!
            vistaevento.id_asistente = id_asistente
            vistaevento.celular = celular
            self.navigationController?.pushViewController(vistaevento, animated: true)
            
        }catch{
            print(error)
        }
        
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Tableview
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return listEventos.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = listEventos[indexPath.row]
        let estado = item["tipo"] as! String
        let id_evento = item["id"] as! Int!
        let preferences = UserDefaults.standard
        
        var id_asis = preferences.object(forKey: "id:\(id_evento)") as! Int!
        
        if(estado == "Privado"){
            let id_evento = id_evento
            
            if preferences.object(forKey: "id:\(id_evento)") == nil {
                //si entra por primera vez en el app
                let pop = vista_17_popupPrivadoController(nibName: "vista_17_popupPrivadoController", bundle: nil)
                pop.id_evento = item["id"] as! Int!
                pop.navigation=self.navigationController
                pop.nombre_evento = item["nombre"] as! String
                pop.view.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
                present(pop, animated: true, completion: nil)

            } else {
                let vistaevento = storyboard?.instantiateViewController(withIdentifier: "evento") as! eventoController
                let id = item["id"]
                let nombre = item["nombre"] as! String
                vistaevento.itemToShow = id as! Int?
                vistaevento.nombre = nombre
                vistaevento.id_asistente = preferences.object(forKey: "id:\(id_evento)") as! Int
                self.navigationController?.pushViewController(vistaevento, animated: true)
            }
            
        }else{
            if id_asis == nil {
                let parameter:Parameters = ["id_evento": id_evento!]
                request("\(ip)/ingresar_evento_publico/", method: .post,parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON{ response in
                    switch response.result{
                    case .success:
                        self.parserDataPublico(JSONData: response.data!, id_evento: id_evento!, nombre_evento: item["nombre"] as! String)
                    case .failure(let error):
                        print(error)
                    }
                }
            }else{
                let vistaevento = storyboard?.instantiateViewController(withIdentifier: "evento") as! eventoController
                let id:Int = item["id"] as! Int
                let nombre = item["nombre"] as! String
                vistaevento.itemToShow = id as! Int?
                vistaevento.nombre = nombre
                vistaevento.id_asistente = id
                self.navigationController?.pushViewController(vistaevento, animated: true)

            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellEvento", for: indexPath) as! eventoTableViewCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectionRowEvento"{
            if let indexPath = self.tableEvento.indexPathForSelectedRow {
                let destination = segue.destination as! eventoController
                let item = listEventos[indexPath.row]
                let id = item["id"]
                let nombre = item["nombre"] as! String
                destination.itemToShow = id as! Int?
                destination.nombre = nombre
            }
            
        }
    }*/
    
    func configureCell(cell: eventoTableViewCell, indexPath: NSIndexPath){
        
        let nombre:String = listEventos[indexPath.row]["nombre"] as! String
        let logo:String = listEventos[indexPath.row]["logo"] as! String
        cell.configureCell(logo: logo, nombre:nombre )
    }
        
    @IBAction func buttonScroll(_ sender: Any) {
        let numberOfRows = tableEvento.numberOfRows(inSection: 0)
        
        let indexPath = NSIndexPath(row: numberOfRows-1, section: 0)
        self.tableEvento.scrollToRow(at: indexPath as IndexPath,
                                     at: UITableViewScrollPosition.middle, animated: true)
        
    }
    
    @IBOutlet weak var buttonScroll: UIButton!
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let height = scrollView.frame.size.height
        
        let contentYoffset = scrollView.contentOffset.y
        
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset-30
        
        if(distanceFromBottom < height)
        {

            self.buttonScroll.isHidden = true
            self.arrow.isHidden = true
        } else{
            self.buttonScroll.isHidden = false
            self.arrow.isHidden = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if let nav = self.navigationController?.navigationBar {
            nav.setBackgroundImage(UIImage(), for: .default)
            nav.shadowImage = UIImage()
            nav.isTranslucent = true
        }
    }
    
    
    
}
