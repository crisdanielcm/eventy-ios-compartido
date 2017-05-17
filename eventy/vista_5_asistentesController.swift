//
//  vista_5_asistentesController.swift
//  eventy
//
//  Created by Cristian Cruz on 5/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit
import Alamofire

class vista_5_asistentesController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var tableAsistentes: UITableView!
    var listAsistentes = [[String:Any]]()
    typealias JSONStandard = [String : AnyObject]
    var id_evento:Int!
    var totalPaginas = 0
    var paginaActual = 1
    var nombreEvento:String!
    @IBOutlet weak var evento: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        self.evento.text = self.nombreEvento
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.white
        if(totalPaginas == 0){
            cargarAsistentes(pagina: 1)
        }else{
            cargarAsistentes(pagina: paginaActual)
        }

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
    
    func cargarAsistentes( pagina:Int ) {
        
        let parameter:Parameters = ["id_evento": id_evento, "num_pagina": pagina, "cant_registros": 10]
        request("\(ip)/obtener_asistentes_evento/", method: .post,parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON{ response in
            switch response.result{
            case .success:
                
                self.parserData(JSONData: response.data!)
                self.paginaActual = self.paginaActual + 1
                if(self.paginaActual > self.totalPaginas){
                    self.paginaActual = 1
                }
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func parserData(JSONData: Data){
        
        do{
            let readableJSON = try (JSONSerialization.jsonObject(with: JSONData, options:JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] )!
            
            let asistentesArray:NSArray = readableJSON["asistentes"] as! NSArray
            totalPaginas = readableJSON["total_paginas"] as! Int
            for item in asistentesArray {
                let datos = try JSONSerialization.data(withJSONObject: item, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                var itemJson = try JSONSerialization.jsonObject(with: datos, options: .mutableContainers) as! JSONStandard
                
                let id = itemJson["id"] as! Int!
                let nombre = itemJson["nombre"] as! String!
                let celular = itemJson["celular"] as! String!
                let email = itemJson["email"] as! String
                let cargo = itemJson["cargo"] as! String
                var imagen = itemJson["foto"]
                var direccion = ""
                if let x = imagen as? String {
                    
                    direccion = imagen as! String!
                }else{
                    direccion = "none"
                }
                let infoOption:[String: Any]  = ["id":id as NSInteger!,"nombre":nombre!, "celular": celular!, "email":email, "cargo": cargo, "imagen": direccion] as [String : Any]
                listAsistentes.append(infoOption)
            }
            
            self.tableAsistentes.reloadData()
        }
        catch{
            print(error)
        }
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        return listAsistentes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAsistentes", for: indexPath) as! asistentesTableViewCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatManager : ALChatManager = ALChatManager(applicationKey: ALChatManager.applicationId as NSString)
        chatManager.launchChatForUser("\(listAsistentes[indexPath.row]["id"] as! Int)", fromViewController: self)
    }
    
    func configureCell(cell: asistentesTableViewCell, indexPath: NSIndexPath){
        
        let nombre:String = listAsistentes[indexPath.row]["nombre"] as! String
        let logo:String = listAsistentes[indexPath.row]["imagen"] as! String
        cell.configureCell(image:logo, nombreOption:nombre)
    }

    @IBAction func close(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let height = scrollView.frame.size.height
        
        let contentYoffset = scrollView.contentOffset.y
        
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset-30
        
        if(distanceFromBottom < height)
        {
            cargarAsistentes(pagina: paginaActual)
            
        }
    }

    

}
