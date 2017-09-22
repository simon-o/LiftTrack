//
//  FormsViewController.swift
//  LiftTrack
//
//  Created by Antoine Simon on 24/06/2017.
//  Copyright © 2017 Viseo Digital. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FormsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var exoName: UITextField!
    @IBOutlet weak var exoRep: UITextField!
    @IBOutlet weak var exoSerie: UITextField!
    @IBOutlet weak var exoKG: UITextField!
    @IBOutlet weak var imageBook: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var test: NSLayoutConstraint!
    var ref = FIRDatabase.database().reference()
    
    var limiteKG = 200
    var limiteSerie = 20
    var limiteRep = 40
    
    var date:Date!
    var modif = false
    var node : String?
    var tmpKG :String?
    var tmpName : String?
    var tmpRep : String?
    var tmpSerie : String?
    var tmpDate : String?
    
    var exos = [String]()
    var exoNameList = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseExo()

        exoName.attributedPlaceholder = NSAttributedString(string: exoName.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        exoRep.attributedPlaceholder = NSAttributedString(string: exoRep.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        exoSerie.attributedPlaceholder = NSAttributedString(string: exoSerie.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        exoKG.attributedPlaceholder = NSAttributedString(string: exoKG.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 20.0, height: exoName.frame.size.height))
        exoName.leftView = padding
        exoName.leftViewMode = UITextFieldViewMode.always
        let padding2 = UIView(frame: CGRect(x: 0, y: 0, width: 20.0, height: exoRep.frame.size.height))
        exoRep.leftView = padding2
        exoRep.leftViewMode = UITextFieldViewMode.always
        let padding3 = UIView(frame: CGRect(x: 0, y: 0, width: 20.0, height: exoSerie.frame.size.height))
        exoSerie.leftView = padding3
        exoSerie.leftViewMode = UITextFieldViewMode.always
        let padding4 = UIView(frame: CGRect(x: 0, y: 0, width: 20.0, height: exoKG.frame.size.height))
        exoKG.leftView = padding4
        exoKG.leftViewMode = UITextFieldViewMode.always
        
        exoName.delegate = self
        exoRep.delegate = self
        exoSerie.delegate = self
        exoKG.delegate = self
        
        if let tmp = tmpKG{
            exoKG.text = tmp
        }
        if let tmp = tmpRep{
            exoRep.text = tmp
        }
        if let tmp = tmpSerie{
            exoSerie.text = tmp
        }
        if let tmp = tmpName{
            exoName.text = tmp
        }
        
        exoName.tag = 0
        exoRep.tag = 1
        exoSerie.tag = 2
        exoKG.tag = 3
        
        //CONF PARAM
        ref.observeSingleEvent(of: .value, with: { (snap) in
            if !snap.exists() { return }
            let tmp = snap.value as! [String:Any]
            if let tmpKG = tmp["limiteKG"] as? Int{
                self.limiteKG = tmpKG
            }
            if let tmpRep = tmp["limiteRep"] as? Int{
                self.limiteRep = tmpRep
            }
            if let tmpSerie = tmp["limiteSerie"] as? Int{
                self.limiteSerie = tmpSerie
            }
        })
        
        if (UIDevice().screenType == .iPhone4){
          imageBook.isHidden = true
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if (imageBook.isHidden == true){
            test.constant -= 50
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func containIn(_ str: String) -> Bool{
        if (exoNameList.count > 0){
            if (exoNameList.contains(where: { (row) -> Bool in
                if (str == row["value"]){
                    return true
                }
                return false
            })
                ){
                return true
            }
        }
        return false
    }
    
    func parseExo(){
        ref.child("users").child(UserDefaults.standard.string(forKey: "userUID")!).child("exosList").observeSingleEvent(of: .value, with: { (snap) in
            if !snap.exists() { return }
            
            let tmp = snap.value as! [String:Any]
            for index in tmp{
                self.exoNameList.append(["value" : index.key])
            }
        })
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let picker = PickerDialog()
        
        switch textField.tag {
        case 0:
            if (exoNameList.count > 0){
                picker.show(title: "Choisissez l'exercice", options: exoNameList) { (response) in
                    self.exoName.text = response
                }
            }
            else{
                addExoTapped(self)
            }
        case 1:
            var i = 0
            var tmp = [[String:String]]()
            for _ in 0...self.limiteRep{
                tmp.append(["value":String(i)])
                i += 1
            }
            picker.show(title: "Choisissez le nombre de repetition", options: tmp) { (response) in
                self.exoRep.text = response
            }
        case 2:
            var i = 0
            var tmp = [[String:String]]()
            
            for _ in 0...self.limiteSerie{
                tmp.append(["value":String(i)])
                i += 1
            }
            picker.show(title: "Choisissez le nombre de serie", options: tmp) { (response) in
                self.exoSerie.text = response
            }
        case 3:
            var i = 0.0
            var tmp = [[String:String]]()
            
            for _ in 0...self.limiteKG{
                tmp.append(["value":String(i)])
                i += 0.5
            }
            picker.show(title: "Choisissez le poid utilisé", options: tmp) { (response) in
                self.exoKG.text = response
            }
        default: break
        }
        
    }
    
    @IBAction func addExoTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Ajouter un nouvel exercice", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addTextField(configurationHandler: { (configurationTextField) in
            })
        alert.addAction(UIAlertAction(title: "Ajouter", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            if let textField = alert.textFields?.first?.text {
                self.exos.append(textField)
                self.exoName.text = textField
            }
        }))
        self.present(alert, animated: true, completion: {
        })
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        if (exoName.text == "" || exoRep.text == "" || exoSerie.text == "" || exoKG.text == ""){
            let alert = UIAlertController(title: "Erreur", message: "Vous devez remplir tous les champs", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if let user = UserDefaults.standard.object(forKey: "userUID") as? String{
            if exoName.text != ""{
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy MM dd"
                
                if (modif == false){
                    let tmpDay = formatter.string(from: date)
                    ref.child("users").child(user).child("exosList").child(exoName.text!).childByAutoId().setValue(["name":exoName.text!, "KG": exoKG.text!, "serie":exoSerie.text!, "rep":exoRep.text!, "date":tmpDay])
                }
                else{
                    ref.child("users").child(user).child("exosList").child(exoName.text!).child(node!).setValue(["name":exoName.text!, "KG": exoKG.text!, "serie":exoSerie.text!, "rep":exoRep.text!, "date":tmpDate])
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension UIDevice {
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case unknown
    }
    var screenType: ScreenType {
        guard iPhone else { return .unknown }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        default:
            return .unknown
        }
    }
}
