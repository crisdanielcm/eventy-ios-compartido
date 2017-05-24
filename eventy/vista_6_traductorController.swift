//
//  vista_6_traductorController.swift
//  eventy
//
//  Created by Cristian Cruz on 5/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit
import Alamofire
import CallKit

class vista_6_traductorController: BaseViewController {

    
    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var backLogo: UIImageView!
    typealias JSONStandard = [String : AnyObject]
    var id_evento:Int!
    
    var patrocinadores = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.white
        paserDataPatrocinadores()
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
    
    @IBAction func playPressed(_ sender: UIButton) {
        let imagename = sender.currentImage
        let imagePlay = UIImage(named: "PLAY")
        let imagePausa = UIImage(named: "pause")
        if(imagename == imagePlay){
            self.buttonPlay.setImage(imagePlay, for: .normal)
            self.buttonPlay.setImage(imagePausa, for: .highlighted)
            self.backLogo.image = UIImage(named: "backLogoPause")
        }else if(imagename == imagePausa){
            self.buttonPlay.setImage(imagePausa, for: .normal)
            self.buttonPlay.setImage(imagePlay, for: .highlighted)
            self.backLogo.image = UIImage(named: "backLogo")
        }
        
    }
    
    func paserDataPatrocinadores(){
    
            let widthScreen = Int(self.subview.frame.width)
            let heightScreen = self.subview.frame.height
            var x = 0
            var i = 0
        if(patrocinadores.count != 0){
            let widthImage = widthScreen/patrocinadores.count
            for item in patrocinadores {
                
                let logo:String = item["patrocinador"] as! String
                let imageView = UIImageView()
                imageView.contentMode = UIViewContentMode.scaleAspectFit
                imageView.kf.setImage(with: URL(string:logo), placeholder:nil)
                imageView.frame = CGRect(x: x, y: Int(heightScreen)/8, width: widthImage, height: Int(Double(heightScreen)/1.3))
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(tapGestureRecognizer)
                imageView.tag = i
                subview.addSubview(imageView)
                x = x + widthImage
                i += 1
            }

        }
    }
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let tag = tappedImage.tag
        let url:String = self.patrocinadores[tag]["url"] as! String
        let url2 = URL(string:url)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url2!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url2!)
        }
        // Your action
    }

    
    @IBAction func close(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    


}
