//
//  agendaTableViewCell.swift
//  eventy
//
//  Created by Cristian Cruz on 14/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit

class agendaTableViewCell: UITableViewCell {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var section: UILabel!
    @IBOutlet weak var nombre: UITextView!
    @IBOutlet weak var hora: UITextView!
    @IBOutlet weak var audio: UIButton!
    @IBOutlet weak var encuesta: UIButton!
    @IBOutlet weak var fondo: UIImageView!
    @IBOutlet weak var preguntas: UIButton!
    var id_actividad:Int?
    var navigationController : UIViewController? = nil
    var id_evento:Int?
    var id_asistente:Int!
    var patrocinadores = [[String:Any]]()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(nombre: String, hora: String, envivo: Bool){
        
        self.nombre.text = nombre
        self.hora.text = hora
        if(envivo){
            fondo.image = UIImage(named: "HeaderBackground")
            audio.isEnabled = true
            encuesta.isEnabled = true
            preguntas.isEnabled = true
            
        }else{
            fondo.image = UIImage(named: "")
            audio.isEnabled = false
            encuesta.isEnabled = false
            preguntas.isEnabled = false
        }
    }
    
    @IBAction func encuestaPressed(_ sender: UIButton) {
        if (self.encuesta.isEnabled) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let view = storyBoard.instantiateViewController(withIdentifier: "vista_13_encuestaController") as! vista_13_encuestaController
            view.id_actividad = self.id_actividad
            view.patrocinadores = self.patrocinadores
            self.navigationController?.navigationController?.pushViewController(view, animated: true)
        }
        
    }
    
    @IBAction func preguntaPressed(_ sender: UIButton) {
        if (self.preguntas.isEnabled) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let view = storyBoard.instantiateViewController(withIdentifier: "preguntas") as! vista_14_preguntasController
            view.id_actividad = self.id_actividad
            view.id_evento = self.id_evento
            view.id_asistente = id_asistente
            self.navigationController?.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    @IBAction func audioPressed(_ sender: UIButton) {
        if (self.audio.isEnabled) {
            let view = navigationController?.storyboard?.instantiateViewController(withIdentifier: "audio") as! vista_6_traductorController
            view.id_evento = self.id_evento
            view.patrocinadores = self.patrocinadores
            self.navigationController?.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    
}
