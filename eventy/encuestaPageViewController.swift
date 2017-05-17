//
//  encuestaPageViewController.swift
//  eventy
//
//  Created by Cristian Cruz on 27/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit
import Alamofire

class encuestaPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    

    @IBOutlet weak var tableEncuesta: UITableView!
    @IBOutlet weak var nombrePregunta: UILabel!
    typealias JSONStandard = [String : AnyObject]
    var listEncuestas = [[String:Any]]()
    var texto:String = ""
    var pos:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nombrePregunta.text = texto
        self.tableEncuesta.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Table
    */
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return listEncuestas.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.getCellsData(current: indexPath, tableView: tableView)
        let id = listEncuestas[indexPath.row]["id"] as! Int
        let parameter:Parameters = ["id_opcion": id]
        request("\(ip)/registrar_voto/", method: .post,parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON{ response in
            switch response.result{
            case .success:
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getCellsData(current:IndexPath, tableView: UITableView ) {
        
        for section in 0 ..< tableView.numberOfSections {
            for row in 0 ..< tableView.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                if let cell = tableView.cellForRow(at: indexPath) as? encuestaTableViewCell {
                    if(row == current.row){
                        cell.changeImagen(seleccion:false)
                    }else{
                        cell.changeImagen(seleccion:true)
                    }
                }
                
            }
        }
    }
    func visible(current:IndexPath, tableView: UITableView ){
        let celda = tableView.visibleCells
        for section in 0 ..< celda.count {
            let cell = celda[section] as! encuestaTableViewCell
            if(section == current.row){
                cell.changeImagen(seleccion:false)
            }else{
                cell.changeImagen(seleccion:true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "encuestaCell", for: indexPath) as! encuestaTableViewCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: encuestaTableViewCell, indexPath: NSIndexPath){
        let nombre:String = listEncuestas[indexPath.row]["texto"] as! String
        cell.configureCell(nombre:nombre, seleccion:true )
    }

}
