//
//  ViewController.swift
//  Peticion Servidor
//
//  Created by Carlos Mauricio Idárraga Espitia on 4/8/16.
//  Copyright © 2016 Carlos Mauricio Idárraga Espitia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

 //   @IBOutlet weak var outLibro: UITextView!
    @IBOutlet weak var editLibro: UITextField!
    @IBOutlet weak var outTitulo: UITextView!
    @IBOutlet weak var outAutor: UITextView!
    @IBOutlet weak var outPortada: UITextView!
    
    @IBOutlet weak var outImagePortada: UIImageView!
    
   // @IBOutlet weak var searchBar: UISearchBar!
    
    var txtValue: UITextField?!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editLibro.delegate=self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func BtnBuscar(sender: AnyObject) {
               async(editLibro.text!)
    }
    
    @IBAction func textFieldDoneEditing(sender:UITextField){
        sender.resignFirstResponder() //Desaparece teclado presionando enter o search
    }
    
    @IBAction func backgroundTap(sender: UIControl){ //Desaparece teclado cuando doy clic en otro lugar de la pantalla
        editLibro.resignFirstResponder()
    }
    

    @IBAction func BtnLimpiar(sender: AnyObject) {
         outTitulo.text = "";
         outAutor.text="";
         outPortada.text="";
         outImagePortada.image = nil;
       //  editLibro.text = "";
    }
    //978-84-376-0494-7    
    //9788497592437  libro con portada
    func async(isbn:String){
        
        let urls:String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
       //  let urls:String = "\(isbn)"
        let url = NSURL(string: urls)
        let sesion = NSURLSession.sharedSession()
        let bloque = {
            
            (datos : NSData?, resp : NSURLResponse?, error : NSError?) -> Void in
            
            if error != nil {
                //callback(“”, error.localizedDescription)
                dispatch_sync(dispatch_get_main_queue()) {//
                    self.setInfo("",isbn: "")
                }
            } else {
              //  let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                do{
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                    
                    print("datos: \(json)")
                   
                    dispatch_sync(dispatch_get_main_queue()) {
                        self.setInfo(json,isbn: isbn)
                    }
                    
                }catch _ {
                
                }
            }
        }
        
        let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
        dt.resume()
        print("antes o despues")
    }
    
    
 /*   func setInfo(msj: String){
        
        if(msj != ""){
            outLibro.text=String(msj)
        }else{
            let alertController = UIAlertController(title: "", message:
                "Por favor revisa tu conexión a internet", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }*/
    
    func setInfo(msj: AnyObject, isbn: String){
        
        // viewData(msj,isbn: isbn)
        
        if (isbn != ""){
           // outLibro.text=String(msj)
                viewData(msj,isbn: isbn)
        }else{
            let alertController = UIAlertController(title: "", message:
                "Por favor revisa tu conexión a internet", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func viewData(json : AnyObject, isbn: String){
        
        print("\(json) ......... \(isbn)")
        var titulo : String = "";
        
        let dico1 = json as! NSDictionary
        let dico2 = dico1["ISBN:\(isbn)"] as! NSDictionary
        if( dico2["title"] != nil ){
            titulo = dico2["title"] as! NSString as String //Titulo del libro
        }
        
        var authors : String = "";
        
        
        
        //http://www.iberlibro.com/servlet/SearchResults?isbn=9788497592437&sts=t
        
        if(dico2["authors"] != nil){
             let dico3 = dico2["authors"] as! NSArray
            for index in dico3{
                let dico4 = index as! NSDictionary
                let dico5 = dico4["name"] as! NSString as String
                print("Authores: \n\(dico5)")
                authors = authors + "\(dico5)\n"
            }
        }
        
        
        //var dico6 = ""
        
        /*if(dico2["cover"] != nil){
            dico6 = dico2["cover"] as! NSString as String
            
            
            
        }*/
        
        print("Titulo del libro: \(titulo)")
        print("Autor: \(authors)")
        
        outTitulo.text = ("Titulo del libro: \(titulo)")
        outAutor.text = ("Autor: \(authors)")
        
        if(dico2["cover"] != nil){
            let dico6 = dico2["cover"] as! NSDictionary
            let portada: String = dico6["large"] as! NSString as String
       // if let url = NSURL(string: "https://covers.openlibrary.org/b/id/7306541-L.jpg") {
             if let url = NSURL(string: "\(portada)") {
            if let data = NSData(contentsOfURL: url) {
                outPortada.text = "Portada"
                outImagePortada.image = UIImage(data: data)
            }
         }
            print("Portada: \(dico6)")

        }else{
            outPortada.text = "Sin Portada"
            outImagePortada.image = nil
        }
        
        

       /* if let url = NSURL(string: "https://covers.openlibrary.org/b/id/7306541-L.jpg") {
            if let data = NSData(contentsOfURL: url) {
                outImagePortada.image = UIImage(data: data)
            }
        }*/

        
       // outImagePortada
        
        
        

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
         async(editLibro.text!)
        return true
    }
}



