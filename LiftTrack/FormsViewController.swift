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
    
    var ref = FIRDatabase.database().reference()
    
    var limiteKG = 200
    var limiteSerie = 20
    var limiteRep = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func test(){
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let picker = PickerDialog()
        
        switch textField.tag {
        case 0:
            picker.show(title: "Choisissez l'exercice", options: [["value":"l"],["value":"p"],["value":"g"]]) { (response) in
                print(response)
            }
        case 1:
            var i = 0
            var tmp = [[String:String]]()
            for _ in 0...self.limiteRep{
                tmp.append(["value":String(i)])
                i += 1
            }
            picker.show(title: "Choisissez le nombre de repetition", options: tmp) { (response) in
                print(response)
            }
        case 2:
            var i = 0
            var tmp = [[String:String]]()
            
            for _ in 0...self.limiteSerie{
                tmp.append(["value":String(i)])
                i += 1
            }
            picker.show(title: "Choisissez le nombre de serie", options: tmp) { (response) in
                print(response)
            }
        case 3:
            var i = 0.0
            var tmp = [[String:String]]()
            
            for _ in 0...self.limiteKG{
                tmp.append(["value":String(i)])
                i += 0.5
            }
            picker.show(title: "Choisissez le poid utilisé", options: tmp) { (response) in
                print(response)
            }
        default: break
        }
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
    }
}
