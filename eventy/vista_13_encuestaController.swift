//
//  vista_13_encuestaController.swift
//  eventy
//
//  Created by Cristian Cruz on 25/02/17.
//  Copyright © 2017 Apliko. All rights reserved.
//

import UIKit
import Alamofire

class vista_13_encuestaController: BaseViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    @IBOutlet weak var btn_siguente: UIButton!
    @IBOutlet weak var subview: UIView!
    typealias JSONStandard = [String : AnyObject]
    var listEncuestas = [[String:Any]]()
    var pages = [UIViewController]()
    var id_actividad:Int?
    var patrocinadores = [[String:Any]]()
    
    // The UIPageViewController
    var pageContainer: UIPageViewController!
    
    // Track the current index
    var currentIndex = 0
    
    private var pendingIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.white
        doRequest()
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
    
    func doRequest(){
        
        let parameter1:Parameters = ["id_actividad": id_actividad!]
        request("\(ip)/obtener_preguntas/", method: .post,parameters: parameter1, encoding: JSONEncoding.default).validate().responseJSON{ response in
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
                
                let pregunta = itemJson["texto"] as! String
                let respuestas = itemJson["opcion_set"] as! NSArray
                var respuestasArray = [[String:Any]]()
                for respuesta in respuestas {
                    let json = respuesta as! JSONStandard
                    let id = json["id"] as! Int!
                    let numeral = json["numeral"] as! String
                    let texto = json["texto"] as! String
                    let infoOption2:[String: Any]  = ["texto" : texto, "id":id!, "numeral": numeral]
                    respuestasArray.append(infoOption2)
                    
                }
                let infoOption:[String: Any]  = ["nombre":pregunta,"respuestas": respuestasArray] as [String : Any]
                listEncuestas.append(infoOption)
            }
            pagesInit()
        }
        catch{
            print(error)
        }
    }
    
    func paserDataPatrocinadores(){
        
        let widthScreen = Int(self.subview.frame.width)
        let heightScreen = self.subview.frame.height
        var x = 0
        if(patrocinadores.count != 0){
            let widthImage = widthScreen/patrocinadores.count
            for item in patrocinadores {
                
                let logo:String = item["patrocinador"] as! String
                
                
                let imageView = UIImageView()
                imageView.contentMode = UIViewContentMode.scaleAspectFit
                imageView.kf.setImage(with: URL(string:logo), placeholder:nil)
                imageView.frame = CGRect(x: x, y: Int(heightScreen)/8, width: widthImage, height: Int(Double(heightScreen)/1.3))
                subview.addSubview(imageView)
                x = x + widthImage
            }
            
        }
    }
    
    func pagesInit(){
        // Setup the pages
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var i = 0
        for item in listEncuestas{
            
            let page1 = storyboard.instantiateViewController(withIdentifier: "encuestaPage") as! encuestaPageViewController
            page1.pos = i
            i = i + 1
            page1.texto = item["nombre"] as! String
            page1.listEncuestas = item["respuestas"] as! [[String : Any]]
            pages.append(page1)
        }
        // Create the page container
        pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageContainer.delegate = self
        pageContainer.dataSource = self
        if(pages.count == 1){
            self.btn_siguente.setTitle("FINALIZAR", for: .normal)
        }
        if(pages.count > 0){
            pageContainer.setViewControllers([pages[0]], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
            // Add it to the view
            viewContainer.addSubview(pageContainer.view)
            currentIndex = 0
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    /*
    // MARK: PageView
    }
    */
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        /**let currentIndex = pages.index(of: viewController)!
        if currentIndex == pages.count-1 {
            return nil
        }
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]**/
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        /**let currentIndex = pages.index(of: viewController)!
        if currentIndex == 0 {
            return nil
        }
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]**/
        return nil
    }
    

    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    
    }
    
    @IBOutlet weak var viewContainer: UIView!
    @IBAction func siguientePress(_ sender: UIButton) {
        
        currentIndex += 1
        if(currentIndex < pages.count){
            
            pageContainer.setViewControllers([pages[currentIndex]],
                                             direction: UIPageViewControllerNavigationDirection.forward,
                                             animated: true,
                                             completion: nil)
            if(currentIndex == pages.count-1){
                sender.setTitle("FINALIZAR", for: .normal)
            }
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
