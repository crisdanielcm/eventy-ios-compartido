//
//  vista_11_agendaController.swift
//  eventy
//
//  Created by Cristian Cruz on 14/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit
import Alamofire

class vista_11_agendaController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableAgenda: UITableView!
    var selectedIndex = -1
    var listActividades = [[String:Any]]()
    var id_evento:Int?
    var id_asistente:Int!
    var patrocinadores = [[String:Any]]()


    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSlideMenuButton()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.white
        print(listActividades)
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
    
    func stringToDate(date:String)->Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let fecha = dateFormatter.date(from: date)
        
        return fecha!
    }
    
    //MARK: Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listActividades.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(selectedIndex == indexPath.row){
            return 155
        }else{
            return 92
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "agendaCell", for: indexPath) as! agendaTableViewCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(selectedIndex == indexPath.row){
            selectedIndex = -1
        }else{
            selectedIndex = indexPath.row
        }
        
        self.tableAgenda.beginUpdates()
        
        self.tableAgenda.reloadRows(at: [indexPath], with: .automatic)
        self.tableAgenda.endUpdates()
    }
    
    func configureCell(cell: agendaTableViewCell, indexPath: NSIndexPath){
        
        let nombre:String = listActividades[indexPath.row]["nombre"] as! String
        let hora_inicio:String = listActividades[indexPath.row]["hora_inicio"] as! String
        let hora_fin:String = listActividades[indexPath.row]["hora_fin"] as! String
        let fecha_inicio = listActividades[indexPath.row]["fecha_inicio"] as! String
        let dateInicio = "\(fecha_inicio)-\(hora_inicio)"
        let dateFin = "\(fecha_inicio)-\(hora_fin)"
        let date = Date()
        let enVivo = date.isBetween(date: stringToDate(date: dateInicio), andDate: stringToDate(date: dateFin))
        let id_actividad = listActividades[indexPath.row]["id"] as! Int
        cell.id_actividad = id_actividad
        cell.id_evento = self.id_evento
        cell.id_asistente = id_asistente
        cell.navigationController = self
        cell.patrocinadores = self.patrocinadores
        
        cell.configureCell(nombre:nombre, hora:convertdate(hora_inicio: hora_inicio, hora_fin: hora_fin), envivo: enVivo)
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
    
    @IBAction func close(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

