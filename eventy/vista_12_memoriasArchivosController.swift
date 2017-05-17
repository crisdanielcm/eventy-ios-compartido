//
//  vista_12_memoriasArchivosController.swift
//  eventy
//
//  Created by Cristian Cruz on 18/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit
import Alamofire

class vista_12_memoriasArchivosController: BaseViewController, UITableViewDataSource, UITableViewDelegate
{
    
    var listMemoriasA=[[String:Any]]()
    @IBOutlet weak var tableMArchivos: UITableView!
    var nombreA:String = " "
    
    @IBOutlet weak var nombreArchivo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.white
        nombreArchivo.text = nombreA
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Actions
    */

    override func viewWillAppear(_ animated: Bool) {
        if let nav = self.navigationController?.navigationBar {
            nav.setBackgroundImage(UIImage(), for: .default)
            nav.shadowImage = UIImage()
            nav.isTranslucent = true
        }
    }
    
    
    /*
     MARK: Table
     */
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return listMemoriasA.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let archivo = listMemoriasA[indexPath.row]["archivo"]
        UIApplication.shared.openURL(URL(string: archivo as! String)!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMarchivo", for: indexPath) as! memoriasArchivosTableViewCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: memoriasArchivosTableViewCell, indexPath: NSIndexPath){
        
        let nombre:String = listMemoriasA[indexPath.row]["nombre"] as! String
        cell.configureCell(nombre:nombre )
    }

    @IBAction func close(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
