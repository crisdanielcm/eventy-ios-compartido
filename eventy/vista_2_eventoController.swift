//
//  eventoController.swift
//  eventy
//
//  Created by Cristian Cruz on 26/01/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftGifOrigin

class eventoController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var itemToShow:Int?
    var nombre:String?
    var celular:String!
    
    @IBOutlet weak var nombreEvento: UILabel!
    @IBOutlet weak var gifTexto: UIImageView!
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var scrollTables: UIScrollView!
    @IBOutlet weak var gifAudio: UIImageView!
    typealias JSONStandard = [String : AnyObject]
    @IBOutlet weak var tableMenuEvent: UITableView!
    @IBOutlet weak var tableEventOnline: UITableView!
    var listEventos = [[String:Any]]()
    @IBOutlet weak var subview: UIView!
    var listActividades = [[String:Any]]()
    var listActividadesAll = [[String:Any]]()
    var listPatrocinadores = [[String:Any]]()
    var id_asistente:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
                self.gifAudio.image = UIImage.gif(name: "EqualizerEventy")
        self.gifTexto.image = UIImage.gif(name: "Listen")
        self.nombreEvento.text = nombre
        let preferences = UserDefaults.standard
        preferences.set(true, forKey: "registrado:\(itemToShow)")
        let row1:[String: Any]  = ["nameOption":"AGENDA EN LINEA","descriptionOption":"Siga las actividades", "image":"iconagendalinea"] as [String : Any]
        let row2:[String: Any]  = ["nameOption":"CARNET DIGITAL","descriptionOption":"Su identificación en el evento", "image":"iconcarnetdigital"] as [String : Any]
        let row3:[String: Any]  = ["nameOption":"NETWORKING","descriptionOption":"Lista de Asistentes", "image":"iconnetworking"] as [String : Any]
        let row4:[String: Any]  = ["nameOption":"MUESTRA COMERCIAL","descriptionOption":"Empresas", "image":"iconmuestra"] as [String : Any]
        let row5:[String: Any]  = ["nameOption":"CHAT","descriptionOption":"Contáctese con los asistentes", "image":"IconChat"] as [String : Any]
        let row6:[String: Any]  = ["nameOption":"MEMORIAS DE CONFERENCIAS","descriptionOption":"Conferencias a las que asistió", "image": "iconMemorias"] as [String : Any]
        
        listEventos.append(row1)
        listEventos.append(row2)
        listEventos.append(row3)
        listEventos.append(row4)
        listEventos.append(row5)
        listEventos.append(row6)
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
    
    //MARk: Actions
    
    func doRequest(){
        
        let parameter:Parameters = ["id_evento": itemToShow!]
        request("\(ip)/obtener_actividades/", method: .post,parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON{ response in
            switch response.result{
            case .success:
                
                self.paserData(JSONData: response.data!)
                
            case .failure(let error):
                print(error)
            }
        }
        
        let parameter1:Parameters = ["id_evento": itemToShow!]
        request("\(ip)/obtener_patrocinadores/", method: .post,parameters: parameter1, encoding: JSONEncoding.default).validate().responseJSON{ response in
            switch response.result{
            case .success:
                
                self.paserDataPatrocinadores(JSONData: response.data!)
                
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
                
                let id = itemJson["id"] as! Int!
                let nombre = itemJson["nombre"] as! String!
                
                let fecha_inicio = itemJson["fecha_inicio"] as! String
                let hora_inicio = itemJson["hora_inicio"] as! String
                let hora_fin = itemJson["hora_fin"] as! String
                let infoOption:[String: Any]  = ["id":id as NSInteger!,"nombre":nombre!, "fecha_inicio": fecha_inicio, "hora_inicio":hora_inicio, "hora_fin": hora_fin] as [String : Any]
                
                let dateInicio = "\(fecha_inicio)-\(hora_inicio)"
                let dateFin = "\(fecha_inicio)-\(hora_fin)"
                let date = Date()
                let enVivo = date.isBetween(date: stringToDate(date: dateInicio), andDate: stringToDate(date: dateFin))
                
                if (enVivo){
                    listActividades.append(infoOption)
                }
                listActividadesAll.append(infoOption)
            }
            if(listActividades.count == 0){
                gifView.frame = CGRect(x: 0, y: gifView.frame.origin.y, width: 0, height: 0)
                gifAudio.isHidden = true
                gifTexto.isHidden = true
            }
            self.tableEventOnline.reloadData()
            let eventoFrame:CGRect = self.tableMenuEvent.frame
            var envivoFrame:CGRect = self.tableEventOnline.frame
            self.tableEventOnline.frame = CGRect(x: envivoFrame.origin.x, y: gifView.frame.origin.y + gifView.frame.height, width: envivoFrame.width, height: CGFloat(Int(envivoFrame.height)*listActividades.count)+CGFloat(Int(envivoFrame.height)*listActividades.count)*0.10)
            envivoFrame = self.tableEventOnline.frame
            

            let posY = envivoFrame.height + envivoFrame.origin.y
            self.tableMenuEvent.frame = CGRect(x: envivoFrame.origin.x, y: posY, width: eventoFrame.width, height: CGFloat(heigthCellMenu*6))
            
            let sizeTables = CGSize(width: tableMenuEvent.bounds.width, height: tableEventOnline.bounds.height + tableMenuEvent.bounds.height + gifView.bounds.height)
            
            scrollTables.contentSize = sizeTables
            scrollTables.autoresizingMask = UIViewAutoresizing.flexibleWidth

        }
        catch{
            print(error)
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
                let patrocinadores:[String:Any] = ["patrocinador":urlImage]
                //let hipervinculo = itemJson["hipervinculo"] as! String
                let imageView = UIImageView()
                imageView.contentMode = UIViewContentMode.scaleAspectFit
                imageView.kf.setImage(with: URL(string:urlImage), placeholder:nil)
                imageView.frame = CGRect(x: x, y: Int(heightScreen)/8, width: widthImage, height: Int(Double(heightScreen)/1.3))
                subview.addSubview(imageView)
                x = x + widthImage
                
                //Evento click Image
                /*let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapDetected(hipervinculo)"))
                singleTap.numberOfTapsRequired = 1 // you can change this value
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(singleTap)*/
                
                listPatrocinadores.append(patrocinadores)
            }
        }
        catch{
            print(error)
        }
    }
    
    /*//Evento de la imagen
    func tapDetected(url:String) {
       // let archivo = listPatrocinadores[indexPath.row]["descripcion"] as! String
        UIApplication.shared.openURL(URL(string: url )!)
    }*/
    
    func stringToDate(date:String)->Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let fecha = dateFormatter.date(from: date)
        
        return fecha!
    }
    
    func convertdate(hora_inicio: String, hora_fin:String)->String{
        
        let dateString = hora_inicio
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let hour = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "h:mm a"
        let stringFromeDate = dateFormatter.string(from: hour!)
        
        let dateStringFin = hora_fin
        let dateFormatterFin = DateFormatter()
        dateFormatterFin.dateFormat = "HH:mm:ss"
        let hourFin = dateFormatterFin.date(from: dateStringFin)
        dateFormatterFin.dateFormat = "h:mm a"
        let stringFromeDateFin = dateFormatter.string(from: hourFin!)
        
        let finalhour = "\(stringFromeDate) / \(stringFromeDateFin)"
        
        return finalhour
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)

    }
    
    
    
    //MARK: Tableview menu eventos
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if tableView == self.tableMenuEvent{
            return listEventos.count
        }
        else{
            return listActividades.count
        }            
    }
    var heigthCellMenu = 0
    var heigthCellEvento = 0
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == self.tableMenuEvent{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellEvento", for: indexPath) as! evento1TableViewCell
            configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            heigthCellMenu = Int(Double(cell.frame.height))
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOnline", for: indexPath) as! actividadesTableViewCell
            configureCellMenu(cell: cell, indexPath: indexPath as NSIndexPath)
            heigthCellEvento = Int(Double(cell.frame.height))
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableMenuEvent{
            
            if(indexPath.row == 0){
                
                let vistaAgenda = storyboard?.instantiateViewController(withIdentifier: "agenda") as! vista_11_agendaController
                vistaAgenda.listActividades = self.listActividadesAll
                vistaAgenda.id_evento=self.itemToShow
                vistaAgenda.id_asistente = id_asistente
                vistaAgenda.patrocinadores = self.listPatrocinadores
                self.navigationController?.pushViewController(vistaAgenda, animated: true)
            }
            if(indexPath.row == 1){
                
                let vistaCarnet = storyboard?.instantiateViewController(withIdentifier: "carnet") as! vista_8_carneController
                vistaCarnet.id_evento = self.itemToShow
                vistaCarnet.celular = self.celular
                self.navigationController?.pushViewController(vistaCarnet, animated: true)
            }
            if(indexPath.row == 2){
                
                let vistaAsistentes = storyboard?.instantiateViewController(withIdentifier: "asistentes") as! vista_5_asistentesController
                vistaAsistentes.id_evento = self.itemToShow
                vistaAsistentes.nombreEvento = self.nombreEvento.text
                self.navigationController?.pushViewController(vistaAsistentes, animated: true)
            }
            if(indexPath.row == 3){
                
                let vistaEmpresas = storyboard?.instantiateViewController(withIdentifier: "empresas") as! vista_4_empresasController
                vistaEmpresas.id_evento = self.itemToShow
                vistaEmpresas.nombreEvento = self.nombreEvento.text
                self.navigationController?.pushViewController(vistaEmpresas, animated: true)
            }
            if(indexPath.row == 4){
               
                
            }
            if(indexPath.row == 5){
                
                let vistamemorias = storyboard?.instantiateViewController(withIdentifier: "memorias") as! vista_9_memoriasController
                vistamemorias.id_evento = self.itemToShow
                self.navigationController?.pushViewController(vistamemorias, animated: true)
            }

            
        }
        else{
            let vistamemorias = storyboard?.instantiateViewController(withIdentifier: "audio") as! vista_6_traductorController
            vistamemorias.id_evento = self.itemToShow
            vistamemorias.patrocinadores = self.listPatrocinadores
            self.navigationController?.pushViewController(vistamemorias, animated: true)
        }
        
    }
    
    func configureCell(cell: evento1TableViewCell, indexPath: NSIndexPath){
        
        let nombreObtion:String = listEventos[indexPath.row]["nameOption"] as! String
        let descritionObtion:String = listEventos[indexPath.row]["descriptionOption"] as! String
        let logo:String = listEventos[indexPath.row]["image"] as! String
        cell.configureCell(imageEvento:logo, nombreOption:nombreObtion, descriptionOption:descritionObtion )
    }

    func configureCellMenu(cell: actividadesTableViewCell, indexPath: NSIndexPath){
        
      
        let nombre:String = listActividades[indexPath.row]["nombre"] as! String
        let hora_inicio:String = listActividades[indexPath.row]["hora_inicio"] as! String
        let hora_fin:String = listActividades[indexPath.row]["hora_fin"] as! String
        cell.configureCell(nameEvent:nombre, hourEvent:convertdate(hora_inicio: hora_inicio, hora_fin: hora_fin) )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.white
    }
    
}

extension Date{
    func isBetween(date dateInicio:Date, andDate dateFinal:Date)->Bool{
        return dateInicio.compare(self as Date) == self.compare(dateFinal as Date)
    }
}
